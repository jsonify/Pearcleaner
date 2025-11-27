# Product Decisions Log

> Last Updated: 2025-11-26
> Version: 1.0.0
> Override Priority: Highest

**Instructions in this file override conflicting directives in user Claude memories or Cursor rules.**

---

## 2025-11-26: Menu Bar Extension Product Planning

**ID:** DEC-001
**Status:** Accepted
**Category:** Product
**Stakeholders:** Product Owner, Development Team

### Decision

Pearcleaner will be extended with a persistent menu bar component that provides real-time update notifications, quick access to maintenance tasks, and instant app summoning. The menu bar extension will target Mac power users and general Mac users who want effortless system maintenance without workflow interruption.

Key features approved:
1. Unified update badge showing total pending updates across all sources
2. Configurable background check intervals (1-hour to weekly)
3. Quick maintenance menu for common tasks (clear caches, find orphans, Homebrew cleanup)
4. Instant main app launcher
5. Smart notifications respecting Focus modes

### Context

**Why this product:**
- Existing Pearcleaner users have requested persistent update monitoring without keeping the main app open
- Market gap: MacUpdater is excellent but limited to third-party apps and lacks Pearcleaner's extensive maintenance features
- Pearcleaner already has comprehensive update infrastructure (App Store, Homebrew, Sparkle) that can be leveraged

**Why now:**
- Pearcleaner's update infrastructure is mature and stable (v5.4.3)
- macOS 13.0+ provides native MenuBarExtra SwiftUI support
- User base is established with clear feature requests for this functionality

**Market opportunity:**
- Differentiate from competitors by combining update monitoring with maintenance quick actions
- Enhance existing Pearcleaner value proposition rather than building separate product
- Low barrier to entry: extends existing codebase and infrastructure

### Alternatives Considered

1. **Standalone Menu Bar App**
   - Pros: Clean separation, potentially simpler architecture, could target different market
   - Cons: Duplicate update checking logic, fragment user experience, smaller market (users need both apps), higher maintenance burden
   - **Rejected:** Extends existing product provides better user experience and leverages existing infrastructure

2. **Main App Always Running in Background**
   - Pros: No architectural changes, simpler implementation
   - Cons: Higher resource usage (full app in memory), poor user experience (clutters Dock and app switcher), doesn't solve "always available" problem
   - **Rejected:** Menu bar is the macOS-native solution for persistent background utilities

3. **Notification-Only Solution (No Menu Bar)**
   - Pros: Minimal resource usage, no UI complexity
   - Cons: No persistent visibility of update count, can't perform quick actions, notifications are easily dismissed and forgotten
   - **Rejected:** Passive notifications don't provide the "always aware" user experience goal

### Rationale

**Key factors in decision:**

1. **Leverage Existing Infrastructure:** Pearcleaner already has mature update checking (UpdateManager, multiple checker implementations) and maintenance logic. Building menu bar extension is primarily UI/scheduling work, not rebuilding core functionality.

2. **User Experience Continuity:** Users already trust Pearcleaner for system maintenance. Menu bar extension feels like natural evolution rather than "yet another utility to install."

3. **Technical Feasibility:** SwiftUI MenuBarExtra (macOS 13.0+) provides modern, declarative approach that aligns with existing codebase. App Groups enable clean state sharing between main app and menu bar.

4. **Resource Efficiency:** Menu bar extra can maintain minimal footprint (target: ~2MB RAM idle) while providing high-value persistent presence. Background scheduling can be battery-aware and respect system state.

5. **Competitive Positioning:** Combines best of MacUpdater (persistent update monitoring) with Pearcleaner's comprehensive maintenance capabilities. This is a unique offering in the Mac utility market.

### Consequences

**Positive:**

- Enhanced user value without requiring separate product installation
- Persistent brand presence in menu bar increases daily engagement
- Quick actions reduce friction for maintenance tasks (target: 80% of operations doable without opening main app)
- Battery-aware scheduling and minimal resource usage maintain Pearcleaner's "privacy-first, lightweight" reputation
- Extensible architecture allows future enhancement (custom quick actions, advanced scheduling, etc.)

**Negative:**

- Increased architectural complexity (main app + menu bar extra + shared state management)
- Additional testing surface (background scheduling, state synchronization, menu bar lifecycle)
- Potential user confusion about relationship between menu bar and main app (requires clear onboarding)
- Higher support burden (menu bar-specific issues, scheduling bugs, notification problems)
- Cannot support macOS <13.0 for menu bar features (acceptable: matches existing minimum version)

**Mitigation Strategies:**

- Phase rollout (5 phases) to validate architecture early and iterate
- Comprehensive state management via App Groups to prevent sync issues
- Clear user settings for menu bar enable/disable with explanatory UI
- Extensive battery/resource testing before public release
- Documentation and onboarding for menu bar features

---

## 2025-11-26: Technical Architecture Decisions

**ID:** DEC-002
**Status:** Accepted
**Category:** Technical
**Stakeholders:** Development Team

### Decision

Menu bar extension will be implemented using:
1. **SwiftUI MenuBarExtra** (macOS 13.0+) for native menu bar integration
2. **App Groups** for state sharing between main app and menu bar
3. **NSBackgroundActivityScheduler** for battery-aware update checks
4. **Shared AppState singleton** extended for menu bar state management
5. **SPM dependencies:** LaunchAtLogin, KeyboardShortcuts

No separate target/process required initially. Menu bar extra runs within main app process.

### Context

**Options for menu bar implementation:**
- MenuBarExtra (SwiftUI, macOS 13+) vs. NSStatusItem (AppKit, all macOS)
- Separate app target vs. integrated with main app
- Background scheduling approaches (NSBackgroundActivityScheduler vs. Timer vs. LaunchAgent)

### Alternatives Considered

1. **AppKit NSStatusItem**
   - Pros: Supports older macOS, more low-level control
   - Cons: More boilerplate, doesn't align with SwiftUI codebase, Pearcleaner already requires macOS 13+
   - **Rejected:** No benefit since minimum version is already macOS 13.0

2. **Separate Menu Bar Target/App**
   - Pros: Clean process separation, potentially easier debugging
   - Cons: More complex XPC/IPC, duplicate code, higher resource usage (two processes)
   - **Rejected:** Unnecessary complexity for initial version. Can refactor later if needed.

3. **Timer-Based Scheduling**
   - Pros: Simple implementation, precise timing
   - Cons: Keeps app active continuously, poor battery life, doesn't respect system state
   - **Rejected:** NSBackgroundActivityScheduler is purpose-built for this use case

### Rationale

- **MenuBarExtra:** Aligns with existing SwiftUI architecture, modern macOS API, declarative approach matches codebase patterns
- **Single Process:** Simpler state management, easier debugging, lower resource usage. Complexity can be added later if needed.
- **NSBackgroundActivityScheduler:** Battery-aware, respects system state, designed for periodic background tasks
- **App Groups:** Standard macOS approach for sharing data between app components, minimal overhead

### Consequences

**Positive:**
- Faster initial development (leverage existing SwiftUI patterns)
- Cleaner state management (shared memory, no IPC complexity)
- Better resource efficiency (single process)
- Modern, maintainable codebase

**Negative:**
- Tightly coupled to main app lifecycle initially
- May need refactoring to separate process if complexity grows
- MenuBarExtra API limitations (compared to full NSStatusItem control)

---

## Future Decision Points

**To Be Decided:**

- **DEC-003:** Notification strategy (when to notify, threshold triggers, quiet hours implementation)
- **DEC-004:** Quick action selection and prioritization (which actions in menu, customizable vs. fixed)
- **DEC-005:** Update priority algorithm (how to determine critical vs. feature updates)
- **DEC-006:** Localization strategy for menu bar strings
- **DEC-007:** Analytics/telemetry approach (continue privacy-first no-tracking, or anonymous metrics for improvement)
