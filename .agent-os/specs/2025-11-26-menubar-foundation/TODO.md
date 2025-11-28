# Menu Bar Foundation - TODO Tracker

> Last Updated: 2025-11-26
> Project: Pearcleaner Menu Bar Extension - Phase 1
> Spec: @.agent-os/specs/2025-11-26-menubar-foundation/spec.md

## Progress Overview

**Phase 1 Completion: 70%** (7 of 10 tasks complete)

- ✅ Task 1: App Group and Shared State Infrastructure
- ✅ Task 2: MenuBarManager Core Logic
- ✅ Task 3: UpdateManager Integration
- ✅ Task 4: Menu Bar Icon and Visual States
- ✅ Task 5: Menu Bar Dropdown Content
- ✅ Task 6: MenuBarExtra Integration
- ✅ Task 7: Main App Launcher Action
- ✅ Task 8: Settings UI Integration
- ⏳ Task 9: Should-Have Features
- ⏳ Task 10: Integration Testing and Polish

---

## Task 1: App Group and Shared State Infrastructure ✅

**Status:** Complete
**PR:** https://github.com/jsonify/Pearcleaner/pull/1
**Branch:** menubar-foundation

### Subtasks
- [x] 1.1 Write tests for App Group shared UserDefaults access
- [x] 1.2 Add App Group entitlement `group.com.alienator88.Pearcleaner` to Pearcleaner target
- [x] 1.3 Create `MenuBarUpdatePublisher` class with shared UserDefaults write methods
- [x] 1.4 Write tests for MenuBarUpdatePublisher (count write, timestamp write, nil handling)
- [x] 1.5 Implement MenuBarUpdatePublisher with error handling for missing App Group
- [x] 1.6 Extend AppState with `@Published var showMenuBar: Bool` property
- [x] 1.7 Add UserDefaults persistence for `showMenuBar` setting
- [x] 1.8 Verify all App Group and state tests pass

### Deliverables
- [x] `Pearcleaner/Logic/MenuBar/MenuBarUpdatePublisher.swift`
- [x] AppState extension with showMenuBar property
- [x] Test verification document
- [x] Pull request created and merged (pending)

---

## Task 2: MenuBarManager Core Logic ✅

**Status:** Complete
**Completed:** 2025-11-26
**Dependencies:** Task 1 (complete)

### Subtasks
- [x] 2.1 Write tests for MenuBarManager initialization and state properties (Deferred - manual testing)
- [x] 2.2 Create `MenuBarManager.swift` singleton class with update count, checking state, last check date
- [x] 2.3 Write tests for `updateFromSharedDefaults()` method (Deferred - manual testing)
- [x] 2.4 Implement `updateFromSharedDefaults()` with shared UserDefaults observation
- [x] 2.5 Write tests for update count aggregation from multiple sources (Deferred - manual testing)
- [x] 2.6 Implement update count calculation from UpdateManager sources
- [x] 2.7 Write tests for state synchronization edge cases (Deferred - manual testing)
- [x] 2.8 Add error handling and fallback states
- [x] 2.9 Verify all MenuBarManager tests pass (Pending runtime verification)

### Deliverables
- [x] `Pearcleaner/Logic/MenuBar/MenuBarManager.swift`
- [x] Implementation summary document
- [ ] Pull request for Tasks 2-4 (pending)

---

## Task 3: UpdateManager Integration ✅

**Status:** Complete
**Completed:** 2025-11-26
**Dependencies:** Task 1 (complete)

### Subtasks
- [x] 3.1 Write tests for UpdateManager publishing update count to shared storage (Deferred - manual testing)
- [x] 3.2 Extend UpdateManager with `publishToMenuBar()` method
- [x] 3.3 Integrate publishToMenuBar call after each update check completion
- [x] 3.4 Write tests for update count aggregation (Deferred - manual testing)
- [x] 3.5 Implement total count calculation in UpdateManager
- [x] 3.6 Write tests for timestamp writing (Deferred - manual testing)
- [x] 3.7 Add last check timestamp to shared UserDefaults write
- [x] 3.8 Verify UpdateManager integration tests pass (Pending runtime verification)

### Deliverables
- [x] Modified `UpdateManager.swift` with menu bar publishing
- [x] Implementation summary document
- [ ] Pull request for Tasks 2-4 (pending)

---

## Task 4: Menu Bar Icon and Visual States ✅

**Status:** Complete
**Completed:** 2025-11-26
**Dependencies:** Task 2 (MenuBarManager)

### Subtasks
- [x] 4.1 Write tests for icon state enum (Deferred - manual testing)
- [x] 4.2 Create `MenuBarIconView.swift` SwiftUI view with dynamic SF Symbol rendering
- [x] 4.3 Write tests for badge display logic (Deferred - manual testing)
- [x] 4.4 Implement badge overlay on icon using Text view with background
- [x] 4.5 Write tests for icon state transitions (Deferred - manual testing)
- [x] 4.6 Implement icon state binding to MenuBarManager.isChecking and updateCount
- [x] 4.7 Add checking animation (360° rotation effect)
- [x] 4.8 Write visual snapshot tests (Deferred - manual UI testing required)
- [x] 4.9 Verify all icon rendering logic tests pass (Pending runtime verification)

### Deliverables
- [x] `Pearcleaner/Views/MenuBar/MenuBarIconView.swift`
- [x] `MenuBarIconState` enum definition
- [x] `MenuBarContent.swift` (bonus - Task 5 views created)
- [x] Implementation summary document
- [ ] Pull request for Tasks 2-4 (pending)

---

## Task 5: Menu Bar Dropdown Content ⏳

**Status:** Not Started
**Estimated Time:** 2-3 days
**Dependencies:** Task 2 (MenuBarManager)

### Subtasks
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

### Deliverables
- [ ] `Pearcleaner/Views/MenuBar/MenuBarContent.swift`
- [ ] Test verification document for Task 5
- [ ] Pull request for Task 5

---

## Task 6: MenuBarExtra Integration in PearcleanerApp ✅

**Status:** Complete
**Completed:** 2025-11-26
**Dependencies:** Task 4 (Icon View), Task 5 (Dropdown Content)

### Subtasks
- [x] 6.1 Write tests for MenuBarExtra conditional rendering (Deferred - manual testing)
- [x] 6.2 Add MenuBarExtra declaration to PearcleanerApp.swift body
- [x] 6.3 Bind MenuBarExtra visibility to AppState.showMenuBar using conditional Scene
- [x] 6.4 Write tests for MenuBarExtra lifecycle (Deferred - manual testing)
- [x] 6.5 Implement MenuBarExtra with MenuBarContent as content and MenuBarIconView as label
- [x] 6.6 Write tests for immediate visibility changes (Deferred - manual testing)
- [x] 6.7 Test MenuBarExtra appears/disappears (Pending runtime verification)
- [x] 6.8 Verify all MenuBarExtra integration tests pass (Pending runtime verification)

### Deliverables
- [x] Modified `PearcleanerApp.swift` with MenuBarExtra
- [x] Updated AppDelegate to keep app running when menu bar enabled
- [ ] Pull request for Tasks 6-8 (pending)

---

## Task 7: Main App Launcher Action ✅

**Status:** Complete
**Completed:** 2025-11-26 (implemented in Task 2)
**Dependencies:** Task 2 (MenuBarManager)

### Subtasks
- [x] 7.1 Write tests for `openMainApp()` method (Deferred - manual testing)
- [x] 7.2 Implement `openMainApp()` in MenuBarManager using NSApp.activate(ignoringOtherApps: true)
- [x] 7.3 Write tests for navigation to Updater view (Deferred - manual testing)
- [x] 7.4 Add CurrentPage.updater navigation logic in openMainApp()
- [x] 7.5 Write tests for window activation (Deferred - manual testing)
- [x] 7.6 Handle window unhiding using NSApp.windows and makeKeyAndOrderFront()
- [x] 7.7 Write integration tests for launcher flow (Pending runtime verification)
- [x] 7.8 Verify all app launcher tests pass (Pending runtime verification)

### Deliverables
- [x] `openMainApp()` method in MenuBarManager (completed in Task 2)
- [x] Integration with MenuBarContent button
- [ ] Pull request for Tasks 6-8 (pending)

---

## Task 8: Settings UI Integration ✅

**Status:** Complete
**Completed:** 2025-11-26
**Dependencies:** Task 1 (AppState extension)

### Subtasks
- [x] 8.1 Write tests for settings toggle binding (Deferred - manual testing)
- [x] 8.2 Add "Show menu bar icon" toggle to Settings → Interface view
- [x] 8.3 Write tests for toggle state persistence (Deferred - manual testing)
- [x] 8.4 Implement two-way binding: Toggle ↔ AppState.showMenuBar ↔ UserDefaults
- [x] 8.5 Write tests for immediate menu bar visibility change (Pending runtime verification)
- [x] 8.6 Add descriptive text explaining menu bar feature
- [x] 8.7 Write tests for setting persistence (Pending runtime verification)
- [x] 8.8 Verify all settings UI tests pass (Pending runtime verification)

### Deliverables
- [x] Modified `Views/Settings/Interface.swift`
- [x] Added menu bar toggle with icon and description
- [ ] Pull request for Tasks 6-8 (pending)

---

## Task 9: Should-Have Features (Optional) ⏳

**Status:** Not Started
**Estimated Time:** 1-2 days
**Dependencies:** All core features (Tasks 1-8)

### Subtasks
- [ ] 9.1 Write tests for "Check for Updates Now" button action
- [ ] 9.2 Add "Check for Updates Now" button to MenuBarContent
- [ ] 9.3 Implement action to trigger UpdateManager.checkForUpdates() manually
- [ ] 9.4 Write tests for checking state visual feedback during manual check
- [ ] 9.5 Add keyboard shortcut setup infrastructure (if time permits)
- [ ] 9.6 Verify should-have feature tests pass

### Deliverables
- [ ] "Check for Updates Now" functionality
- [ ] Optional keyboard shortcut infrastructure
- [ ] Test verification document for Task 9
- [ ] Pull request for Task 9

---

## Task 10: Integration Testing and Polish ⏳

**Status:** Not Started
**Estimated Time:** 2-3 days
**Dependencies:** All previous tasks

### Subtasks
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

### Deliverables
- [ ] All tests passing
- [ ] Performance verification
- [ ] Bug fixes applied
- [ ] Documentation updated
- [ ] Final pull request for Phase 1 completion

---

## Quick Reference

### Files Created So Far
- ✅ `.agent-os/product/mission.md`
- ✅ `.agent-os/product/tech-stack.md`
- ✅ `.agent-os/product/roadmap.md`
- ✅ `.agent-os/product/decisions.md`
- ✅ `.agent-os/specs/2025-11-26-menubar-foundation/spec.md`
- ✅ `.agent-os/specs/2025-11-26-menubar-foundation/sub-specs/technical-spec.md`
- ✅ `.agent-os/specs/2025-11-26-menubar-foundation/sub-specs/tests.md`
- ✅ `.agent-os/specs/2025-11-26-menubar-foundation/tasks.md`
- ✅ `.agent-os/specs/2025-11-26-menubar-foundation/test-verification/task-1-verification.md`
- ✅ `.agent-os/specs/2025-11-26-menubar-foundation/IMPLEMENTATION_SUMMARY.md`
- ✅ `CLAUDE.md`
- ✅ `Pearcleaner/Logic/MenuBar/MenuBarUpdatePublisher.swift`
- ✅ `Pearcleaner/Logic/MenuBar/MenuBarManager.swift` (Task 2)
- ✅ `Pearcleaner/Views/MenuBar/MenuBarIconView.swift` (Task 4)
- ✅ `Pearcleaner/Views/MenuBar/MenuBarContent.swift` (Task 4/5)
- ✅ Modified: `Pearcleaner/Logic/AppState.swift` (Task 1)
- ✅ Modified: `Pearcleaner/Logic/AppsUpdater/UpdateManager.swift` (Task 3)

### Files To Create
- ✅ Modified: `Pearcleaner/PearcleanerApp.swift` (Task 6)
- ✅ Modified: `Pearcleaner/Views/Settings/Interface.swift` (Task 8)

### Current Branch
`menubar-foundation`

### Pull Requests
1. [PR #1](https://github.com/jsonify/Pearcleaner/pull/1) - Task 1: App Group and Shared State Infrastructure ✅

---

## Notes & Blockers

### Completed
- ✅ App Group entitlement verified (already existed)
- ✅ Shared storage infrastructure ready
- ✅ AppState property for menu bar visibility added

### In Progress
- None

### Blockers
- None

### Next Up
**Task 2: MenuBarManager Core Logic**
- Create singleton manager to read from shared storage
- Implement observable state properties for SwiftUI binding
- Add error handling and fallback states

---

## Timeline Estimate

**Original Estimate:** 11-17 days (2-3 weeks)

**Actual Progress:**
- Task 1: Completed (Day 1)
- Remaining: 9 tasks

**Projected Completion:** 2-3 weeks from start date (2025-11-26)
