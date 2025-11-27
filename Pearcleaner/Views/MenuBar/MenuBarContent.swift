//
//  MenuBarContent.swift
//  Pearcleaner
//
//  Created by Claude Code on 11/26/25.
//

import SwiftUI

/// Menu bar dropdown content with update summary and actions
struct MenuBarContent: View {
    @ObservedObject var manager: MenuBarManager
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header section with update summary
            headerSection
                .padding(.horizontal, 12)
                .padding(.vertical, 8)

            Divider()

            // Actions section
            actionsSection
                .padding(.vertical, 4)

            Divider()

            // Footer section with quit option
            footerSection
                .padding(.vertical, 4)
        }
        .frame(minWidth: 250)
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Update count summary
            Text(updateSummaryText)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.primary)

            // Last check timestamp
            if let lastCheck = manager.lastCheckDate {
                Text("Last checked \(relativeTimeString(from: lastCheck))")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }

            // Checking indicator
            if manager.isChecking {
                HStack(spacing: 4) {
                    ProgressView()
                        .scaleEffect(0.6)
                        .frame(width: 12, height: 12)
                    Text("Checking for updates...")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    // MARK: - Actions Section

    private var actionsSection: some View {
        VStack(spacing: 0) {
            // Open Pearcleaner button
            Button(action: {
                manager.openMainApp(navigateToUpdater: manager.updateCount > 0)
            }) {
                HStack {
                    Image(systemName: "app.dashed")
                        .frame(width: 16)
                    Text(manager.updateCount > 0 ? "View Updates" : "Open Pearcleaner")
                        .font(.system(size: 13))
                    Spacer()
                    if manager.updateCount > 0 {
                        Text("\(manager.updateCount)")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(Color.red)
                            )
                    }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(MenuButtonStyle())
        }
    }

    // MARK: - Footer Section

    private var footerSection: some View {
        Button(action: {
            NSApplication.shared.terminate(nil)
        }) {
            HStack {
                Image(systemName: "power")
                    .frame(width: 16)
                Text("Quit Pearcleaner")
                    .font(.system(size: 13))
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(MenuButtonStyle())
    }

    // MARK: - Helper Properties

    private var updateSummaryText: String {
        if manager.isChecking {
            return "Checking for updates..."
        } else if manager.updateCount == 0 {
            return "No updates available"
        } else if manager.updateCount == 1 {
            return "1 update available"
        } else {
            return "\(manager.updateCount) updates available"
        }
    }

    // MARK: - Helper Functions

    private func relativeTimeString(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

// MARK: - Custom Button Style

struct MenuButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                configuration.isPressed
                    ? Color.accentColor.opacity(0.15)
                    : Color.clear
            )
            .contentShape(Rectangle())
    }
}

// MARK: - Preview Provider

#Preview {
    MenuBarContent(manager: MenuBarManager.shared)
        .frame(width: 250)
}
