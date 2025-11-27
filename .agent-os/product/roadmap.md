# Product Roadmap

> Last Updated: 2025-11-26
> Version: 1.0.0
> Status: Planning

## Phase 1: Menu Bar Foundation (2-3 weeks)

**Goal:** Establish basic menu bar presence with update count display and app launcher functionality

**Success Criteria:**
- Menu bar icon shows total update count from existing UpdateManager
- Clicking menu bar opens dropdown menu with basic info
- "Open Pearcleaner" action launches main app window
- Respects user preference to show/hide menu bar item

### Must-Have Features

- [ ] Menu bar icon integration using MenuBarExtra (SwiftUI) - `M`
- [ ] Update count badge on menu bar icon (aggregates existing UpdateManager data) - `S`
- [ ] Basic dropdown menu with update summary and "Open App" action - `S`
- [ ] Settings toggle in main app to enable/disable menu bar icon - `XS`
- [ ] App Group setup for shared state between menu bar and main app - `S`

### Should-Have Features

- [ ] Icon states: idle, checking updates, updates available (visual feedback) - `S`
- [ ] "Check for Updates Now" action in menu dropdown - `XS`
- [ ] Keyboard shortcut to summon main app window - `S`

### Dependencies

- Existing UpdateManager infrastructure
- macOS 13.0+ for MenuBarExtra support
- App Group entitlement for state sharing

---

## Phase 2: Background Update Scheduling (1-2 weeks)

**Goal:** Implement configurable background update checks that run independently of main app

**Success Criteria:**
- Update checks run at user-configured intervals (6 hours default)
- Menu bar badge updates automatically when new updates found
- Minimal battery/resource impact (<2MB RAM idle)
- Respects system Focus modes and battery state

### Must-Have Features

- [ ] NSBackgroundActivityScheduler integration for periodic checks - `M`
- [ ] User-configurable check intervals (1h, 6h, 12h, 24h, weekly) in Settings - `S`
- [ ] Background update check using existing checker infrastructure - `M`
- [ ] Update state persistence via shared UserDefaults - `S`
- [ ] Battery-aware scheduling (defer when <20% on battery) - `S`

### Should-Have Features

- [ ] Last check timestamp display in menu dropdown - `XS`
- [ ] Manual check progress indicator - `S`
- [ ] Coalescing multiple checks to reduce system load - `M`

### Dependencies

- Phase 1 completion (menu bar foundation)
- Existing UpdateManager, SparkleUpdateChecker, HomebrewUpdateChecker, AppStoreUpdateChecker

---

## Phase 3: Quick Maintenance Actions (1-2 weeks)

**Goal:** Enable common maintenance tasks directly from menu bar without opening main app

**Success Criteria:**
- 3-5 quick actions available in menu dropdown
- Actions execute with user confirmation
- Success/failure feedback via notifications or menu
- 80% of common maintenance doable from menu bar

### Must-Have Features

- [ ] "Clear Caches" quick action (leverages existing cache clearing logic) - `S`
- [ ] "Find Orphaned Files" quick action (triggers ReversePathsFetch) - `S`
- [ ] "Run Homebrew Cleanup" quick action (uses existing HomebrewManager) - `S`
- [ ] Action confirmation dialogs for destructive operations - `S`
- [ ] Success/failure notifications using UserNotifications - `S`

### Should-Have Features

- [ ] Disk space indicator in menu dropdown (shows volume info) - `S`
- [ ] Recent activity log in menu (last 5 actions performed) - `M`
- [ ] Quick action for opening specific Pearcleaner views (Updater, Orphans, etc.) - `S`
- [ ] Estimated space to be freed for cleanup actions - `S`

### Dependencies

- Phase 1 completion
- Existing Pearcleaner logic for caches, orphans, and Homebrew
- UserNotifications framework integration

---

## Phase 4: Enhanced Update Management (2 weeks)

**Goal:** Provide detailed update information and selective update controls from menu bar

**Success Criteria:**
- Menu shows list of apps with pending updates
- Users can view update details (version, changelog preview)
- Selective update ignoring (temporary or permanent)
- Visual priority indicators (security vs. feature updates)

### Must-Have Features

- [ ] Expandable menu showing list of apps with updates - `M`
- [ ] Per-app update details (current → new version) - `S`
- [ ] "Ignore this update" context action per app - `S`
- [ ] Update priority badges (security, major, minor) - `M`
- [ ] Integration with main app Updater view for full details - `S`

### Should-Have Features

- [ ] Grouped updates by source (App Store, Homebrew, Sparkle) - `S`
- [ ] "Update All" quick action with progress indicator - `M`
- [ ] Changelog preview in menu (first 2-3 lines) - `M`
- [ ] Filter to show only critical/security updates - `S`

### Dependencies

- Phase 2 completion (background scheduling)
- Enhanced UpdateManager metadata (priority, changelog URLs)
- Existing AppsUpdaterView integration

---

## Phase 5: Advanced Features & Polish (2-3 weeks)

**Goal:** Add power-user features, customization options, and refinement based on usage

**Success Criteria:**
- Global keyboard shortcuts for all major actions
- Customizable menu bar appearance
- Smart notifications with configurable triggers
- Resource usage validated (<2MB idle, <15MB active)

### Must-Have Features

- [ ] Global keyboard shortcuts using KeyboardShortcuts SPM - `M`
- [ ] Launch at login support using LaunchAtLogin SPM - `S`
- [ ] Menu bar icon customization (icon-only, show count, color coding) - `M`
- [ ] Quiet hours / Focus mode respect - `S`
- [ ] Smart notifications (threshold-based: e.g., notify when 5+ updates) - `M`

### Should-Have Features

- [ ] Weekly/monthly update summary notifications - `M`
- [ ] Menu bar text display option (e.g., "5 updates" instead of icon badge) - `S`
- [ ] Customizable quick actions (user picks which actions show in menu) - `L`
- [ ] Advanced scheduling (specific times, skip certain days) - `M`
- [ ] Menu bar icon animations for update checks - `S`

### Nice-to-Have Features

- [ ] Menu bar widget showing disk space usage graph - `L`
- [ ] Scheduled maintenance mode (auto-run cleanup weekly) - `L`
- [ ] Multiple menu bar profiles (work vs. personal settings) - `XL`

### Dependencies

- All previous phases
- SPM dependencies: LaunchAtLogin, KeyboardShortcuts
- User feedback from earlier phases

---

## Future Considerations (Post-v1.0)

**Not Committed:**
- CLI integration for menu bar controls
- AppleScript/Shortcuts.app integration
- Menu bar app badge mirroring (show total update count on Dock icon)
- Integration with third-party update APIs (Homebrew Analytics, etc.)
- Advanced filtering rules (auto-ignore beta updates, specific apps, etc.)
- Menu bar presence on multiple displays
