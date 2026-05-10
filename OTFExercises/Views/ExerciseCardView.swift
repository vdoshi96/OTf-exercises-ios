import SwiftUI

struct ExerciseCardView: View {
    let exercise: Exercise

    var body: some View {
        HStack(spacing: 14) {
            ThumbnailView(
                thumbnail: exercise.primaryThumbnail,
                category: exercise.category,
                title: exercise.exerciseName
            )
            .frame(width: 112, height: 92)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top, spacing: 8) {
                    Text(exercise.exerciseName)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    Spacer(minLength: 4)

                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.tertiary)
                }

                HStack(spacing: 6) {
                    CategoryBadge(category: exercise.category)
                    VideoCountBadge(count: exercise.videos.count)
                }

                Text(exercise.muscleGroups.prefix(3).map(\.titleCasedFilterLabel).joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                Label(exercise.equipment.isEmpty ? "Bodyweight" : exercise.equipment.prefix(2).map(\.titleCasedFilterLabel).joined(separator: ", "), systemImage: "dumbbell")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color(.separator).opacity(0.35))
        }
        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(exercise.exerciseName), \(exercise.category.displayName), \(exercise.videos.count) videos")
    }
}

struct CategoryBadge: View {
    let category: ExerciseCategory

    var body: some View {
        Text(category.displayName)
            .font(.caption2.weight(.bold))
            .textCase(.uppercase)
            .foregroundStyle(category.tint)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(category.tint.opacity(0.12), in: Capsule())
    }
}

struct VideoCountBadge: View {
    let count: Int

    var body: some View {
        Label("\(count)", systemImage: "play.fill")
            .font(.caption2.weight(.bold))
            .foregroundStyle(.secondary)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(Color(.secondarySystemGroupedBackground), in: Capsule())
            .accessibilityLabel("\(count) videos")
    }
}

