# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Pearcleaner is a macOS app cleaner written in SwiftUI that helps users uninstall applications and remove associated files. The project consists of:
- **Main App** (Pearcleaner): Primary SwiftUI application
- **Privileged Helper** (PearcleanerHelper): XPC service for system-level file operations
- **Sentinel Monitor** (PearcleanerSentinel): Background daemon for automatic trash monitoring
- **Finder Extension** (FinderOpen): Finder Sync extension for right-click uninstall

## Building and Running

### Build Commands
```bash
# Build in Xcode (if Xcode is installed)
open Pearcleaner.xcodeproj

# The project requires Xcode to build, not just Command Line Tools
# Targets: Pearcleaner, PearcleanerHelper, PearcleanerSentinel, FinderOpen
```

### CLI Mode
The app supports CLI usage through deep links and command-line arguments. See `CLI.swift` and `DeepLink.swift` for implementation details.

### Deep Links
The app responds to `pear://` URL scheme for automation:
```
pear://com.alienator88.Pearcleaner?path=/Applications/Example.app
```

## Architecture

### State Management
- **AppState.swift**: Central singleton managing app-level state via `@Published` properties
  - `sortedApps`: Main app list cache with two-phase loading (AppInfoMini → AppInfo)
  - `appInfo`: Currently selected app for file scanning
  - `zombieFile`: Orphaned files management
  - Volume information, UI state, and multi-app selection handling

### Two-Phase App Loading System
The codebase uses a streaming architecture for fast initial app list display:
1. **Phase 1 (AppInfoMini)**: Fast load with essential properties only (name, icon, size, dates)
2. **Phase 2 (AppInfo)**: Background enrichment with expensive properties (architecture, update sources, entitlements)

Key files: `AppState.swift` (AppInfoMini/AppInfo structs), `AppInfoFetch.swift`

### Core Logic Modules

**App Management**:
- `AppInfoFetch.swift`: App metadata extraction and discovery
- `AppPathsFetch.swift`: File scanning for app-related files across system
- `ReversePathsFetch.swift`: Orphaned file discovery (zombie files)
- `Conditions.swift`: Search sensitivity levels and filtering logic
- `Locations.swift`: System directory paths and search locations

**File Operations**:
- `HelperToolManager.swift`: Privileged helper XPC communication for system file operations
- `UndoManager.swift` / `UndoHistoryManager.swift`: Undo support for deletions with persistent history

**Update Management** (`Logic/AppsUpdater/`):
- Multi-source update checking (App Store, Homebrew, Sparkle framework)
- `UpdateManager.swift`: Central update coordinator
- `SparkleUpdateDriver.swift` / `SparkleUpdateOperation.swift`: Sparkle framework automation
- `HomebrewUpdateChecker.swift`: Homebrew cask update detection
- `AppStoreUpdateChecker.swift`: App Store updates via `softwareupdate` CLI

**Homebrew Integration** (`Logic/Brew/`):
- `HomebrewManager.swift`: Formula/cask installation and management
- `HomebrewController.swift`: CLI command execution
- `HomebrewAutoUpdateManager.swift`: Scheduled homebrew updates

**Utilities**:
- `Lipo.swift`: Universal binary architecture stripping (without Xcode lipo)
- `PKG/PKGManager.swift`: macOS package installer extraction and analysis
- `FuzzySearch.swift`: Fuzzy string matching for app search
- `Utilities.swift`: Common helper functions

### View Architecture

**Navigation Structure**:
- `MainWindow.swift`: Root window with tabbed navigation via `CurrentPage` enum
- Pages: Applications, Development, File Search, Homebrew, Lipo, Orphans, Packages, Plugins, Services, Updater

**Key View Patterns**:
- `Views/AppsView/`: App list (grid/list modes) with search
- `Views/FilesView/`: File list for selected app with category grouping
- `Views/AppsUpdaterView/`: Multi-source update management UI
- `Views/Brew/`: Homebrew package management interface
- `Views/Settings/`: Multi-tab settings window

**Reusable Components**:
- `Views/Components/SidebarDetailView/`: Generic sidebar+detail layout pattern
- `Style/`: Custom view modifiers, themes, and styling components

### Dependencies

The project uses `AlinFoundation` framework (likely a local or personal framework). Look for imports to understand required framework APIs.

### Permission System

**Required Permissions**:
- **Full Disk Access**: Essential for file scanning across system directories
- **Privileged Helper**: SMJobBless-based helper for system file deletion

See `PermissionsSheetView.swift` for permission request UI and `HelperToolManager.swift` for privileged operations.

### XPC Services

**PearcleanerHelper** (Privileged Helper):
- Installed via SMJobBless for elevated file operations
- See `main.swift` in PearcleanerHelper directory
- Protocol defined for XPC communication (look for XPC-related code in HelperToolManager)

**PearcleanerSentinel** (Sentinel Monitor):
- Background daemon watching Trash for automatic cleanup
- Implemented as LaunchAgent with file system events monitoring
- See `FileWatcher.swift` for FSEvents implementation

## Development Practices

### Localization
The app supports multiple languages via `Localizable.xcstrings` files. Use `String(localized:)` for all user-facing strings.

### Async/Concurrent Operations
- Heavy operations use `DispatchQueue.global(qos: .userInitiated)`
- UI updates wrapped in `Task { @MainActor in ... }`
- Parallel processing via chunking: see `createOptimalChunks()` in Logic.swift

### Bundle Cache Management
After app updates, flush bundle caches using `flushBundleCaches(for:)` or `flushBundleCache(for:)` to ensure fresh Info.plist data.

### User Defaults Keys
Settings are stored with structured keys like `"settings.interface.startupView"`, `"settings.general.zombie.associations"`. Check existing code for naming patterns.

## Testing

The project structure includes main app targets and helper components. Test across:
- Different macOS versions (Ventura 13.x, Sonoma 14.x, Sequoia 15.x minimum)
- Permission states (with/without Full Disk Access)
- Privileged helper installation/communication
- Deep link handling and CLI mode

## Common Workflows

### Adding New File Search Locations
1. Update `Locations.swift` with new search paths
2. Modify `AppPathsFetch.swift` search logic
3. Update `Conditions.swift` if new sensitivity filtering needed

### Adding New Update Sources
1. Create checker in `Logic/AppsUpdater/` following existing patterns
2. Register in `UpdateManager.swift`
3. Add UI in `AppsUpdaterView/`

### Modifying File Operations
1. Check if privileged access needed (system directories)
2. If yes, extend helper in `PearcleanerHelper/main.swift` and update `HelperToolManager.swift`
3. If no, use standard FileManager operations with proper error handling

## Known Patterns

**Zombie Files**: Orphaned files are stored persistently with app associations via `ZombieFileStorage` (UserDefaults-backed). See `AppState.swift` for ZombieFile management.

**Multi-App Operations**: The app supports batch operations through `externalPaths` array and `multiMode` state. See deep link handling in `DeepLink.swift`.

**Volume Information**: Disk space tracking includes purgeable space calculations. See `loadVolumeInfo()` in `AppState.swift`.

## Agent OS Documentation

### Product Context
- **Mission & Vision:** @.agent-os/product/mission.md
- **Technical Architecture:** @.agent-os/product/tech-stack.md
- **Development Roadmap:** @.agent-os/product/roadmap.md
- **Decision History:** @.agent-os/product/decisions.md

### Development Standards
- **Code Style:** @~/.agent-os/standards/code-style.md
- **Best Practices:** @~/.agent-os/standards/best-practices.md

### Project Management
- **Active Specs:** @.agent-os/specs/
- **Spec Planning:** Use `@~/.agent-os/instructions/create-spec.md`
- **Tasks Execution:** Use `@~/.agent-os/instructions/execute-tasks.md`

## Workflow Instructions

When asked to work on this codebase:

1. **First**, check @.agent-os/product/roadmap.md for current priorities
2. **Then**, follow the appropriate instruction file:
   - For new features: @.agent-os/instructions/create-spec.md
   - For tasks execution: @.agent-os/instructions/execute-tasks.md
3. **Always**, adhere to the standards in the files listed above

## Important Notes

- Product-specific files in `.agent-os/product/` override any global standards
- User's specific instructions override (or amend) instructions found in `.agent-os/specs/...`
- Always adhere to established patterns, code style, and best practices documented above.
