import XCTest
@testable import OTFExercises

final class ExerciseSearchTests: XCTestCase {
    func testSearchFindsExercisesByNameAndMetadata() throws {
        let exercises = try loadBundledExercises()

        let squatResults = ExerciseSearchService.search(exercises, query: "goblet squat")
        XCTAssertFalse(squatResults.isEmpty)
        XCTAssertTrue(squatResults.prefix(10).contains { $0.exerciseName.localizedCaseInsensitiveContains("squat") })

        let creatorResults = ExerciseSearchService.search(exercises, query: "trainingtall")
        XCTAssertFalse(creatorResults.isEmpty)
        XCTAssertTrue(creatorResults.allSatisfy { exercise in
            exercise.uniqueCreators.contains { $0.id == "trainingtall" }
        })
    }

    func testFiltersCanBeCombined() throws {
        let exercises = try loadBundledExercises()
        var filters = ExerciseFilterState()
        filters.category = .upperBody
        filters.equipment = "dumbbell"
        filters.platform = .instagram

        let results = ExerciseSearchService.results(in: exercises, query: "", filters: filters)

        XCTAssertFalse(results.isEmpty)
        XCTAssertTrue(results.allSatisfy { $0.category == .upperBody })
        XCTAssertTrue(results.allSatisfy { $0.equipment.contains("dumbbell") })
        XCTAssertTrue(results.allSatisfy { $0.videos.contains { $0.source == .instagram } })
    }

    func testDefaultBrowseOrderIsAlphabeticalWithDigitLedTitlesLast() throws {
        let exercises = try loadBundledExercises()
        let titles = ExerciseSearchService.results(in: exercises, query: "", filters: ExerciseFilterState())
            .map(\.exerciseName)

        XCTAssertEqual(titles.count, exercises.count)
        XCTAssertEqual(titles.first, "Alternating 1-1/2 Lateral Lunge")
        let firstNumeric = try XCTUnwrap(titles.firstIndex { $0.first?.isNumber == true })
        XCTAssertTrue(titles[firstNumeric...].allSatisfy { $0.first?.isNumber == true })
        XCTAssertEqual(titles.last, "1000m Row Benchmark")

        let hangClean = try XCTUnwrap(titles.firstIndex { $0.hasPrefix("(Hang Power)") })
        XCTAssertTrue(titles[hangClean - 1].uppercased().hasPrefix("H"))

        XCTAssertTrue(BrowseSortKey(title: "2 Point Row").precedes(BrowseSortKey(title: "10 Stroke Power Row")))
        XCTAssertTrue(BrowseSortKey(title: "Zercher Squat").precedes(BrowseSortKey(title: "1/2 Kneeling Chop")))
    }

    func testEmptyStateSearchReturnsNoResults() throws {
        let exercises = try loadBundledExercises()
        let results = ExerciseSearchService.results(in: exercises, query: "zzzzzzzz impossible movement", filters: ExerciseFilterState())

        XCTAssertTrue(results.isEmpty)
    }

    private func loadBundledExercises() throws -> [Exercise] {
        let bundle = Bundle(for: Self.self)
        let url = try XCTUnwrap(bundle.url(forResource: "exercises", withExtension: "json"))
        let data = try Data(contentsOf: url)
        return try ExerciseRepository.decodeExercises(from: data)
    }
}

