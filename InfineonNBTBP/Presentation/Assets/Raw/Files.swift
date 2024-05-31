// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// Files class provides the static constant representing raw sample root certificate files
public enum Files {
    /// The name of the sample root certificate pen file name.
    ///
    /// The `sampleRootCertificate` constant represents the sample root certificate pen file.
    public static let sampleRootCertificate = "SampleRootCertificate"

    /// The name of the manufacturing CA certificate of NBT pen file name.
    ///
    /// The `nfcBridgeCLTagDevicesManufacturingCA` constant represents the manufacturing CA
    /// certificate of NBT pen file name.
    public static let nfcBridgeCLTagDevicesManufacturingCA = "NFCBridgeCLTagDevicesManufacturingCA"

    /// The extension/file type of the sample device certificate pen file.
    ///
    /// The `certificateFileType` constant represents the sample device certificate pen
    /// file extension/file type.
    public static let certificateFileType = "pem"
}
