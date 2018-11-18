//
//  Helpers.swift
//  Siren
//
//  Created by Arthur Sabintsev on 9/25/18.
//  Copyright © 2018 Sabintsev iOS Projects. All rights reserved.
//

import Foundation

// MARK: - Version Helpers

extension Siren {
    func isAppStoreVersionNewer() -> Bool {
        guard let currentInstalledVersion = currentInstalledVersion,
            let currentAppStoreVersion = currentAppStoreVersion,
            (currentInstalledVersion.compare(currentAppStoreVersion, options: .numeric) == .orderedAscending) else {
                return false
        }

        return true
    }

    func storeVersionCheckDate() {
        lastVersionCheckPerformedOnDate = Date()
        if let lastVersionCheckPerformedOnDate = lastVersionCheckPerformedOnDate {
            UserDefaults.storedVersionCheckDate = lastVersionCheckPerformedOnDate
            UserDefaults.standard.synchronize()
        }
    }
}

// MARK: - Miscellaneous Helpers

extension Siren {
    func isUpdateCompatibleWithDeviceOS(for model: LookupModel) -> Bool {
        guard let requiredOSVersion = model.results.first?.minimumOSVersion else {
            postError(.appStoreOSVersionNumberFailure)
            return false
        }

        let systemVersion = UIDevice.current.systemVersion

        guard systemVersion.compare(requiredOSVersion, options: .numeric) == .orderedDescending ||
            systemVersion.compare(requiredOSVersion, options: .numeric) == .orderedSame else {
                postError(.appStoreOSVersionUnsupported)
                return false
        }

        return true
    }

    func hideWindow() {
        if let updaterWindow = updaterWindow {
            updaterWindow.isHidden = true
            self.updaterWindow = nil
        }
    }

    /// Routes a console-bound message to the `SirenLog` struct, which decorates the log message.
    ///
    /// - Parameter message: The message to decorate and log to the console.
    func printMessage(_ message: String) {
        if debugEnabled {
            Log(message)
        }
    }
}

// MARK: - Test Target Helpers

extension Siren {
    func testSetCurrentInstalledVersion(version: String) {
        currentInstalledVersion = version
    }

    func testSetAppStoreVersion(version: String) {
        currentAppStoreVersion = version
    }
}
