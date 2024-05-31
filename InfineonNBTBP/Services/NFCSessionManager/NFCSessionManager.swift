// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import CoreNFC
import Foundation
import InfineonApdu
import InfineonApduNbt
import InfineonChanneliOSNfc
import InfineonConsoleLogger

/// The `NFCSessionManager` class serves as a manager for NFC tag reader sessions. It inherits from
/// `NSObject` and adopts the `NFCTagReaderSessionDelegate` protocol, allowing it to handle NFC tag
/// reader session events. Additionally, it conforms to the `ObservableObject` protocol, enabling it
/// to be observed for changes in its properties.
///
/// Usage:
/// - The ``NFCSessionManager`` class should be instantiated to perform NFC operations.
/// - It handles NFC tag reader sessions and delegates using the ``NFCTagReaderSessionDelegate``
/// protocol.
/// - It can be observed for changes using the ``ObservableObject`` protocol.
class NFCSessionManager: NSObject, NFCTagReaderSessionDelegate, ObservableObject {
    /// An optional property holder for the ``BPUseCaseManager`` which provides API related to brand
    /// protection (BP) use case supported by `OPTIGA™ Authenticate NFC (NBT) - Brand
    /// Protection` device.
    ///
    /// - Important: This property is `nil` when there is no active NFC tag reader session.
    ///
    /// - SeeAlso: ``BPUseCaseManager``
    var bpUseCaseManager: BPUseCaseManager?

    /// An optional property holder for the NbtCommandSet which provides the API supported by the
    /// `OPTIGA™ Authenticate NFC (NBT) - Brand Protection` device  application.
    ///
    /// - Important: This property is `nil` when there is no active NFC tag reader session.
    ///
    /// - SeeAlso: ``NBTCommandSet``
    var nbtCommandSet: NbtCommandSet?

    /// An optional property holds an instance of ``NFCTagReaderSession``. It is used to establish a
    /// connection with an NBT device and perform NFC operations with  NBT device.
    ///
    /// - Important: This property may be `nil` when there is no active NFC tag reader session.
    ///
    /// - SeeAlso: ``NFCTagReaderSession``
    var tagReaderSession: NFCTagReaderSession?

    /// A published property that represents the message related to ``NFCTagReaderSession``
    /// operations.
    ///
    /// - Remark: The ``message`` property is marked with the ``@Published`` property wrapper,
    /// allowing it to automatically publish changes to any subscribers. When the value of `message`
    /// changes, the associated views are updated accordingly.
    ///
    /// - Note: The initial value of ``message`` is set to ``.empty``.
    ///
    /// - SeeAlso: ``NFCTagReaderSession`` and ``@Published``
    @Published var message: String = .empty

    /// A published property that represents possible states of an NFC reader session during NFC tag
    /// interaction.
    ///
    /// - Remark: The ``nfcReaderSessionState`` property is marked with the ``@Published`` property
    /// wrapper, allowing it to automatically publish changes to any subscribers. When the value of
    /// ``nfcReaderSessionState`` changes, the associated views are updated accordingly.
    ///
    /// - Note: The initial value of ``nfcReaderSessionState`` is set to ``.initial``.
    @Published var nfcReaderSessionState: NFCReaderSessionState = .initial

    /// Method to update message property to store and update the message of the
    /// ``NFCTagReaderSession`` operations.
    ///
    /// - Note: Method executed on ``DispatchQueue.main.async`` to publish the changes to SwiftUI
    /// from non UI thread.
    ///
    /// - Parameter message: Descriptive text message related to ``NFCTagReaderSession`` operations.
    public func setMessage(_ message: String) {
        DispatchQueue.main.async {
            self.message = message
        }
    }

    /// Notifies the delegate that the NFC tag reader session has been invalidated with a error.
    ///
    /// - Parameters:
    ///   - session: The ``NFCTagReaderSession`` that has been invalidated.
    ///   - error: The error that caused the invalidation of the session.
    ///
    /// - Important: Implemented this method to handle the invalidation of the NFC tag reader
    /// session and perform necessary cleanup or error handling
    func tagReaderSession(_: NFCTagReaderSession, didInvalidateWithError error: Error) {
        DispatchQueue.main.async {
            self.tagReaderSession = nil
            self.nfcReaderSessionState = .disconnected
        }
        if let nfcError = error as? NFCReaderError,
           nfcError.code == .readerSessionInvalidationErrorUserCanceled {
            // User canceled the session, no need to show an error message
            return
        }
        let errorMessage = error.localizedDescription.replacingOccurrences(
            of: String.messageSystemResourceNotAvailable,
            with: String.messageNfcNotReady
        )
        setMessage(errorMessage + .messageRetry)
    }

    /// Notifies the delegate that the NFC tag reader session is active. Called when the tag reader
    /// session becomes active and is ready to detect tags.
    ///
    /// - Parameter session: The session object that has become active.
    func tagReaderSessionDidBecomeActive(_: NFCTagReaderSession) {
        nfcReaderSessionState = .polling
    }

    /// Notifies the delegate that the NFC tag reader session detected NFC tags.
    ///
    /// - Parameter session: session The session that detected the tags.
    /// - Parameter tags: An array of NFC tags detected by the NFC reader session.
    /// - Note: Upon detecting tags, this function is responsible for performing operations such as
    /// instantiates the ``BPUseCaseManager`` , ``NBTCommandSet``, connecting to the tag and
    /// selecting the NBT applet to initiate brand protection (BP) operations. It also call the
    /// `initiateNBTDeviceCommunication()` method to proceed with further brand protection (BP)
    /// operations.
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        do {
            // Return if multiple tag detected
            if tags.count > 1 {
                return
            }
            // Instantiates the ``APDUChannel`` with console logger.
            let apduChannel = ApduChannel(
                channel: NfcChannel(tag: tags.first!, readerSession: session),
                logger: ConsoleLogger.getConsoleLogger()
            )
            // Instantiates the ``NbtCommandSet`` with APDU channel.
            nbtCommandSet = try NbtCommandSet(channel: apduChannel)

            // Instantiates the ``BPUseCaseManager`` with NBT command set.
            bpUseCaseManager = BPUseCaseManager(
                nbtCommandSet: nbtCommandSet!
            )
            /// Start the further NFC communication operation background thread as needed.
            Task {
                do {
                    // Connect to NBT device
                    _ = try await nbtCommandSet!.connect(data: Data())

                    // Update NFC reader session state for UI changes and other logic
                    DispatchQueue.main.async {
                        self.nfcReaderSessionState = .connected
                    }
                    // Select the applet on NBT device
                    let response = try await nbtCommandSet!.selectApplication()

                    // If APDU response not success, invalidate the session with an error message
                    // related to applet personalization.
                    guard response.isSuccessSW() else {
                        invalidateSession(errorMessage: .messageCheckAppletIsPersonalized)
                        return
                    }
                    // Invoke the `initiateNBTDeviceCommunication()` method to proceed with further
                    // brand protection (BP) operations.
                    try await initiateNBTDeviceCommunication()
                } catch _ as CertificateError {
                    // Invalidate the session with an error message related to failed to verify
                    // product as we don't want to inform user details about error.
                    invalidateSession(errorMessage: .messageProductFailedToVerify)
                } catch _ as ApduError {
                    // Invalidate the session with an error message related to failed to verify
                    // product as we don't want to inform user details about error
                    invalidateSession(errorMessage: .messageProductFailedToVerify)
                } catch {
                    // Invalidate the session with an error message related to error localized
                    // description
                    invalidateSession(errorMessage: error.localizedDescription)
                }
            }

        } catch _ as ApduError {
            // Invalidate the session with an error message related to failed to verify product as
            // we don't want to inform user details about error.
            invalidateSession(errorMessage: .messageProductFailedToVerify)
        } catch {
            // Invalidate the session with an error message related to error localized description
            invalidateSession(errorMessage: error.localizedDescription)
        }
    }

    /// Method responsible for inItialize and start the ``NFCTagReaderSession`` with polling option
    /// as iso14443 and descriptive alert message.
    ///
    /// - Parameter withAlertMessage: Descriptive text message that is displayed on the alert action
    /// sheet once tag scanning has started.
    public func startNFCTagReaderSession(withAlertMessage: String) {
        if NFCNDEFReaderSession.readingAvailable {
            tagReaderSession = NFCTagReaderSession(
                pollingOption: NFCTagReaderSession.PollingOption.iso14443,
                delegate: self
            )
            message = withAlertMessage
            tagReaderSession?.alertMessage = withAlertMessage
            tagReaderSession?.begin()
        }
    }

    /// Asynchronous method responsible for managing communication with the NBT device. This method
    /// is invoked by the ``NFCSessionManager`` once the NBT device is detected, connected, and the
    /// NBT applet is selected to perform brand protection (BP) operations.
    ///
    /// - Throws: ``AdpuError`` if there is any APDU communication error
    /// - Throws: ``NdefError`` if there is any NDEF error
    /// - Throws: ``CertificateError`` if there is any certificate error
    /// - Throws: ``BPError`` if fails to perform the brand protection (BP) operations
    ///
    /// - Note: Subclasses should override this method to implement specific use case operations.
    dynamic func initiateNBTDeviceCommunication() async throws {}

    /// Method responsible for invalidate NFC reader session to end communication form the tag with
    /// error message
    ///
    /// - Parameter errorMessage: Descriptive text message that is displayed on the alert action
    /// sheet once tag scanning has invalidated.
    func invalidateSession(errorMessage: String) {
        DispatchQueue.main.async {
            self.message = errorMessage
            self.nfcReaderSessionState = .disconnected
            self.tagReaderSession?.invalidate(errorMessage: self.message)
        }
        try? nbtCommandSet?.disconnect()
    }
}
