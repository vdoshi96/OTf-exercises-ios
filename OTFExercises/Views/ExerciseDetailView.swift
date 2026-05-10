import SwiftUI

struct ExerciseDetailView: View {
    let exercise: Exercise

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                DetailHero(exercise: exercise)

                MetadataSection(exercise: exercise)

                if !exercise.coachingCues.isEmpty {
                    CoachingCuesSection(cues: exercise.coachingCues)
                }

                CreatorsSection(creators: exercise.uniqueCreators)

                VideosSection(videos: exercise.videos)
            }
            .padding(.horizontal)
            .padding(.vertical, 16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(exercise.exerciseName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct DetailHero: View {
    let exercise: Exercise

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ThumbnailView(
                thumbnail: exercise.primaryThumbnail,
                category: exercise.category,
                title: exercise.exerciseName
            )
            .frame(maxWidth: .infinity)
            .aspectRatio(16 / 10, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            VStack(alignment: .leading, spacing: 10) {
                CategoryBadge(category: exercise.category)

                Text(exercise.exerciseName)
                    .font(.largeTitle.bold())
                    .fixedSize(horizontal: false, vertical: true)

                Text("\(exercise.videos.count) video \(exercise.videos.count == 1 ? "demo" : "demos") with movement metadata and creator attribution.")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityIdentifier("exerciseDetailHero")
    }
}

private struct MetadataSection: View {
    let exercise: Exercise

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeading(title: "Details", systemImage: "list.bullet.rectangle")

            InfoGrid(items: [
                InfoItem(title: "Movement", value: exercise.movementType.displayName, systemImage: "figure.run"),
                InfoItem(title: "Muscle Groups", value: exercise.muscleGroups.map(\.titleCasedFilterLabel).joined(separator: ", "), systemImage: "figure.strengthtraining.traditional"),
                InfoItem(title: "Equipment", value: exercise.equipmentSummary.titleCasedFilterLabel, systemImage: "dumbbell"),
                InfoItem(title: "Creators", value: exercise.creatorSummary, systemImage: "person.crop.circle")
            ])
        }
        .sectionCard()
    }
}

private struct CoachingCuesSection: View {
    let cues: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeading(title: "Coaching Cues", systemImage: "checkmark.seal")

            VStack(alignment: .leading, spacing: 10) {
                ForEach(Array(cues.enumerated()), id: \.offset) { _, cue in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.teal)
                            .font(.subheadline)
                            .padding(.top, 2)

                        Text(cue)
                            .font(.body)
                            .foregroundStyle(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .sectionCard()
    }
}

private struct CreatorsSection: View {
    let creators: [Creator]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeading(title: "Creators", systemImage: "person.2")

            VStack(spacing: 10) {
                ForEach(creators) { creator in
                    if let url = creator.url {
                        Link(destination: url) {
                            CreatorRow(creator: creator)
                        }
                        .buttonStyle(.plain)
                    } else {
                        CreatorRow(creator: creator)
                    }
                }
            }
        }
        .sectionCard()
    }
}

private struct CreatorRow: View {
    let creator: Creator

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "person.crop.circle.fill")
                .font(.title2)
                .foregroundStyle(.orange)

            VStack(alignment: .leading, spacing: 2) {
                Text(creator.displayName)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)

                Text(creator.formattedHandle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "arrow.up.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .accessibilityLabel("Open creator \(creator.displayName)")
    }
}

private struct VideosSection: View {
    let videos: [ExerciseVideo]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeading(title: "Video Library", systemImage: "play.rectangle.on.rectangle")

            VStack(spacing: 14) {
                ForEach(Array(videos.enumerated()), id: \.element.id) { index, video in
                    VideoPreviewCard(video: video, index: index, total: videos.count)
                }
            }
        }
    }
}

private struct SectionHeading: View {
    let title: String
    let systemImage: String

    var body: some View {
        Label(title, systemImage: systemImage)
            .font(.title3.bold())
            .foregroundStyle(.primary)
            .accessibilityAddTraits(.isHeader)
    }
}

private struct InfoItem: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let systemImage: String
}

private struct InfoGrid: View {
    let items: [InfoItem]

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 10)], spacing: 10) {
            ForEach(items) { item in
                VStack(alignment: .leading, spacing: 8) {
                    Label(item.title, systemImage: item.systemImage)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)

                    Text(item.value)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(12)
                .frame(maxWidth: .infinity, minHeight: 86, alignment: .topLeading)
                .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
    }
}

