# Spec Requirements Document

> Spec: Menu Bar Foundation (Phase 1)
> Created: 2025-11-26
> Status: Planning

## Overview

Implement a persistent menu bar component for Pearcleaner that displays the current count of available app updates and provides quick access to launch the main application. This foundation establishes the core menu bar infrastructure that subsequent phases will build upon, leveraging existing UpdateManager infrastructure while introducing shared state management between menu bar and main app.

## User Stories

### Menu Bar Awareness

As a Mac user with Pearcleaner installed, I want to see at a glance how many app updates are available without opening the full application, so that I can stay informed about system maintenance needs while working.

**Workflow:** User installs Pearcleaner and enables the menu bar option in Settings. A small icon appears in the macOS menu bar showing a badge with the number of pending updates (e.g., "5"). The badge updates automatically when the main app detects new updates. User can glance at menu bar anytime to see if maintenance is needed without context switching.

### Quick App Access

As a Pearcleaner user who keeps the menu bar icon enabled, I want to quickly open the full Pearcleaner window from the menu bar, so that I can perform detailed maintenance tasks when I see updates are available.

**Workflow:** User clicks the menu bar icon and sees a dropdown menu showing a summary (e.g., "5 updates available") with an "Open Pearcleaner" button. Clicking this button brings the main Pearcleaner window to the front (or launches it if not running), navigating directly to the Updater view where they can review and install updates.

### Flexible Visibility Control

As a user who sometimes wants the menu bar icon and sometimes doesn't, I want to easily toggle the menu bar presence on/off in Pearcleaner settings, so that I can customize my menu bar based on my current workflow preferences.

**Workflow:** User opens Pearcleaner Settings → Interface tab and finds a checkbox "Show menu bar icon". Toggling this checkbox immediately adds or removes the Pearcleaner icon from the menu bar without requiring app restart. The setting persists across app launches.

## Spec Scope

1. **MenuBarExtra Integration** - SwiftUI-based menu bar icon with badge showing update count from existing UpdateManager
2. **Basic Dropdown Menu** - Menu displays update summary ("X updates available"), last check time, and "Open Pearcleaner" action
3. **App Group State Sharing** - Shared UserDefaults container for update count and state synchronization between menu bar and main app
4. **Settings Toggle** - User preference in Settings → Interface to enable/disable menu bar icon with immediate effect
5. **Icon Visual States** - Three icon states: idle (no updates), checking (animated), updates available (badge with count)

## Out of Scope

- Background update scheduling (Phase 2)
- Quick maintenance actions from menu bar (Phase 3)
- Configurable check intervals (Phase 2)
- Notifications for new updates (Phase 4)
- Keyboard shortcut configuration UI (Phase 5)
- Custom menu bar icon themes or colors (Phase 5)

## Expected Deliverable

1. **Menu bar icon visible with update count:** When settings toggle is enabled, menu bar shows Pearcleaner icon with badge reflecting current update count from UpdateManager
2. **Dropdown menu functions correctly:** Clicking icon opens menu showing update summary and "Open Pearcleaner" button that successfully brings main window to front
3. **Settings toggle works immediately:** Toggling "Show menu bar icon" in Settings → Interface instantly adds/removes menu bar presence without restart
4. **State synchronization verified:** Update count in menu bar matches count shown in main app Updater view, even when updated while menu bar is showing
5. **Icon states visually distinct:** User can distinguish between idle state (no updates), checking state (brief animation), and updates available state (numbered badge)

## Spec Documentation

- Tasks: @.agent-os/specs/2025-11-26-menubar-foundation/tasks.md
- Technical Specification: @.agent-os/specs/2025-11-26-menubar-foundation/sub-specs/technical-spec.md
- Tests Specification: @.agent-os/specs/2025-11-26-menubar-foundation/sub-specs/tests.md
