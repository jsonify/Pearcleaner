# Product Mission

> Last Updated: 2025-11-26
> Version: 1.0.0

## Pitch

Pearcleaner Menu Bar Extension is a lightweight, always-available macOS utility that helps Mac users maintain their systems effortlessly by providing real-time app update notifications, quick access to maintenance tasks, and instant app summoning—all from the convenience of the menu bar.

## Users

### Primary Customers

- **Mac Power Users**: Users who manage multiple applications and need proactive maintenance without cluttering their workflow
- **General Mac Users**: Everyday Mac users who want a simple, set-it-and-forget-it solution to keep their system clean and updated

### User Personas

**Alex - The Productivity Enthusiast** (28-45 years old)
- **Role:** Software Developer / Creative Professional
- **Context:** Manages 30+ applications including development tools, creative software, and utilities
- **Pain Points:** Constantly checking for updates manually, forgetting to run maintenance tasks, switching between apps to manage system health
- **Goals:** Stay updated without interrupting workflow, maintain system performance with minimal effort, quick access to cleanup tools when disk space is low

**Jamie - The Casual Mac User** (25-60 years old)
- **Role:** Office Worker / Home User
- **Context:** Uses Mac for daily tasks, runs 10-15 applications regularly
- **Pain Points:** Unsure when apps need updates, Mac feels slow over time, doesn't know what maintenance tasks to perform
- **Goals:** Keep Mac running smoothly without technical knowledge, get notified about important updates, simple one-click maintenance

## The Problem

### Hidden Update Fatigue

Users must manually check multiple sources (App Store, Homebrew, Sparkle updaters) to keep apps current. This fragmented update landscape leads to outdated software, security vulnerabilities, and missed features. **Our Solution:** Unified update monitoring across all sources with a persistent, non-intrusive menu bar indicator showing total pending updates.

### Maintenance Task Friction

Essential maintenance tasks like cache clearing, orphaned file removal, and app cleanup require opening dedicated apps or remembering terminal commands. Most users perform maintenance only when problems arise. **Our Solution:** One-click access to common maintenance tasks directly from the menu bar, with configurable automated checks.

### Context Switching Overhead

Accessing Pearcleaner's full features requires finding and launching the app, interrupting current workflows. Users delay system maintenance because it feels like a separate "task" rather than a quick action. **Our Solution:** Instant app summoning and quick actions from the menu bar, reducing maintenance friction to a single click.

## Differentiators

### Intelligent Update Aggregation

Unlike MacUpdater which focuses primarily on third-party apps, Pearcleaner integrates deeply with multiple update sources (App Store, Homebrew, Sparkle) while providing granular control over check frequencies. This results in a single source of truth for all app updates with minimal battery impact through smart scheduling.

### Extensible Quick Actions

Unlike traditional menu bar apps that simply launch the main application, Pearcleaner's menu bar extension provides context-aware quick actions for common maintenance tasks. This results in 80% of maintenance operations being completable without opening the full app window.

### Privacy-First Background Monitoring

Unlike cloud-based update checkers, all monitoring happens locally with configurable intervals (hourly to weekly) that respect battery life and system resources. This results in zero telemetry, minimal resource usage (~2MB RAM idle), and complete user control over check frequency.

## Key Features

### Core Features

- **Unified Update Badge:** Real-time count of available updates across all sources (App Store, Homebrew, Sparkle) displayed in menu bar icon
- **Configurable Check Intervals:** User-selectable refresh frequencies (1 hour, 6 hours, 12 hours, daily, weekly) with smart scheduling to avoid battery drain
- **Quick Maintenance Menu:** One-click access to common tasks: clear caches, remove orphaned files, run Homebrew cleanup, check disk space
- **Instant App Launcher:** Summon full Pearcleaner window with keyboard shortcut or menu click, resuming exactly where you left off

### Update Management Features

- **Update Preview:** Hover over menu bar icon to see list of pending updates without opening the app
- **Selective Update Ignoring:** Right-click specific apps in menu to ignore updates (temporary or permanent)
- **Update Priority Indicators:** Visual distinction between critical security updates vs. feature updates
- **Silent Background Updates:** Option to auto-update selected apps (Homebrew casks with auto_updates flag) without user intervention

### Notification & Alert Features

- **Smart Notifications:** Configurable alerts when update count exceeds threshold (e.g., notify when 5+ updates available)
- **Quiet Hours:** Respect macOS Focus modes and user-defined quiet hours for update checks and notifications
- **Update Summaries:** Weekly/monthly digest of updates installed and maintenance tasks performed

### System Integration Features

- **Menu Bar Customization:** Show/hide update count, use icon-only or text-based display, color coding for update urgency
- **Keyboard Shortcuts:** Global hotkeys for common actions (summon app, run quick cleanup, check updates now)
- **Resource Monitoring:** Display current disk space usage and purgeable space in menu dropdown
