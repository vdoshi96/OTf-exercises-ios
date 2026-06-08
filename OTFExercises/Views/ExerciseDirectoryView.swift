import SwiftUI

enum ExerciseLoadState: Equatable {
    case loading
    case loaded([Exercise])
    case failed(String)
}

struct ExerciseDirectoryView: View {
    let repository: ExerciseRepository

    @State private var loadState: ExerciseLoadState = .loading
    @State private var searchText = ""
    @State private var filters = ExerciseFilterState()
    @State private var showingFilters = false

    var body: some View {
        NavigationStack {
            Group {
                switch loadState {
                case .loading:
                    LoadingView()
                case .failed(let message):
                    ErrorStateView(message: message) {
                        Task { await loadExercises() }
                    }
                case .loaded(let exercises):
                    directoryContent(for: exercises)
                }
            }
            .navigationTitle("OTF Exercises")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Exercise.self) { exercise in
                ExerciseDetailView(exercise: exercise)
            }
        }
        .tint(AppTheme.orange)
        .task {
            await loadExercises()
        }
    }

    @ViewBuilder
    private func directoryContent(for exercises: [Exercise]) -> some View {
        let options = ExerciseSearchService.makeFilterOptions(from: exercises)
        let results = ExerciseSearchService.results(in: exercises, query: searchText, filters: filters)

        ScrollView {
            LazyVStack(spacing: 16) {
                DirectorySearchField(
                    searchText: $searchText,
                    activeFilterCount: filters.activeCount
                ) {
                    showingFilters = true
                }

                if filters.isActive {
                    ActiveFiltersBar(filters: $filters, creators: options.creators)
                }

                HStack {
                    Text("Showing \(results.count.formatted()) of \(exercises.count.formatted())")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(.horizontal, 20)

                if results.isEmpty {
                    ContentUnavailableView(
                        "No exercises found",
                        systemImage: "magnifyingglass",
                        description: Text("Try a different search or clear a filter.")
                    )
                    .padding(.top, 48)
                    .accessibilityIdentifier("emptyResults")
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(results) { exercise in
                            NavigationLink(value: exercise) {
                                ExerciseCardView(exercise: exercise)
                            }
                            .buttonStyle(.plain)
                            .accessibilityIdentifier("exerciseCard.\(exercise.id)")
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            }
            .padding(.top, 18)
        }
        .background(AppTheme.background)
        .sheet(isPresented: $showingFilters) {
            FilterSheetView(filters: $filters, options: options)
        }
    }

    private func loadExercises() async {
        loadState = .loading

        do {
            let exercises = try await repository.loadExercises()
            loadState = .loaded(exercises)
        } catch {
            loadState = .failed(error.localizedDescription)
        }
    }
}

private struct DirectorySearchField: View {
    @Binding var searchText: String
    let activeFilterCount: Int
    let onFilters: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(AppTheme.orange)

                TextField("Search exercises, muscles, equipment", text: $searchText)
                    .font(.body.weight(.semibold))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .submitLabel(.search)
                    .accessibilityIdentifier("directorySearchField")

                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Clear search")
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 60)
            .background(AppTheme.card, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .strokeBorder(AppTheme.orange.opacity(0.72), lineWidth: 1.5)
            }
            .shadow(color: AppTheme.orange.opacity(0.14), radius: 12, x: 0, y: 6)

            Button(action: onFilters) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: activeFilterCount == 0 ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
                        .font(.title2.weight(.semibold))
                        .frame(width: 56, height: 60)
                        .foregroundStyle(.white)

                    if activeFilterCount > 0 {
                        Text("\(activeFilterCount)")
                            .font(.caption2.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(minWidth: 18, minHeight: 18)
                            .background(AppTheme.teal, in: Capsule())
                            .offset(x: 2, y: -2)
                    }
                }
            }
            .background(AppTheme.orange, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .strokeBorder(AppTheme.orange.opacity(0.45), lineWidth: 1)
            }
            .shadow(color: AppTheme.orange.opacity(0.16), radius: 12, x: 0, y: 6)
            .accessibilityIdentifier("filtersButton")
            .accessibilityLabel(activeFilterCount == 0 ? "Filters" : "\(activeFilterCount) active filters")
        }
        .padding(.horizontal, 16)
    }
}

private struct ActiveFiltersBar: View {
    @Binding var filters: ExerciseFilterState
    let creators: [Creator]

    private var creatorByID: [String: Creator] {
        Dictionary(uniqueKeysWithValues: creators.map { ($0.id, $0) })
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                if let category = filters.category {
                    RemovableChip(title: category.displayName) {
                        filters.category = nil
                    }
                }

                if let muscleGroup = filters.muscleGroup {
                    RemovableChip(title: muscleGroup.titleCasedFilterLabel) {
                        filters.muscleGroup = nil
                    }
                }

                if let equipment = filters.equipment {
                    RemovableChip(title: equipment.titleCasedFilterLabel) {
                        filters.equipment = nil
                    }
                }

                if let platform = filters.platform {
                    RemovableChip(title: platform.displayName) {
                        filters.platform = nil
                    }
                }

                ForEach(Array(filters.creatorIDs).sorted(), id: \.self) { creatorID in
                    RemovableChip(title: creatorByID[creatorID]?.displayName ?? creatorID) {
                        filters.creatorIDs.remove(creatorID)
                    }
                }

                Button("Clear All") {
                    filters.clear()
                }
                .font(.caption.weight(.bold))
                .buttonStyle(.bordered)
            }
            .padding(.horizontal)
        }
    }
}
