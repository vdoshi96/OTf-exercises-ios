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

