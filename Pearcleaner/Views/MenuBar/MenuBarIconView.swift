//
//  MenuBarIconView.swift
//  Pearcleaner
//
//  Created by Claude Code on 11/26/25.
//

import SwiftUI

/// Icon states for menu bar display
enum MenuBarIconState {
    case idle
    case checking
    case updatesAvailable(count: Int)

    var symbolName: String {
        switch self {
        case .idle:
            return "app.badge"
        case .checking:
            return "app.badge"
        case .updatesAvailable:
            return "app.badge"
        }
    }
}

/// Menu bar icon view with dynamic badge and state visualization
struct MenuBarIconView: View {
    @ObservedObject var manager: MenuBarManager

    // Computed icon state based on manager properties
    private var iconState: MenuBarIconState {
        if manager.isChecking {
            return .checking
        } else if manager.updateCount > 0 {
            return .updatesAvailable(count: manager.updateCount)
        } else {
            return .idle
        }
    }

    // Badge text for update count
    private var badgeText: String? {
        guard case .updatesAvailable(let count) = iconState, count > 0 else {
            return nil
        }

        // Show "99+" for high counts
        return count > 99 ? "99+" : "\(count)"
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Base icon
            Image(systemName: iconState.symbolName)
                .font(.system(size: 16))
                .rotationEffect(manager.isChecking ? .degrees(360) : .degrees(0))
                .animation(
                    manager.isChecking ? Animation.linear(duration: 2.0).repeatForever(autoreverses: false) : .default,
                    value: manager.isChecking
                )

            // Badge overlay
            if let badge = badgeText {
                Text(badge)
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(
                        Capsule()
                            .fill(Color.red)
                    )
                    .offset(x: 8, y: -4)
            }
        }
        .frame(width: 22, height: 22)
        .help(tooltipText)
    }

    // Tooltip text based on state
    private var tooltipText: String {
        switch iconState {
        case .idle:
            if let lastCheck = manager.lastCheckDate {
                return "No updates • Last checked \(relativeTimeString(from: lastCheck))"
            } else {
                return "No updates available"
            }
        case .checking:
            return "Checking for updates..."
        case .updatesAvailable(let count):
            let plural = count == 1 ? "update" : "updates"
            if let lastCheck = manager.lastCheckDate {
                return "\(count) \(plural) available • Last checked \(relativeTimeString(from: lastCheck))"
            } else {
                return "\(count) \(plural) available"
            }
        }
    }

    // Convert Date to relative time string
    private func relativeTimeString(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

// MARK: - Preview Provider

#Preview {
    MenuBarIconView(manager: MenuBarManager.shared)
}
