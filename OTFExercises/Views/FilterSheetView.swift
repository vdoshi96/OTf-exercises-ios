import SwiftUI

struct FilterSheetView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var filters: ExerciseFilterState
    let options: ExerciseFilterOptions

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    FilterGroup(title: "Category") {
                        ChipGrid {
                            ForEach(options.categories) { category in
                                ChoiceChip(
                                    title: category.displayName,
                                    isSelected: filters.category == category
                                ) {
                                    filters.category = filters.category == category ? nil : category
                                }
                            }
                        }
                    }

                    FilterGroup(title: "Muscle Group") {
                        ChipGrid {
                            ForEach(options.muscleGroups, id: \.self) { muscleGroup in
                                ChoiceChip(
                                    title: muscleGroup.titleCasedFilterLabel,
                                    isSelected: filters.muscleGroup == muscleGroup
                                ) {
                                    filters.muscleGroup = filters.muscleGroup == muscleGroup ? nil : muscleGroup
                                }
                            }
                        }
                    }

                    FilterGroup(title: "Equipment") {
                        ChipGrid {
                            ForEach(options.equipment, id: \.self) { equipment in
                                ChoiceChip(
                                    title: equipment.titleCasedFilterLabel,
                                    isSelected: filters.equipment == equipment
                                ) {
                                    filters.equipment = filters.equipment == equipment ? nil : equipment
                                }
                            }
                        }
                    }

                    FilterGroup(title: "Platform") {
                        ChipGrid {
                            ForEach(options.platforms) { platform in
                                ChoiceChip(
                                    title: platform.displayName,
                                    isSelected: filters.platform == platform
                                ) {
                                    filters.platform = filters.platform == platform ? nil : platform
                                }
                            }
                        }
                    }

                    FilterGroup(title: "Creator") {
                        ChipGrid {
                            ForEach(options.creators) { creator in
                                ChoiceChip(
                                    title: creator.displayName,
                                    isSelected: filters.creatorIDs.contains(creator.id)
                                ) {
                                    if filters.creatorIDs.contains(creator.id) {
                                        filters.creatorIDs.remove(creator.id)
                                    } else {
                                        filters.creatorIDs.insert(creator.id)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .background(AppTheme.background)
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Clear") {
                        filters.clear()
                    }
                    .disabled(!filters.isActive)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

private struct FilterGroup<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)

            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct ChipGrid<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 112), spacing: 8)], alignment: .leading, spacing: 8) {
            content
        }
    }
}

struct ChoiceChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.caption.weight(.bold))
                }

                Text(title)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .minimumScaleFactor(0.85)
            }
            .font(.subheadline.weight(.semibold))
            .frame(maxWidth: .infinity, minHeight: 40, alignment: .leading)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .foregroundStyle(isSelected ? Color.white : Color.primary)
            .background(isSelected ? AppTheme.orange : Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .strokeBorder(isSelected ? AppTheme.orange : Color(.separator).opacity(0.35))
            }
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
