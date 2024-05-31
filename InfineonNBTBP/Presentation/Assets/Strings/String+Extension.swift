// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// An extension of the String type that defines the string constant used in application.
extension String {
    // MARK: - Application level constants

    /// Defines name of the application name.
    static let appName = "NBT Brand Protection"

    /// Defines sub title for application.
    static let subTitleForApp = "OPTIGA\u{2122}\u{00A0}Authenticate\u{00A0}NBT"

    /// Message to make sure NBT device is personalized.
    static let messageCheckAppletIsPersonalized =
        "Please make sure the OPTIGA™ Authenticate NBT is correctly personalized"

    /// The Empty string.
    /// - Note : There isn't a specific code point to unicode character code for the empty string
    /// (i.e., a string with zero characters).
    static let empty = ""

    /// The title for `Retry`  button.
    static let buttonTitleRetry = "Retry"

    /// Message from iOS if NFC interface not ready.
    static let messageSystemResourceNotAvailable = "System resource unavailable"

    /// Message from iOS if NFC interface not ready.
    static let messageNfcNotReady = "NFC interface not ready"

    /// Error message `Tag response error / no response` return by iOS in case of card is not able
    /// to respond to APDU command.
    static let errorMessageNoResponse = "Tag response error / no response"

    // MARK: - IFXComponents level constants

    /// The hint for the button.
    static let buttonTitleDefault = "Button"

    /// Message to retry again.
    static let messageRetry = ", please try again"

    // MARK: - NBT device BP write use case level constants

    /// The message for user to tap the NBT device to the mobile phone to verify its authenticity.
    static let messageToVerifyAuthenticity =
        "Please tap your iPhone to the OPTIGA™ Authenticate NBT to verify its authenticity!"

    /// The message for user to informing that verifying the product for brand protection.
    static let messageProductVerifying =
        "The product is being verified ..."

    /// The message for user to inform configured LED Product verified successful
    static let messageProductVerified = "Product successfully verified"

    /// The message for user to inform product verification failed
    static let messageProductFailedToVerify = "Could not be verified!"
}
