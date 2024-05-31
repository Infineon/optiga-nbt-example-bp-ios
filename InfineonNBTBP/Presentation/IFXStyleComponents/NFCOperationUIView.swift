// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import SwiftUI

/// A SwiftUI view to the used for different NFC operation use case
struct NFCOperationUIView: View {
    /// The presentationMode environment value stores a binding to the PresentationMode which in
    /// turn has a dismiss() method to dismiss the presentation.
    /// To be able to call that action, we need to read the presentation mode from the environment
    /// using the @Binding property wrapper.
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    /// Represents the text input entered by the user.
    @Binding public var inputText: String

    /// Represents the text input entered by the user.
    public var inputTextHint: String

    /// Represents the title displayed in the user interface.
    public var title: String

    /// * Represents a message associated with a specific operation to be perform.
    public var operationMessage: String

    /// Represents a message associated with a specific operation to be perform.
    public var operationStatusMessage: String

    /// Represents the name or identifier of an icon or image used in the user interface.
    public var operationIcon: String

    /// Indicates whether a User input specific UI element is visible or hidden.
    public var isInputVisible: Bool

    /// Indicates whether a icon or image used in the user interface is active/inactive.
    @Binding public var isOperationIconActive: Bool?

    /// Represents a message associated with a specific input operation to be perform.
    public var inputMessage: String = .empty

    /// Represents a title for button default is set to Retry
    public var buttonTitle: String = .buttonTitleRetry

    /// Optional holder for call back action
    public var buttonAction: (() -> Void)?

    /// The `body` property represents the main content and behaviors of the ``NFCOperationUIView``.
    var body: some View {
        VStack {
            // Header view
            HeaderView(title: title)

            // Operation message
            Text(operationMessage)
                .font(.body3)
                .foregroundColor(Color.baseBlack)
                .padding(.leading)
                .padding(.trailing)
                .multilineTextAlignment(.center)

            // User Input UI elements
            if isInputVisible {
                VStack(alignment: .leading, spacing: .zero) {
                    Text(inputMessage)
                        .font(.body2SemiBold)
                        .foregroundColor(Color.baseBlack)

                    TextField(inputTextHint, text: $inputText)
                        .autocapitalization(.allCharacters)
                        .frame(
                            minWidth: .zero,
                            maxHeight: StandardPointDimension.largeHeight
                        )

                    // Add a border at the bottom
                    Rectangle()
                        .frame(height: StandardPointDimension.onePixelHeight)
                        .background(Color.gray)
                }
                .padding(.top)
                .padding(.leading)
                .padding(.trailing)
            }
            Spacer()

            // Operation icon or image
            Image(operationIcon)
                .resizable()
                .renderingMode(.template)
                .frame(
                    width: StandardPointDimension.operationImageSize,
                    height: StandardPointDimension.operationImageSize
                )
                .foregroundColor(
                    isOperationIconActive != nil ?
                        (isOperationIconActive! ? Color.ocean500 : Color.orange500) : Color.gray
                )

            // Operation message
            Text(operationStatusMessage)
                .font(.body3)
                .foregroundColor(Color.baseBlack)
                .padding(.leading)
                .padding(.trailing)
                .multilineTextAlignment(.center)

            if let callback = buttonAction {
                Spacer()
                IFXButton(title: buttonTitle, action: callback)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
        .navigationBarHidden(true)
    }
}

/// Provide previews and sample data for the ``NFCOperationUIView`` during the development process.
#Preview {
    NFCOperationUIView(
        inputText: .constant(".MSG_DEFAULT_COTT_LINK"),
        inputTextHint: .messageToVerifyAuthenticity,
        title: .messageToVerifyAuthenticity,
        operationMessage: .messageToVerifyAuthenticity,
        operationStatusMessage: .messageToVerifyAuthenticity,
        operationIcon: Images.certifiedIcon,
        isInputVisible: false,
        isOperationIconActive: .constant(false),
        buttonAction: {}
    )
    .preferredColorScheme(.light)
}
