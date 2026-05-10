import Foundation

struct ExerciseFilterState: Equatable {
    var category: ExerciseCategory?
    var muscleGroup: String?
    var equipment: String?
    var platform: VideoSource?
    var creatorIDs: Set<String> = []

    var isActive: Bool {
        category != nil ||
            muscleGroup != nil ||
            equipment != nil ||
            platform != nil ||
            !creatorIDs.isEmpty
    }

    var activeCount: Int {
        [category?.id, muscleGroup, equipment, platform?.id].compactMap(\.self).count + creatorIDs.count
    }

    mutating func clear() {
        category = nil
        muscleGroup = nil
        equipment = nil
        platform = nil
        creatorIDs.removeAll()
    }
}

struct ExerciseFilterOptions: Equatable {
    let categories: [ExerciseCategory]
    let muscleGroups: [String]
    let equipment: [String]
    let platforms: [VideoSource]
    let creators: [Creator]
}

enum ExerciseSearchService {
    static func makeFilterOptions(from exercises: [Exercise]) -> ExerciseFilterOptions {
        let categories = Set(exercises.map(\.category))
        let muscleGroups = Set(exercises.flatMap(\.muscleGroups))
        let equipment = Set(exercises.flatMap(\.equipment))
        let platforms = Set(exercises.flatMap { $0.videos.map(\.source) })

        var creatorByID: [String: Creator] = [:]
        exercises
            .flatMap(\.uniqueCreators)
            .forEach { creatorByID[$0.id] = $0 }

        return ExerciseFilterOptions(
            categories: categories.sorted { $0.displayName < $1.displayName },
            muscleGroups: muscleGroups.sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending },
            equipment: equipment.sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending },
            platforms: platforms.sorted { $0.displayName < $1.displayName },
            creators: creatorByID.values.sorted {
                $0.displayName.localizedCaseInsensitiveCompare($1.displayName) == .orderedAscending
            }
        )
    }

    static func results(
        in exercises: [Exercise],
        query: String,
        filters: ExerciseFilterState
    ) -> [Exercise] {
        let searched = search(exercises, query: query)
        return filter(searched, filters: filters)
    }

    static func search(_ exercises: [Exercise], query: String) -> [Exercise] {
        let normalizedQuery = query.searchNormalized

        guard !normalizedQuery.isEmpty else {
            return exercises
        }

        return exercises
            .compactMap { exercise -> (exercise: Exercise, score: Int)? in
                guard let score = score(exercise, for: normalizedQuery) else {
                    return nil
                }

                return (exercise, score)
            }
            .sorted {
                if $0.score == $1.score {
                    return $0.exercise.exerciseName.localizedCaseInsensitiveCompare($1.exercise.exerciseName) == .orderedAscending
                }

                return $0.score > $1.score
            }
            .map(\.exercise)
    }

    static func filter(_ exercises: [Exercise], filters: ExerciseFilterState) -> [Exercise] {
        exercises.filter { exercise in
            if let category = filters.category, exercise.category != category {
                return false
            }

            if let muscleGroup = filters.muscleGroup, !exercise.muscleGroups.contains(muscleGroup) {
                return false
            }

            if let equipment = filters.equipment, !exercise.equipment.contains(equipment) {
                return false
            }

            if let platform = filters.platform, !exercise.videos.contains(where: { $0.source == platform }) {
                return false
            }

            if !filters.creatorIDs.isEmpty {
                let exerciseCreatorIDs = Set(exercise.videos.map(\.creator.id))
                if filters.creatorIDs.isDisjoint(with: exerciseCreatorIDs) {
                    return false
                }
            }

            return true
        }
    }

    private static func score(_ exercise: Exercise, for query: String) -> Int? {
        var score = 0
        score += weightedScore(query: query, values: [exercise.exerciseName], weight: 220)
        score += weightedScore(query: query, values: exercise.muscleGroups, weight: 150)
        score += weightedScore(query: query, values: exercise.equipment, weight: 110)
        score += weightedScore(query: query, values: exercise.uniqueCreators.flatMap { [$0.displayName, $0.handle] }, weight: 100)
        score += weightedScore(query: query, values: exercise.coachingCues, weight: 55)

        let combined = [
            exercise.exerciseName,
            exercise.muscleGroups.joined(separator: " "),
            exercise.equipment.joined(separator: " "),
            exercise.uniqueCreators.map { "\($0.displayName) \($0.handle)" }.joined(separator: " "),
            exercise.coachingCues.joined(separator: " ")
        ]
        .joined(separator: " ")
        .searchNormalized

        let terms = query.split(separator: " ").map(String.init)
        if !terms.isEmpty, terms.allSatisfy({ combined.contains($0) }) {
            score += 40
        }

        return score > 0 ? score : nil
    }

    private static func weightedScore(query: String, values: [String], weight: Int) -> Int {
        values.reduce(0) { partial, value in
            let normalized = value.searchNormalized

            if normalized == query {
                return partial + weight + 60
            }

            if normalized.contains(query) {
                return partial + weight
            }

            if query.contains(normalized), !normalized.isEmpty {
                return partial + weight / 2
            }

            if normalized.fuzzyMatches(query: query) {
                return partial + weight / 4
            }

            return partial
        }
    }
}

private extension String {
    var searchNormalized: String {
        folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            .lowercased()
            .replacingOccurrences(of: "[^a-z0-9]+", with: " ", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func fuzzyMatches(query: String) -> Bool {
        let queryTokens = query.split(separator: " ").map(String.init)
        let valueTokens = split(separator: " ").map(String.init)

        guard !queryTokens.isEmpty, !valueTokens.isEmpty else {
            return false
        }

        return queryTokens.allSatisfy { queryToken in
            guard queryToken.count >= 4 else {
                return false
            }

            return valueTokens.contains { valueToken in
                valueToken.editDistance(to: queryToken) <= queryToken.fuzzyTolerance
            }
        }
    }

    var fuzzyTolerance: Int {
        count >= 8 ? 2 : 1
    }

    func editDistance(to other: String) -> Int {
        let lhs = Array(self)
        let rhs = Array(other)

        guard !lhs.isEmpty else { return rhs.count }
        guard !rhs.isEmpty else { return lhs.count }

        var previous = Array(0...rhs.count)
        var current = Array(repeating: 0, count: rhs.count + 1)

        for lhsIndex in 1...lhs.count {
            current[0] = lhsIndex

            for rhsIndex in 1...rhs.count {
                if lhs[lhsIndex - 1] == rhs[rhsIndex - 1] {
                    current[rhsIndex] = previous[rhsIndex - 1]
                } else {
                    current[rhsIndex] = Swift.min(
                        previous[rhsIndex] + 1,
                        current[rhsIndex - 1] + 1,
                        previous[rhsIndex - 1] + 1
                    )
                }
            }

            previous = current
        }

        return previous[rhs.count]
    }
}
