# Technical Specification

This is the technical specification for the spec detailed in @.agent-os/specs/2025-11-26-menubar-foundation/spec.md

> Created: 2025-11-26
> Version: 1.0.0

## Technical Requirements

### Menu Bar Integration

- **MenuBarExtra**: Use SwiftUI `MenuBarExtra` API (macOS 13.0+) for menu bar presence
- **Icon Asset**: SF Symbol `app.badge` with dynamic badge overlay showing count
- **Icon States**:
  - Idle: `app.badge` gray, no badge number
  - Checking: `app.badge` with subtle rotation animation
  - Updates Available: `app.badge` with numeric badge overlay (1-99+)
- **Menu Content**: SwiftUI view with:
  - Header showing update count summary
  - Last check timestamp (if available)
  - "Open Pearcleaner" button action
  - "Check for Updates Now" button (should-have)
  - Divider and "Quit" option (standard macOS pattern)

### State Management

- **Extend AppState**: Add `@Published var showMenuBar: Bool` property
- **Menu Bar State**: Add `@Published var menuBarUpdateCount: Int` property
- **App Group**: Create shared App Group container `group.com.alienator88.Pearcleaner`
- **Shared UserDefaults**:
  - Key: `"menubar.updateCount"` - Current update count
  - Key: `"menubar.lastCheck"` - Last update check timestamp
  - Key: `"menubar.enabled"` - Menu bar visibility preference
- **State Sync**: Menu bar reads from shared UserDefaults, UpdateManager writes to it

### UpdateManager Integration

- **Modify UpdateManager**: Add method to publish update count to shared UserDefaults
- **Count Calculation**: Aggregate total pending updates across all sources (App Store, Homebrew, Sparkle)
- **Update Trigger**: When UpdateManager completes check, update shared UserDefaults atomically
- **Initial Load**: Menu bar reads cached count on launch from shared UserDefaults

### Settings UI Integration

- **Location**: Settings → Interface tab (existing settings window)
- **UI Element**: Toggle switch "Show menu bar icon" with descriptive text
- **Binding**: Two-way binding to `AppState.shared.showMenuBar`
- **Immediate Effect**: When toggled, menu bar should appear/disappear without app restart
- **Persistence**: Setting saved to standard UserDefaults `"settings.interface.showMenuBar"`

### Main App Launcher

- **Action**: "Open Pearcleaner" button in menu dropdown
- **Behavior**:
  - If app not running: Launch app process
  - If app running but hidden: Bring to front and activate
  - If app running and visible: Switch to Updater page
- **Implementation**: Use `NSWorkspace.shared.open()` for deep link or `NSApp.activate(ignoringOtherApps: true)`
- **Navigation**: Optionally navigate to Updater view (`CurrentPage.updater`)

### Performance Requirements

- **Memory**: Menu bar idle state <2MB RAM overhead
- **Launch Time**: Menu bar appears <100ms after app launch (if enabled)
- **Update Response**: Badge updates within 500ms of UpdateManager state change
- **Menu Open**: Dropdown menu appears within 100ms of icon click

## Approach Options

### Option A: Separate Menu Bar Target

**Description:** Create separate app target "PearcleanerMenuBar" that runs as independent process

**Pros:**
- Process isolation (menu bar crash doesn't affect main app)
- Could remain running when main app quits
- Cleaner architecture separation

**Cons:**
- Requires XPC for IPC between processes
- More complex state synchronization
- Higher resource usage (two processes)
- Requires login item for persistence

**Rejected:** Adds unnecessary complexity for Phase 1. Can refactor later if needed.

### Option B: MenuBarExtra within Main App (Selected)

**Description:** Implement MenuBarExtra as part of main Pearcleaner app process using SwiftUI

**Pros:**
- Shared memory space (no IPC needed)
- Direct access to UpdateManager state
- Simpler implementation
- Single process (lower resource usage)
- Aligns with existing SwiftUI architecture

**Cons:**
- Menu bar requires main app running
- Tightly coupled to main app lifecycle

**Rationale:** For Phase 1, simplicity and rapid development are priorities. MenuBarExtra within main app provides immediate value with minimal architectural complexity. State sharing via App Groups still allows future refactoring to separate process if needed. Since Phase 2 will add background scheduling, keeping menu bar in-process is acceptable for initial release.

### Option C: AppKit NSStatusItem

**Description:** Use AppKit NSStatusItem API instead of SwiftUI MenuBarExtra

**Pros:**
- More low-level control
- Supports older macOS versions

**Cons:**
- More boilerplate code
- Doesn't align with SwiftUI codebase
- Pearcleaner already requires macOS 13.0+

**Rejected:** No benefit since minimum macOS version is 13.0. SwiftUI approach is more maintainable.

## Implementation Architecture

### File Structure

```
Pearcleaner/
├── Logic/
│   └── MenuBar/
│       ├── MenuBarManager.swift       # Manages menu bar state and lifecycle
│       └── MenuBarUpdatePublisher.swift # Publishes updates to shared storage
├── Views/
│   └── MenuBar/
│       ├── MenuBarContent.swift       # Dropdown menu SwiftUI view
│       └── MenuBarIconView.swift      # Icon badge rendering
└── PearcleanerApp.swift              # Add MenuBarExtra declaration
```

### Key Components

**MenuBarManager.swift:**
```swift
class MenuBarManager: ObservableObject {
    static let shared = MenuBarManager()
    @Published var updateCount: Int = 0
    @Published var isChecking: Bool = false
    @Published var lastCheckDate: Date?

    func updateFromSharedDefaults()
    func openMainApp()
    func triggerUpdateCheck()
}
```

**PearcleanerApp.swift modification:**
```swift
var body: some Scene {
    WindowGroup { ... }

    if appState.showMenuBar {
        MenuBarExtra {
            MenuBarContent()
        } label: {
            MenuBarIconView()
        }
    }
}
```

**App Group Entitlement:**
```xml
<key>com.apple.security.application-groups</key>
<array>
    <string>group.com.alienator88.Pearcleaner</string>
</array>
```

## External Dependencies

**None required for Phase 1.**

All functionality leverages existing SwiftUI framework APIs and Pearcleaner infrastructure. Future phases will add:
- LaunchAtLogin (Phase 5) - `sindresorhus/LaunchAtLogin`
- KeyboardShortcuts (Phase 5) - `sindresorhus/KeyboardShortcuts`

## Integration Points

### UpdateManager Integration

1. Extend `UpdateManager.swift` with:
```swift
private func publishToMenuBar(updateCount: Int) {
    guard let sharedDefaults = UserDefaults(suiteName: "group.com.alienator88.Pearcleaner") else { return }
    sharedDefaults.set(updateCount, forKey: "menubar.updateCount")
    sharedDefaults.set(Date(), forKey: "menubar.lastCheck")
}
```

2. Call after update check completion in existing UpdateManager methods

### Settings UI Integration

Add to `Views/Settings/Interface.swift`:
```swift
Toggle("Show menu bar icon", isOn: $appState.showMenuBar)
    .onChange(of: appState.showMenuBar) { newValue in
        // MenuBarExtra automatically responds to state change
        UserDefaults.standard.set(newValue, forKey: "settings.interface.showMenuBar")
    }
```

### AppState Extension

Add to `AppState.swift`:
```swift
@Published var showMenuBar: Bool = UserDefaults.standard.bool(forKey: "settings.interface.showMenuBar")
```

## Data Flow

1. **UpdateManager** completes update check → calculates total count
2. **UpdateManager** writes count to shared UserDefaults (`group.com.alienator88.Pearcleaner`)
3. **MenuBarManager** observes shared UserDefaults changes
4. **MenuBarManager** updates `@Published updateCount` property
5. **MenuBarIconView** reactively updates badge display
6. User clicks icon → **MenuBarContent** view displays current state
7. User clicks "Open Pearcleaner" → **MenuBarManager.openMainApp()** activates window
