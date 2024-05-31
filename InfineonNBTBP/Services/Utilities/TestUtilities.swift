// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation

/// The `TestUtilities` class is designed to provide utility functions to aid in writing code for
/// test automation friendly. It offers a set of automation-friendly functionalities to assist in
/// testing scenarios and related tasks.
enum TestUtilities {
    /// Application launch argument name for UI testing inform that is UI test enable
    public static let isUITestEnabledArgument = "-UITestEnable"

    /// Application launch argument value for UI testing enable
    public static let isUITestEnabledYes = "YES"

    /// Application launch argument value for UI testing not enabled
    public static let isUITestEnabledNo = "NO"

    ///  Application launch argument and value  separator
    public static let appArgumentSeparator: Character = "="

    /// Test bundle suffix to identify app launch from test suit
    public static let testBundleSuffix = ".xctest"

    /// Method responsible to checks if UI tests are enabled
    /// - Returns: A boolean value indicating whether UI tests are enabled or not
    static func hasUITests() -> Bool {
        if let myParameter = ProcessInfo.processInfo.arguments
            .first(where: { $0.hasPrefix(isUITestEnabledArgument) })?
            .split(separator: appArgumentSeparator)[1] {
            return myParameter == isUITestEnabledYes
        }
        return false
    }

    /// Method responsible to checks if unit tests are enabled
    /// - Returns: A boolean value indicating whether unit tests are enabled or not
    static func hasUnitTests() -> Bool {
        if Bundle.allBundles
            .first(where: { $0.bundlePath.hasSuffix(testBundleSuffix) }) != nil {
            return !hasUITests()
        }
        return false
    }
}
