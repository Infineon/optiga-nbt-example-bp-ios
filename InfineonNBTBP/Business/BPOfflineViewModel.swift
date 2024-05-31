// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonApdu

/// The ``BPOfflineViewModel`` class serves as a ViewModel providing the logic for brand protection
/// operations related to the NBT device.  It
/// conforms to the ``NFCSessionManager`` to effectively manage NFC reader sessions for the purpose
/// of authenticating NBT devices for brand protection. It can be
/// also observed for changes using the ``ObservableObject`` protocol.
///
/// - SeeAlso: ``NFCSessionManager`` and ``ObservableObject``
class BPOfflineViewModel: NFCSessionManager {
    /// A published property that represents the verification status of a brand protection
    /// operation. It holds a boolean value indicating whether the operation has been verified or
    /// not.
    ///
    /// - Remark: The ``isVerified`` property is marked with the ``@Published`` property wrapper,
    /// allowing it to automatically publish changes to any subscribers. When the value of
    /// ``isVerified`` changes, the associated views are updated accordingly.
    ///
    /// - Note: The initial value of ``isVerified`` is set to `nil` as verification of products is
    /// unknown.
    ///
    /// - SeeAlso: ``@Published``
    ///
    @Published public var isVerified: Bool?

    /// Asynchronous method responsible for managing communication with the NBT device. This method
    /// is invoked by the ``NFCSessionManager`` once the NFC device is detected, connected, and the
    /// NBT applet is selected to perform brand protection (BP) operations.
    ///
    /// - Throws: ``AdpuError`` if there is any APDU communication error
    /// - Throws: ``NdefError`` if there is any NDEF error
    /// - Throws: ``CertificateError`` if there is any certificate error
    /// - Throws: ``BPError`` if fails to perform the brand protection (BP) operations
    override func initiateNBTDeviceCommunication() async throws {
        // Update the user interface message as product is verifying.
        DispatchQueue.main.async {
            self.message = .messageProductVerifying
            self.tagReaderSession?.alertMessage = self.message
        }
        // Perform the brand protection (BP) operations. If fails perform the brand protection (BP)
        // operations it throws the `BPError` or other Error
        _ = try await bpUseCaseManager!.performBrandVerification()

        // Update the user interface and message as brand protection (BP) operations successfully
        // verified product.
        DispatchQueue.main.async {
            self.message = .messageProductVerified
            self.tagReaderSession?.alertMessage = self.message
            self.isVerified = true
        }
        try nbtCommandSet!.disconnect()
    }
}
