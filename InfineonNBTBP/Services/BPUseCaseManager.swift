// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import CommonCrypto
import Foundation
import InfineonApduNbt
import InfineonUtils
import Security

/// The `BPUseCaseManager` class serves as a manager for the brand protection (BP) use case
/// supported by
/// the NBT by providing the API specific to
/// brand protection (BP) operations.
public class BPUseCaseManager {
    /// A property holder for random challenge needed for NBT device authenticate cmd
    private var challenge = [UInt8](repeating: 0, count: NBTBPConstants.challengeLength)

    /// A property holder for the ``NbtCommandSet`` which provides the API supported by the
    /// `OPTIGA™ Authenticate NFC (NBT) - Brand Protection` device  application.
    ///
    /// - SeeAlso: ``NBTCommandSet``
    private var nbtCommandSet: NbtCommandSet

    /// A property holder for the `INDEFHandler` provides the operations performed on standardized
    /// NDEF file format, parse and validate the X509 certificate.
    private var ndefHandler: INDEFHandler

    /// Initializes a instance of the ``BpUseCaseManager`` class.
    ///
    /// - Parameters:
    ///  - nbtCommandSet: A ``NBTCommandSet`` object. it represents the command set to be used by
    /// the ``BpUseCaseManager`` instance to perform APDU communication.
    public init(nbtCommandSet: NbtCommandSet) {
        self.nbtCommandSet = nbtCommandSet
        ndefHandler = InfineonNDEFHandler()
        for index in 0 ..< NBTBPConstants.challengeLength {
            challenge[index] = UInt8.random(in: 0 ..< 255)
        }
    }

    /// Async method to connect to the NBT device.
    ///
    /// - Throws An ``APDUError``: if connecting to NBT fails.
    public func connect() async throws {
        _ = try await nbtCommandSet.connect(data: nil)
    }

    /// Method to disconnect from NBT device.
    ///
    /// - Throws An ``APDUError``: if disconnecting from NBT device fails.
    public func disconnect() throws {
        try nbtCommandSet.disconnect()
    }

    /// Async method to select application associated with ``NBTCommandSet``.
    ///
    /// - Returns: ``NbtApduResponse`` of select application command.
    /// - Throws An ``APDUError``: if communication with NBT device fails.
    public func selectApplication() async throws -> NbtApduResponse {
        try await nbtCommandSet.selectApplication()
    }

    /// Method responsible for perform brand verification by executing sequence of APDU commands.
    ///
    /// The function performs the following steps:
    /// 1.  Read NDEF Message from tag
    /// 2. Verifies the product Authentication
    ///    - ``APDUError``: If there is an error with the APDU library command set.
    public func performBrandVerification() async throws {
        let apduResponse = try await nbtCommandSet.readNdefMessage().checkOK()
        try await verifyProduct(rawNdefMessage: apduResponse.getData()!)
    }

    /// Method responsible for perform authentication of  NBT device (product).
    ///
    /// The function performs the following steps:
    /// 1. Parses the X509 certificate from the NDEF message
    /// 2. Verifies the X509 certificate
    /// 3. Sends an authenticate command with a random challenge
    /// 4. Reads and parses the public key of the root certificate from a file
    /// 5. Verifies the received signature using the root certificate's public key
    ///
    /// - Parameters rawNdefMessage: The raw NDEF message read by the host device.
    /// - Throws:An ``APDUError``: If there is an error with the APDU library command set.
    private func verifyProduct(rawNdefMessage: Data) async throws {
        // Parses the X509 certificate from the NDEF message
        let cert = try ndefHandler.parseCertFromNdef(rawNdefMessage: rawNdefMessage)

        // Read root certificate
        let rootCertificate = try CertUtils.getCertificate(
            fromResource: Files.sampleRootCertificate,
            ofType: Files.certificateFileType
        )
        // Read manufacturing CA certificate of NBT
        let manufacturingCertificate = try CertUtils.getCertificate(
            fromResource: Files.nfcBridgeCLTagDevicesManufacturingCA,
            ofType: Files.certificateFileType
        )
        //  Checks certificate with manufacturing CA certificate.
        if try !CertUtils.verifyCertificate(
            certificate: cert,
            withRootCertificate: manufacturingCertificate
        ) {
            //  Checks certificate with root CA certificate.
            if try !CertUtils.verifyCertificate(
                certificate: cert,
                withRootCertificate: rootCertificate
            ) {
                // if both not valid throw error
                throw NSError(
                    domain: Bundle.main.bundleIdentifier!,
                    code: 200,
                    userInfo: [NSLocalizedDescriptionKey: String.messageProductFailedToVerify]
                )
            }
        }

        // Verify the signature
        let signature = try await authenticate()
        try CertUtils.verifySignature(
            publicKey: CertUtils.retrievePublicKey(fromCertificate: cert),
            challenge: Data(challenge),
            signature: signature!
        )
    }

    /// Method responsible sends the ``AUTHENTICATE_TAG`` cmd with a random challenge to receive a
    /// signature to verify
    ///
    /// - Throws:An ``APDUError``: If there is an error with the APDU library command set.
    private func authenticate() async throws -> Data? {
        let apduResponse = try await nbtCommandSet.authenticateTag(challenge: Data(challenge))
            .checkOK()
        return apduResponse.getData()
    }
}
