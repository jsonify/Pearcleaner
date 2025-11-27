//
//  MenuBarUpdatePublisher.swift
//  Pearcleaner
//
//  Created by Claude Code on 11/26/25.
//

import Foundation

/// Publishes update count and check status to shared App Group storage
/// Used to synchronize state between UpdateManager and menu bar components
class MenuBarUpdatePublisher {
    static let shared = MenuBarUpdatePublisher()

    // MARK: - Shared UserDefaults Keys
    private let updateCountKey = "menubar.updateCount"
    private let lastCheckKey = "menubar.lastCheck"
    private let appGroupIdentifier = "group.com.alienator88.Pearcleaner"

    // MARK: - Shared Storage Access

    /// Shared UserDefaults container for App Group communication
    /// Returns nil if App Group is not configured
    private var sharedDefaults: UserDefaults? {
        return UserDefaults(suiteName: appGroupIdentifier)
    }

    // MARK: - Public Methods

    /// Publishes update count to shared storage
    /// - Parameter count: Total number of pending updates
    /// - Returns: Boolean indicating success or failure
    @discardableResult
    func publishUpdateCount(_ count: Int) -> Bool {
        guard let defaults = sharedDefaults else {
            printOS("MenuBarUpdatePublisher: App Group not available, cannot publish update count")
            return false
        }

        defaults.set(count, forKey: updateCountKey)
        defaults.synchronize()

        printOS("MenuBarUpdatePublisher: Published update count: \(count)")
        return true
    }

    /// Publishes last check timestamp to shared storage
    /// - Parameter date: Date when update check completed
    /// - Returns: Boolean indicating success or failure
    @discardableResult
    func publishLastCheckDate(_ date: Date) -> Bool {
        guard let defaults = sharedDefaults else {
            printOS("MenuBarUpdatePublisher: App Group not available, cannot publish last check date")
            return false
        }

        defaults.set(date, forKey: lastCheckKey)
        defaults.synchronize()

        printOS("MenuBarUpdatePublisher: Published last check date: \(date)")
        return true
    }

    /// Publishes both update count and timestamp atomically
    /// - Parameters:
    ///   - count: Total number of pending updates
    ///   - date: Date when update check completed
    /// - Returns: Boolean indicating success or failure
    @discardableResult
    func publishUpdate(count: Int, lastCheck date: Date) -> Bool {
        guard let defaults = sharedDefaults else {
            printOS("MenuBarUpdatePublisher: App Group not available, cannot publish update")
            return false
        }

        defaults.set(count, forKey: updateCountKey)
        defaults.set(date, forKey: lastCheckKey)
        defaults.synchronize()

        printOS("MenuBarUpdatePublisher: Published count: \(count), date: \(date)")
        return true
    }

    // MARK: - Read Methods (for testing/debugging)

    /// Reads current update count from shared storage
    /// Returns nil if App Group not available or key doesn't exist
    func readUpdateCount() -> Int? {
        guard let defaults = sharedDefaults else {
            return nil
        }

        guard defaults.object(forKey: updateCountKey) != nil else {
            return nil
        }

        return defaults.integer(forKey: updateCountKey)
    }

    /// Reads last check date from shared storage
    /// Returns nil if App Group not available or key doesn't exist
    func readLastCheckDate() -> Date? {
        guard let defaults = sharedDefaults else {
            return nil
        }

        return defaults.object(forKey: lastCheckKey) as? Date
    }
}
