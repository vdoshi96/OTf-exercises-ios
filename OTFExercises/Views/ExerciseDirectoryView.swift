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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingFilters = true
                    } label: {
                        Label(filters.activeCount == 0 ? "Filters" : "Filters \(filters.activeCount)", systemImage: "line.3.horizontal.decrease.circle")
                    }
                    .accessibilityIdentifier("filtersButton")
                }
            }
        }
        .tint(.orange)
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
                DirectoryHeader(exercises: exercises, creatorCount: options.creators.count)

                if filters.isActive {
                    ActiveFiltersBar(filters: $filters, creators: options.creators)
                }

                HStack {
                    Text("Showing \(results.count.formatted()) of \(exercises.count.formatted())")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding(.horizontal)

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
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                }
            }
            .padding(.top, 12)
        }
        .background(Color(.systemGroupedBackground))
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search exercises, muscles, equipment, creators"
        )
        .navigationDestination(for: Exercise.self) { exercise in
            ExerciseDetailView(exercise: exercise)
        }
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

private struct DirectoryHeader: View {
    let exercises: [Exercise]
    let creatorCount: Int

    private var videoCount: Int {
        exercises.reduce(0) { $0 + $1.videos.count }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Find the movement before class starts.")
                    .font(.largeTitle.bold())
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityAddTraits(.isHeader)

                Text("Search OTF exercise demos by muscle group, equipment, category, platform, and creator.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            HStack(spacing: 10) {
                StatTile(value: exercises.count, label: "Exercises", systemImage: "figure.strengthtraining.traditional")
                StatTile(value: videoCount, label: "Videos", systemImage: "play.rectangle")
                StatTile(value: creatorCount, label: "Creators", systemImage: "person.crop.circle")
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.background, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .padding(.horizontal)
    }
}

private struct StatTile: View {
    let value: Int
    let label: String
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: systemImage)
                .foregroundStyle(.orange)
                .font(.headline)

            Text(value.formatted())
                .font(.title3.bold())
                .minimumScaleFactor(0.75)
                .lineLimit(1)

            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
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

