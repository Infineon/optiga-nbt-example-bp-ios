// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import SwiftUI

/// A SwiftUI view that represent the button according to IFX theme.
struct IFXButton: View {
    /// Enum defines the type of button according to IFX theme.
    enum ButtonType {
        /// Define the primary button
        case PRIMARY

        /// Define the secondary button with border.
        case SECONDARY

        /// Define the secondary button with no border.
        case TERTIARY

        /// Define the danger button.
        case DANGER
    }

    /// Holder for the title of button.
    let title: String

    /// Holder for the left side icon image name.
    let leftICon: String

    /// Holder for the right side icon image name.
    let rightICon: String

    /// Holder for the button type.
    let variant: ButtonType

    /// Holder for call back action.
    let action: () -> Void

    /// Initializer for IFXButton.
    ///
    ///  - Parameter title: String defines the tile for button, default value is `Button`.
    ///  - Parameter leftICon: String defines the eft side icon image name, default value is empty.
    ///  - Parameter rightICon: String defines the eft side icon image name, default value is empty.
    ///  - Parameter variant: Enum defines the type of button according to IFX theme, default value
    /// is `PRIMARY`.
    ///  - Parameter action: Defines the call back action for button.
    ///
    public init(
        title: String = .buttonTitleDefault,
        leftICon: String = .empty,
        rightICon: String = .empty,
        variant: ButtonType = .PRIMARY,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.leftICon = leftICon
        self.rightICon = rightICon
        self.variant = variant
        self.action = action
    }

    /// The `body` property represents the main content and behaviors of the `IFXButton`.
    var body: some View {
        Button(action: action) {
            HStack(alignment: .center) {
                if leftICon != .empty {
                    Image(leftICon)
                        .resizable()
                        .renderingMode(.template)
                        .frame(
                            width: StandardPointDimension.extraSmallWidth,
                            height: StandardPointDimension.extraSmallHeight
                        )
                        .foregroundColor(
                            variant == .DANGER || variant == .PRIMARY ? Color
                                .white : Color.ocean500
                        )
                }

                Text(verbatim: title)
                    .foregroundColor(
                        variant == .DANGER || variant == .PRIMARY ? Color.white : Color
                            .ocean500
                    )
                    .font(.body3)

                if rightICon != .empty {
                    Image(rightICon)
                        .resizable()
                        .renderingMode(.template)
                        .frame(
                            width: StandardPointDimension.extraSmallWidth,
                            height: StandardPointDimension.extraSmallHeight
                        )
                        .foregroundColor(
                            variant == .DANGER || variant == .PRIMARY ? Color
                                .white : Color.ocean500
                        )
                }
            }
            .frame(
                width: StandardPointDimension.mediumButtonWidth,
                height: StandardPointDimension.largeHeight
            )
            .padding(.horizontal, StandardPointDimension.largePadding)
        }
        .background(
            variant == .DANGER ? Color.red : variant == .PRIMARY ? Color.ocean500 : Color
                .white
        )
        .cornerRadius(StandardPointDimension.onePixelWidth)
        .overlay(
            Rectangle()
                .stroke(
                    variant == .DANGER ? Color.red : Color.ocean500,
                    lineWidth: StandardPointDimension.onePixelWidth
                )
        )
    }
}

/// Provide previews and sample data for the ``IFXButton`` during the development process.
#Preview {
    VStack {
        ///  Default button
        IFXButton(action: {})

        ///  Primary button with `title` `leftIcon` and `action`
        IFXButton(
            title: .buttonTitleDefault,
            leftICon: Images.certifiedIcon,
            action: {}
        )

        ///  Primary button with `title` ,`leftIcon`, `rightICon` and `action`
        IFXButton(
            title: .buttonTitleDefault,
            leftICon: Images.certifiedIcon,
            rightICon: Images.certifiedIcon,
            action: {}
        )

        ///  Secondary button with `title`  and `action`
        IFXButton(variant: .SECONDARY, action: {})

        ///  Secondary button with `title`, `leftIcon`  and `action`
        IFXButton(
            title: .buttonTitleDefault,
            leftICon: Images.certifiedIcon,
            variant: .SECONDARY,
            action: {}
        )

        ///  Secondary button with `title`, `leftIcon`,  `rightICon` and `action`
        IFXButton(
            title: .buttonTitleDefault,
            leftICon: Images.certifiedIcon,
            rightICon: Images.certifiedIcon,
            variant: .SECONDARY,
            action: {}
        )

        ///  Danger  button with `title` and `action`
        IFXButton(variant: .DANGER, action: {})

        ///  Danger  button with `title`, `leftIcon`  and `action`
        IFXButton(
            title: .buttonTitleDefault,
            leftICon: Images.certifiedIcon,
            variant: .DANGER,
            action: {}
        )

        ///  Danger  button with `title`, `leftIcon`,  `rightICon` and `action`
        IFXButton(
            title: .buttonTitleDefault,
            leftICon: Images.certifiedIcon,
            rightICon: Images.certifiedIcon,
            variant: .DANGER,
            action: {}
        )

        ///  Button on OceanDark background
        VStack {
            IFXButton(variant: .TERTIARY, action: {})
            IFXButton(
                title: .buttonTitleDefault,
                leftICon: Images.certifiedIcon,
                variant: .TERTIARY,
                action: {}
            )
            IFXButton(
                title: .buttonTitleDefault,
                leftICon: Images.certifiedIcon,
                rightICon: Images.certifiedIcon,
                variant: .TERTIARY,
                action: {}
            )

            IFXButton(variant: .DANGER, action: {})
            IFXButton(
                title: .buttonTitleDefault,
                leftICon: Images.certifiedIcon,
                variant: .DANGER,
                action: {}
            )

            ///  Danger  button with `title`, `leftIcon`,  `rightICon` and `action`
            IFXButton(
                title: .buttonTitleDefault,
                leftICon: Images.certifiedIcon,
                rightICon: Images.certifiedIcon,
                variant: .DANGER,
                action: {}
            )
        }
        .padding(StandardPointDimension.largePadding)
        .background(Color.ocean500)
    }
}
