// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import UIKit

/// A collection of standard point sizes used for padding, margin, height, width, and more.
public enum StandardPointDimension {
    // MARK: - Paddings

    /// The point size for small padding as 4 pixel.
    static let smallPadding: CGFloat = 4

    /// The point size for medium padding as 8 pixel.
    static let mediumPadding: CGFloat = 8

    /// The point size for large padding as 16 pixel.
    static let largePadding: CGFloat = 16

    /// The point size for extra large padding as 24 pixel.
    static let extraLargePadding: CGFloat = 24

    // MARK: - Margins

    /// The point size for small margin as 4 pixel.
    static let smallMargin: CGFloat = 4

    /// The point size for medium margin as 8 pixel.
    static let mediumMargin: CGFloat = 8

    /// The point size for large margin as 16 pixel.
    static let largeMargin: CGFloat = 16

    /// The point size for extra large margin as 24 pixel.
    static let extraLargeMargin: CGFloat = 24

    // MARK: - Heights

    /// The point size for small height as 16 pixel.
    static let extraSmallHeight: CGFloat = 16

    /// The point size for small height as 24 pixel.
    static let smallHeight: CGFloat = 24

    /// The point size for medium height as 32 pixel.
    static let mediumHeight: CGFloat = 32

    /// The point size for large height as 48 pixel.
    static let largeHeight: CGFloat = 48

    /// The point size for extra large height as 64 pixel.
    static let extraLargeHeight: CGFloat = 64

    /// The height value for 1 pixels.
    static let onePixelHeight: CGFloat = 1.0

    /// The height value for 4 pixels.
    static let fourPixelHeight: CGFloat = 4.0

    /// The height value for 42 pixels.
    static let editTextHeight: CGFloat = 42

    /// Represents the height of  of PSoc Image view as 150 pixel..
    static let pSocImageViewHeight: CGFloat = 150

    // MARK: - Widths

    /// The point size for small width as 16 pixel..
    static let extraSmallWidth: CGFloat = 16

    /// The point size for small width as 24 pixel..
    static let smallWidth: CGFloat = 24

    /// The point size for medium width as 32 pixel..
    static let mediumWidth: CGFloat = 32

    /// The point size for large width as 48 pixel..
    static let largeWidth: CGFloat = 48

    /// The point size for extra large width as 64 pixel..
    static let extraLargeWidth: CGFloat = 64

    /// The width value for 12 pixels as 12 pixel..
    static let twelvePixelWidth: CGFloat = 12.0

    /// The width value for 1 pixels.
    static let onePixelWidth: CGFloat = 1.0

    /// The size of a infineon icon width in 80 pixels.
    static let ifxLogoWidth: CGFloat = 80.0

    /// Represents the width of  of PSoc Image view as 200 pixel..
    static let pSocImageViewWidth: CGFloat = 200

    // MARK: - Button Widths

    /// The size of a small button width in 100 pixels.
    static let smallButtonWidth: CGFloat = 100.0

    /// The size of a medium button width in 120 pixels.
    static let mediumButtonWidth: CGFloat = 120.0

    // MARK: - Sizes

    /// The size of a medium button width in 145.6 pixels.
    static let infineonIconWidth: CGFloat = 145.6

    /// Represents the size of header view as 150 pixel..
    static let headerViewSize: CGFloat = 150

    /// The size of a small image in 60 pixels.
    static let smallImageSize: CGFloat = 60.0

    /// The size of a operation image in 80 pixels.
    static let operationImageSize: CGFloat = 80.0

    /// The point size for small border 1 pixel width.
    static let smallBorderSize: CGFloat = 1

    /// The point size for standard border 1 pixel radius.
    static let standardBorderRadiusSize: CGFloat = 1

    /// The point size for standard Insert as 1 pixel..
    static let standardInsetSize: CGFloat = 1

    static var isSmallDevice: Bool {
        if UIScreen.main.bounds.width <= 380 { // Check for iPhone SE width
            return true // for iPhone SE
        } else {
            return false // for other iPhone models
        }
    }
}
