import SwiftUI

struct ExerciseCardView: View {
    let exercise: Exercise

    var body: some View {
        HStack(spacing: 14) {
            ZStack(alignment: .bottomLeading) {
                ThumbnailView(
                    thumbnail: exercise.primaryThumbnail,
                    category: exercise.category,
                    title: exercise.exerciseName
                )
                .frame(width: 112, height: 96)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

                VideoCountBadge(count: exercise.videos.count)
                    .padding(7)
            }

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
                }

                Text(exercise.muscleGroups.prefix(3).map(\.titleCasedFilterLabel).joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                HStack(spacing: 10) {
                    Label(exercise.equipment.isEmpty ? "Bodyweight" : exercise.equipment.prefix(2).map(\.titleCasedFilterLabel).joined(separator: ", "), systemImage: "dumbbell")
                        .lineLimit(1)

                    Label(exercise.creatorSummary, systemImage: "person.crop.circle")
                        .lineLimit(1)
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.card, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(AppTheme.line)
        }
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
        .contentShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
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
            .background(category.tint.opacity(0.14), in: Capsule())
    }
}

struct VideoCountBadge: View {
    let count: Int

    var body: some View {
        Label("\(count)", systemImage: "play.fill")
            .font(.caption2.weight(.bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(.black.opacity(0.58), in: Capsule())
            .accessibilityLabel("\(count) videos")
    }
}
