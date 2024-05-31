// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import Security

/// Protocol handler for NDEF file format operations.
public protocol INDEFHandler {
    /// Parses a X509 certificate from a raw NDEF message
    ///
    /// - Parameter rawMessage: Raw NDEF message from a NFC device
    ///
    /// - Returns the X509 ``SecCertificate`` parsed from a raw NDEF message
    ///
    /// - Throws: An ``NdefError`` and ``CertificateError``  in case issue to parse certificate
    /// from NDEF message
    func parseCertFromNdef(rawNdefMessage: Data) throws -> SecCertificate
}
