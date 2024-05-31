// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

/// An enum that defines the possible states of an NFC reader session during NFC tag interaction.
enum NFCReaderSessionState {
    /// The reader session is in the initial state, indicating that a tag has not been polled or
    /// detected yet.
    case initial

    /// The reader session is in the disconnected state.
    case disconnected

    /// The reader session is currently polling for other NFC tags.
    case polling

    /// The reader session is connected to an NFC tag.
    case connected
}
