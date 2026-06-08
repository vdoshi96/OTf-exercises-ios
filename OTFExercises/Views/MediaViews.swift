import SwiftUI
import UIKit

struct ThumbnailView: View {
    let thumbnail: String?
    let category: ExerciseCategory
    let title: String

    var body: some View {
        if let url = ThumbnailResolver.localURL(for: thumbnail),
           let image = UIImage(contentsOfFile: url.path) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .overlay(alignment: .bottomLeading) {
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.55)],
                        startPoint: .center,
                        endPoint: .bottom
                    )
                }
                .accessibilityLabel("Thumbnail for \(title)")
        } else {
            PlaceholderThumbnail(category: category, title: title)
        }
    }
}

private struct PlaceholderThumbnail: View {
    let category: ExerciseCategory
    let title: String

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [AppTheme.indigo, category.tint.opacity(0.65), AppTheme.teal.opacity(0.75)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(spacing: 8) {
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.largeTitle.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.9))

                Text(category.displayName)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white.opacity(0.92))
                    .textCase(.uppercase)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
            .padding()
        }
        .accessibilityLabel("No local thumbnail for \(title)")
    }
}

struct VideoPreviewCard: View {
    let video: ExerciseVideo
    let index: Int
    let total: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .bottomLeading) {
                ThumbnailView(
                    thumbnail: video.thumbnail,
                    category: .other,
                    title: video.description
                )
                .frame(maxWidth: .infinity)
                .aspectRatio(16 / 9, contentMode: .fit)

                LinearGradient(
                    colors: [.clear, .black.opacity(0.62)],
                    startPoint: .center,
                    endPoint: .bottom
                )

                Image(systemName: "play.circle.fill")
                    .font(.system(size: 54))
                    .foregroundStyle(.white, .black.opacity(0.45))
                    .shadow(radius: 6)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

                HStack {
                    SourceBadge(source: video.source)

                    Spacer()

                    if total > 1 {
                        Text("\(index + 1) of \(total)")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 9)
                            .padding(.vertical, 6)
                            .background(.black.opacity(0.48), in: Capsule())
                    }
                }
                .padding(12)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            HStack(alignment: .top, spacing: 10) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(video.creator.displayName)
                        .font(.subheadline.weight(.semibold))

                    Text(video.creator.formattedHandle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }

            if let description = video.firstDescriptionLine {
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            HStack(spacing: 10) {
                if let url = video.videoURL {
                    Link(destination: url) {
                        Label("Watch on \(video.source.displayName)", systemImage: "arrow.up.right.square")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(AppTheme.orange)
                    .accessibilityIdentifier("watchVideo.\(video.id)")
                }

                if let creatorURL = video.creator.url {
                    Link(destination: creatorURL) {
                        Image(systemName: "person.crop.circle")
                            .frame(width: 42, height: 34)
                    }
                    .buttonStyle(.bordered)
                    .accessibilityLabel("Open \(video.creator.displayName)'s profile")
                }
            }
        }
        .padding(12)
        .background(AppTheme.card, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(AppTheme.line)
        }
        .shadow(color: .black.opacity(0.04), radius: 12, x: 0, y: 5)
    }
}

struct SourceBadge: View {
    let source: VideoSource

    var body: some View {
        Label(source.displayName, systemImage: source.systemImage)
            .font(.caption.weight(.bold))
            .foregroundStyle(source == .instagram ? .pink : .primary)
            .padding(.horizontal, 9)
            .padding(.vertical, 6)
            .background(Color(.secondarySystemGroupedBackground), in: Capsule())
    }
}
