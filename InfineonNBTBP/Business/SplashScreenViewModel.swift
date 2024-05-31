// SPDX-FileCopyrightText: 2024 Infineon Technologies AG
//
// SPDX-License-Identifier: MIT

import Foundation
import InfineonApdu

/// The ``SplashScreenViewModel`` class serves as a ViewModel providing the logic for splash screen
/// operations related to *NBT Brand Protection* application.  It
/// conforms to the ``ObservableObject`` to effectively manage UI components  on
/// ``SplashScreenView``. It can be also observed for changes using the ``ObservableObject``
/// protocol.
///
/// - SeeAlso: ``ObservableObject``
class SplashScreenViewModel: ObservableObject {
    /// A published property that represents the visibility status of a ``SplashScreenView``. It
    /// holds a boolean value indicating whether the ``SplashScreenView`` is visible or not.
    ///
    /// - Remark: The ``isActive`` property is marked with the ``@Published`` property wrapper,
    /// allowing it to automatically publish changes to any subscribers. When the value of
    /// ``isActive`` changes, the associated views are updated accordingly.
    ///
    /// - Note: The initial value of ``isActive`` is set to ``true`` as ``SplashScreenView`` is
    /// visible.
    ///
    /// - SeeAlso: ``@Published``
    @Published var isActive = true

    /// Method responsible for deactivating the visibility of the splash screen after a specified
    /// delay.
    ///
    /// This function schedules the deactivation of the splash screen after a certain time delay.
    /// - Note: The `isActive` property will be set to `false` after the specified time delay.
    func deactivateAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + NBTBPConstants.timeDelay) {
            self.isActive = false
        }
    }
}
