# Technical Stack

> Last Updated: 2025-11-26
> Version: 1.0.0

## Application Framework

**SwiftUI** (macOS 13.0+)
- Existing Pearcleaner codebase foundation
- Native macOS menu bar support via `MenuBarExtra`
- Declarative UI for quick action menus

## Menu Bar Architecture

**NSStatusItem / MenuBarExtra**
- Native macOS menu bar integration
- SwiftUI MenuBarExtra for modern macOS 13+ support
- Fallback to AppKit NSStatusItem for compatibility

## Background Services

**LaunchAgent**
- Scheduled update checks using `NSBackgroundActivityScheduler`
- Battery-aware scheduling with `QualityOfService.utility`
- User-configurable intervals via UserDefaults

## State Management

**AppState (Existing)**
- Extend existing singleton for menu bar state
- Published properties for update counts and status
- Shared state between main app and menu bar extra

## Update Monitoring

**Existing Update Infrastructure**
- Leverage existing `UpdateManager.swift`
- Extend `SparkleUpdateChecker`, `HomebrewUpdateChecker`, `AppStoreUpdateChecker`
- Add background scheduling layer for periodic checks

## Data Persistence

**UserDefaults**
- Menu bar preferences (show/hide, check intervals, ignored apps)
- Last check timestamps
- Update check scheduling configuration

**Shared App Group**
- Communication between main app and menu bar extra
- Shared UserDefaults via App Group container
- File coordination for update state

## Notifications

**UserNotifications Framework**
- Native macOS notification center integration
- Actionable notifications (update now, view details, dismiss)
- Respect Focus modes and Do Not Disturb

## Inter-Process Communication

**Combine Framework**
- Published state changes from background checks
- Reactive UI updates in menu bar
- Debouncing for update check triggers

**NSDistributedNotificationCenter**
- Communication between main app and menu bar extra
- Update state synchronization
- Quick action triggers

## Resource Optimization

**Memory Management**
- Target: ~2MB RAM idle, ~15MB during update checks
- Lazy loading of update metadata
- Release resources after check completion

**Battery Optimization**
- Defer checks when on battery and <20%
- Coalesce update checks with system activity
- Respect `ProcessInfo.thermalState`

## System Integration

**LaunchAtLogin**
- Third-party framework: `sindresorhus/LaunchAtLogin` (SPM)
- Persistent menu bar presence option
- User-configurable auto-launch

**Keyboard Shortcuts**
- `KeyboardShortcuts` SPM package for global hotkeys
- Configurable shortcuts for summon app, quick cleanup

## Code Repository

**Current Repository:** https://github.com/alienator88/Pearcleaner
- Extension developed in main repository
- Feature branch: `feature/menubar-extension`

## Dependencies (Swift Package Manager)

**Existing:**
- `AlinFoundation` (local framework)

**New for Menu Bar:**
- `sindresorhus/LaunchAtLogin` - Auto-launch support
- `sindresorhus/KeyboardShortcuts` - Global hotkey management

## Build Configuration

**Xcode Project:** Pearcleaner.xcodeproj
- New target: PearcleanerMenuBar (optional, or extend main app)
- Shared code framework for common logic
- App Group entitlement for data sharing

## Deployment

**Distribution:** GitHub Releases
- Existing release process via GitHub Actions
- Notarization for menu bar components
- Homebrew cask update (existing: `brew install pearcleaner`)

## Version Support

**macOS Versions:**
- Minimum: macOS 13.0 (Ventura) - existing requirement
- MenuBarExtra requires macOS 13.0+
- Fallback for older versions: n/a (existing min version)

## Localization

**Existing:** Localizable.xcstrings
- Extend for menu bar strings
- Support existing languages
