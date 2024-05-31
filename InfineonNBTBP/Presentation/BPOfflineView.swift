// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import SwiftUI

/// A SwiftUI view for the brand protection (BP) with offline authentication use case of the  NBT.
struct BPOfflineView: View {
    /// An observed object representing the view model for ``BPOfflineView``.  This observed
    /// object property hold ViewModel and responsible for offline brand protection operations.
    ///
    /// - SeeAlso: ``ObservableObject``
    @ObservedObject var bpOfflineViewModel = BPOfflineViewModel()

    /// The `body` property represents the main content and behaviors of the  ``BPOfflineView``.
    var body: some View {
        NFCOperationUIView(
            inputText: .constant(.empty),
            inputTextHint: .empty,
            title: .appName,
            operationMessage: .messageToVerifyAuthenticity,
            operationStatusMessage: bpOfflineViewModel.message,
            operationIcon: Images.certifiedIcon,
            isInputVisible: false,
            isOperationIconActive: $bpOfflineViewModel.isVerified,
            buttonAction: {
                bpOfflineViewModel.message = .messageToVerifyAuthenticity
                bpOfflineViewModel.isVerified = nil
                bpOfflineViewModel
                    .startNFCTagReaderSession(
                        withAlertMessage: .messageToVerifyAuthenticity
                    )
            }
        )
        .onAppear(perform: {
            // This code avoid bellow lines from execute to handle the mocking scenario of snapshot
            // tests for the output.
            if !TestUtilities.hasUnitTests() {
                bpOfflineViewModel.message = .messageToVerifyAuthenticity
                bpOfflineViewModel.isVerified = nil
            }
            bpOfflineViewModel
                .startNFCTagReaderSession(
                    withAlertMessage: .messageToVerifyAuthenticity
                )
        })
        .ignoresSafeArea()
    }
}

// Provide previews and sample data for the `BPOfflineView` during the development process.
#Preview {
    BPOfflineView()
}
