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

enum AppInfo {
    static let disclaimer = "Unofficial fan directory — not affiliated with Orangetheory Fitness. Videos belong to their creators."
    static let webDirectoryURL = URL(string: "https://o-tf-exercises.vercel.app")!
}

struct DisclaimerFooter: View {
    var body: some View {
        Text(AppInfo.disclaimer)
            .font(.footnote)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .accessibilityIdentifier("disclaimerFooter")
    }
}

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss

    let exerciseCount: Int
    let videoCount: Int
    let creatorCount: Int

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("OTF Exercises")
                            .font(.largeTitle.bold())

                        Text("Look up a floor exercise before class. \(exerciseCount.formatted()) exercises and \(videoCount.formatted()) demo videos, searchable offline.")
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    HStack(spacing: 10) {
                        AboutStat(value: exerciseCount, label: "Exercises")
                        AboutStat(value: videoCount, label: "Demos")
                        AboutStat(value: creatorCount, label: "Creators")
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Label("Unofficial", systemImage: "info.circle.fill")
                            .font(.headline)
                            .foregroundStyle(AppTheme.orange)

                        Text(AppInfo.disclaimer)
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                            .accessibilityIdentifier("aboutDisclaimer")

                        Text("Orangetheory, OTF, and related marks belong to their respective owners. Each demo opens the original post on Instagram or TikTok.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .sectionCard()

                    Link(destination: AppInfo.webDirectoryURL) {
                        Label("Open the web directory", systemImage: "safari")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .tint(AppTheme.orange)
                }
                .padding(20)
            }
            .background(AppTheme.background)
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.large])
    }
}

private struct AboutStat: View {
    let value: Int
    let label: String

    var body: some View {
        VStack(spacing: 2) {
            Text(value.formatted())
                .font(.title3.bold().monospacedDigit())
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(AppTheme.card, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .strokeBorder(AppTheme.line)
        }
    }
}
