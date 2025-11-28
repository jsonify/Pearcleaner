# Tests Specification

This is the tests coverage details for the spec detailed in @.agent-os/specs/2025-11-26-menubar-foundation/spec.md

> Created: 2025-11-26
> Version: 1.0.0

## Test Coverage

### Unit Tests

**MenuBarManager**
- `test_updateCount_initializes_to_zero()` - Verify initial state is 0 updates
- `test_updateFromSharedDefaults_reads_count_correctly()` - Mock shared UserDefaults and verify count read
- `test_updateFromSharedDefaults_updates_lastCheckDate()` - Verify last check date is parsed from shared storage
- `test_isChecking_state_transitions()` - Verify checking state can be set true/false
- `test_sharedDefaults_nil_handling()` - Verify graceful handling when App Group not available

**MenuBarUpdatePublisher**
- `test_publishToMenuBar_writes_to_sharedDefaults()` - Verify count written to correct key
- `test_publishToMenuBar_writes_timestamp()` - Verify timestamp written to shared storage
- `test_publishToMenuBar_handles_nil_sharedDefaults()` - Verify no crash when App Group unavailable
- `test_count_aggregation_across_sources()` - Verify total count calculation from UpdateManager sources

**AppState Extensions**
- `test_showMenuBar_persists_to_UserDefaults()` - Verify settings toggle writes to correct key
- `test_showMenuBar_reads_from_UserDefaults_on_init()` - Verify initial state loaded from storage
- `test_showMenuBar_default_value_is_false()` - Verify menu bar disabled by default on fresh install

### Integration Tests

**Menu Bar Visibility**
- `test_menuBar_appears_when_showMenuBar_enabled()` - Launch app with setting enabled, verify menu bar icon exists
- `test_menuBar_hidden_when_showMenuBar_disabled()` - Launch app with setting disabled, verify no menu bar icon
- `test_menuBar_toggles_immediately_on_setting_change()` - Change setting while running, verify immediate effect
- `test_menuBar_persists_across_app_launches()` - Enable menu bar, quit, relaunch, verify still enabled

**Update Count Display**
- `test_menuBar_badge_shows_correct_count()` - Mock UpdateManager with 5 updates, verify badge shows "5"
- `test_menuBar_badge_updates_when_count_changes()` - Change update count, verify badge updates within 500ms
- `test_menuBar_badge_hidden_when_zero_updates()` - Set count to 0, verify no badge displayed
- `test_menuBar_badge_shows_99_plus_for_large_counts()` - Set count to 150, verify badge shows "99+"

**Menu Dropdown Content**
- `test_menuBar_dropdown_opens_on_click()` - Click menu bar icon, verify dropdown appears
- `test_menuBar_dropdown_shows_update_summary()` - Verify dropdown displays "X updates available" text
- `test_menuBar_dropdown_shows_last_check_time()` - Verify last check timestamp displayed in human-readable format
- `test_menuBar_dropdown_has_open_app_button()` - Verify "Open Pearcleaner" button present in menu

**Main App Launcher**
- `test_open_app_brings_window_to_front()` - Main app running, click "Open Pearcleaner", verify window activated
- `test_open_app_navigates_to_updater_view()` - Verify CurrentPage set to .updater after launch
- `test_open_app_when_app_hidden()` - Hide main window, click open, verify window shows
- `test_open_app_activates_ignoring_other_apps()` - Other apps active, verify Pearcleaner becomes frontmost

**State Synchronization**
- `test_sharedDefaults_sync_between_updateManager_and_menuBar()` - UpdateManager writes count, verify MenuBarManager reads it
- `test_menuBar_reflects_realtime_update_manager_changes()` - Trigger update check, verify menu bar updates when complete
- `test_multiple_sources_aggregate_correctly()` - Mock 2 App Store + 3 Homebrew + 1 Sparkle, verify badge shows "6"

### Visual State Tests

**Icon States**
- `test_icon_idle_state_when_no_updates()` - Zero updates, verify gray icon with no badge
- `test_icon_checking_state_during_update_check()` - Trigger check, verify animated state
- `test_icon_updates_available_state()` - Updates exist, verify badge with count visible
- `test_icon_returns_to_idle_after_check_completes()` - Check completes with 0 updates, verify idle state

**Should-Have Feature Tests**
- `test_check_for_updates_now_action()` - Click "Check for Updates Now" in menu, verify UpdateManager triggered
- `test_keyboard_shortcut_summons_app()` - Press configured hotkey, verify app window appears (Phase 1 should-have)

### Edge Cases

**Error Handling**
- `test_menu_bar_graceful_when_updateManager_unavailable()` - UpdateManager not initialized, verify no crash
- `test_menu_bar_handles_corrupt_sharedDefaults()` - Invalid data in shared storage, verify fallback to zero
- `test_menu_bar_handles_missing_app_group_entitlement()` - App Group not configured, verify graceful degradation

**State Edge Cases**
- `test_menu_bar_during_app_first_launch()` - First app launch, verify default state (menu bar disabled)
- `test_menu_bar_after_settings_reset()` - Reset all settings, verify menu bar returns to default state
- `test_concurrent_update_count_changes()` - Rapid count changes, verify no race conditions

## Mocking Requirements

**UserDefaults Mocking**
- Mock `UserDefaults(suiteName: "group.com.alienator88.Pearcleaner")` for shared storage tests
- Use in-memory UserDefaults for settings persistence tests
- Reset mock UserDefaults between tests

**UpdateManager Mocking**
- Mock `UpdateManager.shared` to simulate update counts without real update checks
- Mock individual checkers (App Store, Homebrew, Sparkle) to control count sources
- Provide test fixtures for various update scenarios (0 updates, mixed sources, high counts)

**Time Mocking**
- Mock `Date()` for last check timestamp tests
- Fast-forward time to test timestamp display formatting (e.g., "2 hours ago", "yesterday")

**NSWorkspace Mocking**
- Mock `NSWorkspace.shared.open()` for app launch action tests
- Mock `NSApp.activate(ignoringOtherApps:)` for window activation tests

**MenuBarExtra Availability**
- Tests requiring actual menu bar rendering should use UI tests (XCUITest)
- Unit tests should verify state management without rendering menu bar
- Integration tests can use headless mode or skip on CI if menu bar API unavailable

## Test Data Fixtures

**Update Count Scenarios:**
- `noUpdates`: 0 total updates across all sources
- `singleSource`: 3 App Store updates only
- `mixedSources`: 2 App Store + 4 Homebrew + 1 Sparkle = 7 total
- `highCount`: 150 updates (test 99+ badge display)

**Timestamp Fixtures:**
- `justNow`: Current timestamp (< 1 minute ago)
- `hoursAgo`: 3 hours ago
- `yesterday`: 25 hours ago
- `weekAgo`: 7 days ago
- `never`: nil (never checked)

**Settings State Fixtures:**
- `menuBarEnabled`: showMenuBar = true
- `menuBarDisabled`: showMenuBar = false
- `freshInstall`: No existing UserDefaults keys

## Manual Testing Checklist

**Visual Verification (Manual QA):**
- [ ] Menu bar icon appears in correct position (right side of menu bar)
- [ ] Badge overlays icon correctly without visual artifacts
- [ ] Dropdown menu visual styling matches macOS standards
- [ ] Icon states (idle, checking, updates) are visually distinct
- [ ] High contrast mode compatibility
- [ ] Dark mode / light mode appearance

**User Interaction (Manual QA):**
- [ ] Menu bar icon responds to mouse hover
- [ ] Click opens dropdown menu smoothly
- [ ] Click outside menu closes dropdown
- [ ] Keyboard navigation works in menu (tab, arrow keys)
- [ ] "Open Pearcleaner" button responds to click and Enter key
- [ ] Settings toggle provides immediate visual feedback

**Performance (Manual Observation):**
- [ ] No noticeable delay when toggling menu bar visibility
- [ ] Badge updates appear promptly after update check
- [ ] Menu dropdown opens without lag
- [ ] No beach ball or UI freezing during state updates
