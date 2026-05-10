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

    func testSocialURLsAreLimitedToExpectedHTTPSHosts() {
        let instagramCreator = Creator(
            id: "creator",
            displayName: "Creator",
            handle: "creator",
            profileURL: "https://www.instagram.com/creator/"
        )
        XCTAssertEqual(instagramCreator.url?.host, "www.instagram.com")

        let unsafeCreator = Creator(
            id: "unsafe",
            displayName: "Unsafe",
            handle: "unsafe",
            profileURL: "itms-services://?action=download-manifest&url=https://example.com/app.plist"
        )
        XCTAssertNil(unsafeCreator.url)

        let instagramVideo = makeVideo(url: "https://www.instagram.com/reel/example/", source: .instagram)
        XCTAssertEqual(instagramVideo.videoURL?.host, "www.instagram.com")

        let tiktokVideo = makeVideo(url: "https://www.tiktok.com/@creator/video/123", source: .tiktok)
        XCTAssertEqual(tiktokVideo.videoURL?.host, "www.tiktok.com")

        XCTAssertNil(makeVideo(url: "http://www.instagram.com/reel/example/", source: .instagram).videoURL)
        XCTAssertNil(makeVideo(url: "https://www.tiktok.com/@creator/video/123", source: .instagram).videoURL)
        XCTAssertNil(makeVideo(url: "javascript:alert(1)", source: .instagram).videoURL)
        XCTAssertNil(makeVideo(url: "https://instagram.com.evil.example/reel/example/", source: .instagram).videoURL)
    }

    private func loadBundledExercises() throws -> [Exercise] {
        let bundle = Bundle(for: Self.self)
        let url = try XCTUnwrap(bundle.url(forResource: "exercises", withExtension: "json"))
        let data = try Data(contentsOf: url)
        return try ExerciseRepository.decodeExercises(from: data)
    }

    private func makeVideo(url: String, source: VideoSource) -> ExerciseVideo {
        ExerciseVideo(
            id: UUID().uuidString,
            url: url,
            source: source,
            thumbnail: "/thumbs/example.jpg",
            description: "Example",
            creator: Creator(
                id: "creator",
                displayName: "Creator",
                handle: "creator",
                profileURL: "https://www.instagram.com/creator/"
            )
        )
    }
}
