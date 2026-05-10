import XCTest
@testable import OTFExercises

final class ExerciseDataTests: XCTestCase {
    func testBundledExerciseDataDecodes() throws {
        let exercises = try loadBundledExercises()
        let videoCount = exercises.reduce(0) { $0 + $1.videos.count }

        XCTAssertEqual(exercises.count, 1_220)
        XCTAssertEqual(videoCount, 1_953)
        XCTAssertTrue(exercises.contains { $0.id == "goblet-squat" || $0.exerciseName.localizedCaseInsensitiveContains("squat") })
    }

    func testFilterOptionsMatchSourceDimensions() throws {
        let exercises = try loadBundledExercises()
        let options = ExerciseSearchService.makeFilterOptions(from: exercises)

        XCTAssertEqual(Set(options.categories), Set(ExerciseCategory.allCases))
        XCTAssertEqual(options.platforms, [.instagram, .tiktok])
        XCTAssertEqual(options.creators.map(\.id), ["trainingtall", "coachingotf"])
        XCTAssertTrue(options.muscleGroups.contains("shoulders"))
        XCTAssertTrue(options.equipment.contains("dumbbell"))
    }

    private func loadBundledExercises() throws -> [Exercise] {
        let bundle = Bundle(for: Self.self)
        let url = try XCTUnwrap(bundle.url(forResource: "exercises", withExtension: "json"))
        let data = try Data(contentsOf: url)
        return try ExerciseRepository.decodeExercises(from: data)
    }
}
