// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// ``Error`` class for NFC communication related errors.
public class NfcError: Error {
    /// The error description.
    public var localizedDescription: String
    public var underlyingError: Error?

    /// Creates a new ``NfcError`` with the specified description.
    ///
    /// - Parameter description: The description of the error.
    ///
    public init(description: String) {
        localizedDescription = description
        underlyingError = nil
    }
}
