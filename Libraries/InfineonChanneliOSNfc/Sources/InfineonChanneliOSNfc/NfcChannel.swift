// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import CoreNFC
import Foundation

import InfineonChannel
import InfineonUtils

/// Contains the handlers to transmit ISO7816 commands from IPhone to NFC tag and receive responses.
public class NfcChannel: IChannel {
    /// Error message for invalid APDU bytes.
    ///
    /// This constant holds the error message string that is used when encountering an invalid APDU
    /// byte array. The message informs the user that the provided APDU byte array is invalid and
    /// requests a valid APDU byte array.
    public static let errorMessageInvalidApduBytes =
        "Invalid APDU bytes. Please provide a valid APDU byte array."

    /// Error message if NFCChannel is not open.
    ///
    /// This constant holds the error message string that is used when channel is not open. The
    /// message informs the user that the trying to execute the methods without open the channel.
    public static let errorMessageChannelNotOpen =
        "Channel is not open. Please open the channel before performing any operations."

    /// An object that represents an NFC tag object.
    var tag: NFCTag

    /// An optional object for interacting with an ISO 7816 tag.
    var tagISO7816: NFCISO7816Tag?

    /// An object that represents reader session for detecting ISO7816, ISO15693, FeliCa, and MIFARE
    /// tags.
    var readerSession: NFCTagReaderSession

    /// Marker of channel has been opened
    private var open = false

    /// Initializes the command handler with CoreNFC handles.
    ///
    /// - Parameters:
    ///   - tag: NFC tag handle used for communication with the tag.
    ///   - readerSession: NFC tag handle used for communication with the tag.
    public init(tag: NFCTag, readerSession: NFCTagReaderSession) {
        self.tag = tag
        self.readerSession = readerSession
    }

    /// Checks the NFC tag  is suitable for ISO 7816 tag command exchange if yes it converts the
    /// NFCTag to NFCISO7816Tag.
    ///
    ///  - Parameter exclusive: if true exclusive access to this channel is requested. This
    ///              parameter is not used in this method.
    ///  - Throws An error if opening the channel failed.
    public func open(exclusive _: Bool) throws {
        open = false
        if case let NFCTag.iso7816(tags) = tag {
            tagISO7816 = tags
            open = true
        }
    }

    /// Release communication  ISO 7816 tag instance.
    ///  - Throws An error if releasing the communication port failed.
    public func close() throws {
        open = false
        tagISO7816 = nil
    }

    //// Connects the reader session to a tag and activates that tag.
    ///
    /// - Parameter request: optional request data to be used for connecting to server or null if no
    ///             data required.
    /// - Throws  An error if there is a communication issue with the tag.
    public func connect(request _: Data?) async throws -> Data {
        try await readerSession.connect(to: tag)
        return Data()
    }

    /// Closes the reader session, which prevents it from being reused..
    ///
    ///  - Parameter request: optional request data to be used for closing the connection or null if
    ///              no data required.
    ///  - Throws  An error if disconnecting failed.
    public func disconnect(request _: Data?) throws {
        readerSession.invalidate()
    }

    /// Reset communication channel and restarts the polling sequence so the reader session can
    /// discover new tags.
    /// - Parameter request: optional request data to be used for resetting the connection or null
    ///             if no data required.
    /// - Throws An error if reset request failed.
    public func reset(request _: Data?) throws {
        readerSession.restartPolling()
    }

    /// Sends an application protocol data unit (APDU) to the tag and receives a response APDU.
    ///
    /// - Parameter stream: byte array with  application protocol data unit (APDU) to be sent.
    /// - Returns: byte array with received response APDU steam.
    /// - throws An NfcError if any communication problem occurred.
    public func transmit(stream: Data) async throws -> Data {
        guard let commandAPDU = NFCISO7816APDU(data: stream) else {
            throw NfcError(description: NfcChannel.errorMessageInvalidApduBytes)
        }
        if let tagsISO7816 = tagISO7816 {
            let responseData = try await tagsISO7816.sendCommand(apdu: commandAPDU)
            var response = Data()
            response.append(responseData.0)
            response.append(responseData.1)
            response.append(responseData.2)
            return response
        }
        throw NfcError(description: NfcChannel.errorMessageChannelNotOpen)
    }

    /// Return NFC tag  status of channel.
    /// - Returns: true if communication port is opened.
    public func isOpen() -> Bool {
        open
    }

    /// Return connection status value that determines whether the NFC tag is available in the
    /// current reader session.
    /// - Returns: true if connection to tag is established.
    public func isConnected() -> Bool {
        if let status = tagISO7816?.isAvailable {
            return status
        }
        return false
    }

    /// Return friendly  textual representation of the receiver.
    /// - Returns: Friendly name of channel.
    public func getName() -> String {
        tagISO7816?.description ?? ""
    }
}
