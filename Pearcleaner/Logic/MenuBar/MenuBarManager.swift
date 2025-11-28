//
//  MenuBarManager.swift
//  Pearcleaner
//
//  Created by Claude Code on 11/26/25.
//

import Foundation
import SwiftUI
import Combine

/// Manages menu bar state and coordinates between UpdateManager and menu bar UI
@MainActor
class MenuBarManager: ObservableObject {
    static let shared = MenuBarManager()

    // MARK: - Published Properties

    /// Total count of available updates across all sources
    @Published var updateCount: Int = 0

    /// Indicates if update check is currently in progress
    @Published var isChecking: Bool = false

    /// Date of last update check
    @Published var lastCheckDate: Date?

    // MARK: - Private Properties

    private let appGroupIdentifier = "group.com.alienator88.Pearcleaner"
    private let updateCountKey = "menubar.updateCount"
    private let lastCheckKey = "menubar.lastCheck"

    private var sharedDefaults: UserDefaults? {
        UserDefaults(suiteName: appGroupIdentifier)
    }

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    private init() {
        // Subscribe to UpdateManager state changes
        setupUpdateManagerObservers()

        // Load initial state from shared storage
        updateFromSharedDefaults()
    }

    // MARK: - Public Methods

    /// Manually triggers update from shared UserDefaults
    /// Call this when resuming from background or on app activation
    func updateFromSharedDefaults() {
        guard let defaults = sharedDefaults else {
            printOS("MenuBarManager: App Group not available, using fallback state")
            updateCount = 0
            lastCheckDate = nil
            return
        }

        // Read update count (defaults to 0 if not set)
        if defaults.object(forKey: updateCountKey) != nil {
            updateCount = defaults.integer(forKey: updateCountKey)
        } else {
            updateCount = 0
        }

        // Read last check date
        lastCheckDate = defaults.object(forKey: lastCheckKey) as? Date

        printOS("MenuBarManager: Updated from shared defaults - count: \(updateCount), lastCheck: \(lastCheckDate?.description ?? "nil")")
    }

    /// Opens main Pearcleaner window and optionally navigates to Updater view
    func openMainApp(navigateToUpdater: Bool = true) {
        // Activate app and bring to front
        NSApp.activate(ignoringOtherApps: true)

        // Show main window if hidden
        if let window = NSApp.windows.first(where: { $0.isVisible || $0.canBecomeKey }) {
            window.makeKeyAndOrderFront(nil)
        } else {
            // If no visible window, show the first window
            NSApp.windows.first?.makeKeyAndOrderFront(nil)
        }

        // Navigate to Updater view if requested and updates available
        if navigateToUpdater {
            AppState.shared.currentPage = .updater
        }

        printOS("MenuBarManager: Opened main app (navigateToUpdater: \(navigateToUpdater))")
    }

    /// Calculates total update count from UpdateManager sources
    /// - Returns: Total number of available updates
    func calculateTotalUpdateCount() -> Int {
        let manager = UpdateManager.shared

        // Sum up all updates from all sources
        let total = manager.updatesBySource.values.reduce(0) { sum, apps in
            sum + apps.count
        }

        printOS("MenuBarManager: Calculated total update count: \(total)")
        return total
    }

    // MARK: - Private Methods

    /// Sets up observers for UpdateManager state changes
    private func setupUpdateManagerObservers() {
        let manager = UpdateManager.shared

        // Observe scanning state
        manager.$isScanning
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isScanning in
                self?.isChecking = isScanning
                printOS("MenuBarManager: isChecking updated to \(isScanning)")
            }
            .store(in: &cancellables)

        // Observe updates dictionary changes to update count
        manager.$updatesBySource
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updatesBySource in
                guard let self = self else { return }

                // Calculate new count
                let newCount = updatesBySource.values.reduce(0) { sum, apps in
                    sum + apps.count
                }

                self.updateCount = newCount
                printOS("MenuBarManager: Update count changed to \(newCount)")
            }
            .store(in: &cancellables)

        // Observe last scan date
        manager.$lastScanDate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] scanDate in
                self?.lastCheckDate = scanDate
                printOS("MenuBarManager: Last check date updated to \(scanDate?.description ?? "nil")")
            }
            .store(in: &cancellables)
    }
}
