// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import Security

/// Utility class for working with X509 certificate(.pem) files.
enum CertUtils {
    /// Reads the contents of a file with the given name and type from the app bundle.
    ///
    /// - Parameters:
    ///  - forResource: The name of the file to read.
    ///  - ofType: The file extension of the file to read.
    ///
    /// - Returns: The contents of the file as a string.
    ///
    /// - Throws: If the file could not be found or read, an error is thrown.
    public static func readFile(forResource: String, ofType: String) throws -> String {
        guard let filepath = Bundle.main.path(forResource: forResource, ofType: ofType) else {
            throw CertificateError(
                description: "Failed to find the file '\(forResource).\(ofType)' in the app bundle."
            )
        }
        let contents = try String(contentsOfFile: filepath)
        return contents
    }

    /// Parses a X509 certificate from a string.
    ///
    /// - Parameter certString: A string representation of the X509 certificate.
    ///
    /// - Returns: The parsed certificate as a ``SecCertificate`` object.
    ///
    /// - Throws: ``CertificateError``  If certificate string is invalid or could not be parsed, an
    /// error is thrown.
    public static func parseCert(from certString: String) throws -> SecCertificate {
        // Remove delimiters and whitespace from the input string.
        let cert = certString
            .replacingOccurrences(of: "-----BEGIN CERTIFICATE-----", with: "")
            .replacingOccurrences(of: "-----BEGIN EC PRIVATE KEY-----", with: "")
            .replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")
            .replacingOccurrences(of: "-----END CERTIFICATE-----", with: "")
            .replacingOccurrences(of: "-----END EC PRIVATE KEY-----", with: "")

        // Decode the Base64-encoded certificate string.
        guard let decodedData = Data(base64Encoded: cert) else {
            throw CertificateError(description: "Failed to decode certificate")
        }
        // Create a SecCertificateRef object from the decoded data.
        guard let certificate = SecCertificateCreateWithData(nil, decodedData as CFData) else {
            throw CertificateError(description: "Failed to create certificate from decoded data")
        }
        // Convert the certificate to a Data object and return it.
        return certificate
    }

    /// Retrieves a certificate from a file with the specified name and type, and parses it into a
    /// `Data` object.
    ///
    /// - Parameters:
    ///  - resourceName: The name of the resource file containing the certificate.
    ///  - resourceType: The file type of the resource file containing the certificate.
    ///
    /// - Returns: The parsed certificate as a ``SecCertificate`` object.
    ///
    /// - Throws: ``CertificateError``  If the resource file cannot be read or the certificate
    /// cannot be parsed.
    public static func getCertificate(
        fromResource resourceName: String,
        ofType resourceType: String
    ) throws -> SecCertificate {
        // Read the contents of the resource file into a string.
        let fileContent = try CertUtils.readFile(forResource: resourceName, ofType: resourceType)

        // Parse the certificate from the file contents & Return the parsed certificate data.
        return try CertUtils.parseCert(from: fileContent)
    }

    /// Verifies a the root certificate with its public key and checks if it is expired.
    ///
    /// - Parameters:
    ///  - certificate CA certificate to be verified.
    ///  - withRootCertificate CA certificate with verification done.
    ///
    /// -  Throws A ``CertificateError`` if failed to verify X509 certificate.
    public static func verifyCertificate(
        certificate: SecCertificate,
        withRootCertificate rootCertificate: SecCertificate
    ) throws -> Bool {
        let policy = SecPolicyCreateBasicX509()
        var trust: SecTrust?
        let status = SecTrustCreateWithCertificates([certificate] as CFArray, policy, &trust)
        if status == errSecSuccess {
            // Set the anchor certificates
            let anchorCertificates =
                [rootCertificate] // rootCertificate is a SecCertificate object representing the
            // trusted root
            SecTrustSetAnchorCertificates(trust!, anchorCertificates as CFArray)

            // Specify the date you want to use for verification
            let evaluationDate = Date() as CFDate // Use the current date or another specific date

            SecTrustSetVerifyDate(trust!, evaluationDate)
            // Evaluate the trust object
            var cfError: CFError?
            return SecTrustEvaluateWithError(trust!, &cfError)
        }
        return false
    }

    /// Verifies the authenticity of a digital signature.
    ///
    /// - Parameters:
    ///  - publicKey: The public key used to verify the signature.
    ///  - challenge: The challenge that was signed.
    ///  - signature: The signature to verify.
    ///
    /// - Throws: A ``CertificateError`` if the signature is not valid or there is an error
    /// verifying the signature.
    public static func verifySignature(publicKey: SecKey, challenge: Data, signature: Data) throws {
        var error: Unmanaged<CFError>?

        // Create a SHA-256 hash of the challenge data
        let challengeHash = challenge

        // Verify the signature
        let result = SecKeyVerifySignature(
            publicKey,
            .ecdsaSignatureMessageX962SHA256,
            challengeHash as CFData,
            signature as CFData,
            &error
        )

        if result != true {
            throw CertificateError(description: "Signature verification failed")
        }
    }

    /// Retrieves the public key from a certificate.
    ///
    /// - Parameter fromCertificate: The X509 certificate from which to retrieve the public key.
    ///
    /// - Returns: The public key contained in the certificate.
    ///
    /// - Throws: A ``CertificateError`` if the public key cannot be retrieved from the X509
    /// certificate.
    public static func retrievePublicKey(fromCertificate certificate: SecCertificate) throws
        -> SecKey {
        // Retrieve the public key from the certificate
        if let publicKey = SecCertificateCopyKey(certificate) {
            return publicKey
        } else {
            throw CertificateError(
                description: "Failed to retrieve the public key from the certificate"
            )
        }
    }
}
