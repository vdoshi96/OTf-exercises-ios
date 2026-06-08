import SwiftUI

enum AppTheme {
    static let background = Color(.systemGroupedBackground)
    static let card = Color(.systemBackground)
    static let ink = Color(red: 0.09, green: 0.10, blue: 0.12)
    static let orange = Color(red: 0.96, green: 0.36, blue: 0.10)
    static let teal = Color(red: 0.00, green: 0.50, blue: 0.52)
    static let indigo = Color(red: 0.18, green: 0.22, blue: 0.42)
    static let line = Color(.separator).opacity(0.25)
}

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 14) {
            ProgressView()
                .controlSize(.large)

            Text("Loading exercises")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.background)
    }
}

struct ErrorStateView: View {
    let message: String
    let retry: () -> Void

    var body: some View {
        ContentUnavailableView {
            Label("Exercises could not load", systemImage: "exclamationmark.triangle")
        } description: {
            Text(message)
        } actions: {
            Button("Try Again", action: retry)
                .buttonStyle(.borderedProminent)
        }
        .background(AppTheme.background)
    }
}

struct RemovableChip: View {
    let title: String
    let onRemove: () -> Void

    var body: some View {
        Button(action: onRemove) {
            HStack(spacing: 6) {
                Text(title)
                    .lineLimit(1)
                Image(systemName: "xmark.circle.fill")
                    .font(.caption)
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(.orange)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(Color.orange.opacity(0.12), in: Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Remove \(title) filter")
    }
}

extension View {
    func sectionCard() -> some View {
        padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppTheme.card, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(AppTheme.line)
            }
            .shadow(color: .black.opacity(0.04), radius: 12, x: 0, y: 5)
    }
}
