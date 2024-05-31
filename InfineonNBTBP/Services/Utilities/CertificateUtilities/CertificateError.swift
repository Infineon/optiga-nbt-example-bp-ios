// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// An error class representing X509 certificate related error.
public class CertificateError: Error {
    /// The error description.
    public var localizedDescription: String

    /// Creates a new X509 certificate Error with the specified description.
    ///
    /// - Parameter description: The description of the error.
    public init(description: String) {
        localizedDescription = description
    }
}
