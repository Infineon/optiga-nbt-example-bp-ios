// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonNdef
import InfineonUtils

/// The ``InfineonNDEFHandler`` class serves as a INDEFHandler providing the logic for operations
/// related to standardized NDEF file format. It Implemented using the Infineon swift NDEF library
/// to handle parse and validate the  X509 certificate operations. It conforms to the
/// ``INDEFHandler`` to
/// effectively manage reusability and change of code.
public class InfineonNDEFHandler: INDEFHandler {
    /// A constant representing error message when NDEF file is empty.
    let emptyNDEFPersonalizationErrorMessage =
        "NDEF file Empty - Not personalized for brand protection"

    /// A constant representing the record type for X509 certificate data.
    private let recordTypeCert = "infineon technologies:infineon.com:nfc-bridge-tag.x509"

    /// Parses a X509 certificate from a raw NDEF message
    ///
    /// - Parameter rawMessage: Raw NDEF message from a NFC device
    ///
    /// - Returns the X509 ``SecCertificate`` parsed from a raw NDEF message
    ///
    /// - Throws: An ``NdefError`` and ``CertificateError``  in case issue to parse certificate
    /// from NDEF message
    public func parseCertFromNdef(rawNdefMessage: Data) throws -> SecCertificate {
        // Decode the row NDEF message to read records avilable
        let decodedMessage = try NdefManager.decode(data: rawNdefMessage)
        // Reads the and check the X509 certificate record is present in message
        for record in decodedMessage.getNdefRecords() {
            // If X509 certificate record is present, create the SecCertificate object and return
            // and stop loop.
            if record.getRecordType()?.getTypeAsString() == recordTypeCert,
               let payload = record.getPayload(),
               let cert = SecCertificateCreateWithData(nil, payload as CFData) {
                return cert
            }
        }
        // X509 certificate record is not present throws the error message as NDEF file is empty no
        // X509 certificate in record.
        throw CertificateError(description: emptyNDEFPersonalizationErrorMessage)
    }
}
