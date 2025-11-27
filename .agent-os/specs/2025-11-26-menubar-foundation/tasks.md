# Spec Tasks

These are the tasks to be completed for the spec detailed in @.agent-os/specs/2025-11-26-menubar-foundation/spec.md

> Created: 2025-11-26
> Status: Ready for Implementation

## Tasks

- [x] 1. App Group and Shared State Infrastructure
  - [x] 1.1 Write tests for App Group shared UserDefaults access
  - [x] 1.2 Add App Group entitlement `group.com.alienator88.Pearcleaner` to Pearcleaner target
  - [x] 1.3 Create `MenuBarUpdatePublisher` class with shared UserDefaults write methods
  - [x] 1.4 Write tests for MenuBarUpdatePublisher (count write, timestamp write, nil handling)
  - [x] 1.5 Implement MenuBarUpdatePublisher with error handling for missing App Group
  - [x] 1.6 Extend AppState with `@Published var showMenuBar: Bool` property
  - [x] 1.7 Add UserDefaults persistence for `showMenuBar` setting
  - [x] 1.8 Verify all App Group and state tests pass

- [ ] 2. MenuBarManager Core Logic
  - [ ] 2.1 Write tests for MenuBarManager initialization and state properties
  - [ ] 2.2 Create `MenuBarManager.swift` singleton class with update count, checking state, last check date
  - [ ] 2.3 Write tests for `updateFromSharedDefaults()` method (read count, parse timestamp, handle nil)
  - [ ] 2.4 Implement `updateFromSharedDefaults()` with shared UserDefaults observation
  - [ ] 2.5 Write tests for update count aggregation from multiple sources
  - [ ] 2.6 Implement update count calculation from UpdateManager sources
  - [ ] 2.7 Write tests for state synchronization edge cases (corrupt data, missing keys)
  - [ ] 2.8 Add error handling and fallback states
  - [ ] 2.9 Verify all MenuBarManager tests pass

- [ ] 3. UpdateManager Integration
  - [ ] 3.1 Write tests for UpdateManager publishing update count to shared storage
  - [ ] 3.2 Extend UpdateManager with `publishToMenuBar(updateCount: Int)` method
  - [ ] 3.3 Integrate publishToMenuBar call after each update check completion
  - [ ] 3.4 Write tests for update count aggregation across App Store, Homebrew, and Sparkle sources
  - [ ] 3.5 Implement total count calculation in UpdateManager
  - [ ] 3.6 Write tests for timestamp writing on update completion
  - [ ] 3.7 Add last check timestamp to shared UserDefaults write
  - [ ] 3.8 Verify UpdateManager integration tests pass

- [ ] 4. Menu Bar Icon and Visual States
  - [ ] 4.1 Write tests for icon state enum (idle, checking, updates available)
  - [ ] 4.2 Create `MenuBarIconView.swift` SwiftUI view with dynamic SF Symbol rendering
  - [ ] 4.3 Write tests for badge display logic (show count, hide when zero, 99+ for high counts)
  - [ ] 4.4 Implement badge overlay on icon using Text view with background
  - [ ] 4.5 Write tests for icon state transitions (idle → checking → updates → idle)
  - [ ] 4.6 Implement icon state binding to MenuBarManager.isChecking and updateCount
  - [ ] 4.7 Add checking animation (subtle rotation or pulse effect)
  - [ ] 4.8 Write visual snapshot tests (if available) or manual test checklist for icon states
  - [ ] 4.9 Verify all icon rendering logic tests pass

- [ ] 5. Menu Bar Dropdown Content
  - [ ] 5.1 Write tests for MenuBarContent view model (update summary text, button actions)
  - [ ] 5.2 Create `MenuBarContent.swift` SwiftUI view with VStack layout
  - [ ] 5.3 Write tests for update summary text formatting ("X updates available", "No updates", "Checking...")
  - [ ] 5.4 Implement dynamic update summary based on MenuBarManager.updateCount
  - [ ] 5.5 Write tests for last check timestamp display (human-readable format: "2 hours ago", etc.)
  - [ ] 5.6 Implement last check time formatter using RelativeDateTimeFormatter
  - [ ] 5.7 Add "Open Pearcleaner" button with action binding to MenuBarManager.openMainApp()
  - [ ] 5.8 Add divider and "Quit" menu option (standard macOS pattern)
  - [ ] 5.9 Write tests for menu content accessibility labels
  - [ ] 5.10 Verify all menu content tests pass

- [ ] 6. MenuBarExtra Integration in PearcleanerApp
  - [ ] 6.1 Write tests for MenuBarExtra conditional rendering based on AppState.showMenuBar
  - [ ] 6.2 Add MenuBarExtra declaration to PearcleanerApp.swift body
  - [ ] 6.3 Bind MenuBarExtra visibility to AppState.showMenuBar using conditional Scene
  - [ ] 6.4 Write tests for MenuBarExtra lifecycle (appears on launch if enabled, hidden if disabled)
  - [ ] 6.5 Implement MenuBarExtra with MenuBarContent as content and MenuBarIconView as label
  - [ ] 6.6 Write tests for immediate visibility changes when showMenuBar toggled
  - [ ] 6.7 Test MenuBarExtra appears/disappears without app restart
  - [ ] 6.8 Verify all MenuBarExtra integration tests pass

- [ ] 7. Main App Launcher Action
  - [ ] 7.1 Write tests for `openMainApp()` method (app hidden, app visible, navigate to updater)
  - [ ] 7.2 Implement `openMainApp()` in MenuBarManager using NSApp.activate(ignoringOtherApps: true)
  - [ ] 7.3 Write tests for navigation to Updater view when app already visible
  - [ ] 7.4 Add CurrentPage.updater navigation logic in openMainApp()
  - [ ] 7.5 Write tests for window activation from hidden state
  - [ ] 7.6 Handle window unhiding using NSApp.windows and makeKeyAndOrderFront()
  - [ ] 7.7 Write integration tests for end-to-end launcher flow (click button → app appears)
  - [ ] 7.8 Verify all app launcher tests pass

- [ ] 8. Settings UI Integration
  - [ ] 8.1 Write tests for settings toggle binding to AppState.showMenuBar
  - [ ] 8.2 Add "Show menu bar icon" toggle to Settings → Interface view
  - [ ] 8.3 Write tests for toggle state persistence to UserDefaults
  - [ ] 8.4 Implement two-way binding: Toggle ↔ AppState.showMenuBar ↔ UserDefaults
  - [ ] 8.5 Write tests for immediate menu bar visibility change on toggle
  - [ ] 8.6 Add descriptive text/tooltip explaining menu bar feature
  - [ ] 8.7 Write tests for setting persistence across app launches
  - [ ] 8.8 Verify all settings UI tests pass

- [ ] 9. Should-Have Features (Optional)
  - [ ] 9.1 Write tests for "Check for Updates Now" button action
  - [ ] 9.2 Add "Check for Updates Now" button to MenuBarContent
  - [ ] 9.3 Implement action to trigger UpdateManager.checkForUpdates() manually
  - [ ] 9.4 Write tests for checking state visual feedback during manual check
  - [ ] 9.5 Add keyboard shortcut setup infrastructure (if time permits)
  - [ ] 9.6 Verify should-have feature tests pass

- [ ] 10. Integration Testing and Polish
  - [ ] 10.1 Run full test suite and verify all unit tests pass
  - [ ] 10.2 Run integration tests for end-to-end flows (enable menu bar → see updates → open app)
  - [ ] 10.3 Test menu bar with 0 updates, 1 update, 5 updates, 99+ updates scenarios
  - [ ] 10.4 Test state synchronization between UpdateManager and menu bar in real time
  - [ ] 10.5 Manual QA: Visual appearance in light mode and dark mode
  - [ ] 10.6 Manual QA: Menu bar icon positioning and badge overlay rendering
  - [ ] 10.7 Manual QA: Settings toggle immediate effect and persistence across launches
  - [ ] 10.8 Manual QA: "Open Pearcleaner" action from various app states (hidden, visible, other app active)
  - [ ] 10.9 Performance check: Verify <2MB RAM overhead, <500ms badge update latency
  - [ ] 10.10 Fix any bugs or visual issues discovered during testing
  - [ ] 10.11 Code review and cleanup: Remove debug logging, organize file structure
  - [ ] 10.12 Update CHANGELOG or release notes with Phase 1 menu bar features
  - [ ] 10.13 Verify all integration tests and manual QA checklist items complete

## Task Dependencies

- Task 1 (App Group) must complete before Task 2 (MenuBarManager) - shared storage required
- Task 2 (MenuBarManager) must complete before Task 4 (Icon) and Task 5 (Menu Content) - state management needed
- Task 3 (UpdateManager integration) should run parallel to Task 2 - independent implementation
- Task 6 (MenuBarExtra) requires Task 4 and Task 5 complete - needs icon and content views
- Task 7 (App Launcher) can run parallel to Tasks 4-6 - independent feature
- Task 8 (Settings UI) can run parallel to Tasks 4-7 - independent feature
- Task 9 (Should-Have) can only start after core features (Tasks 1-8) working
- Task 10 (Integration Testing) must be last - requires all features implemented

## Estimated Timeline

- Tasks 1-2: 2-3 days (infrastructure and core manager)
- Task 3: 1-2 days (UpdateManager integration)
- Tasks 4-5: 2-3 days (UI components)
- Task 6: 1 day (MenuBarExtra integration)
- Task 7: 1-2 days (app launcher)
- Task 8: 1 day (settings UI)
- Task 9: 1-2 days (optional features)
- Task 10: 2-3 days (testing and polish)

**Total: 11-17 days (2-3 weeks aligned with Phase 1 roadmap estimate)**
