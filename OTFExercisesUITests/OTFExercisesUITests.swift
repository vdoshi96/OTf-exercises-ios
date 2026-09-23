import XCTest

final class OTFExercisesUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testDirectoryAndSearchFlow() throws {
        XCTAssertTrue(app.staticTexts["Showing 778 of 778"].waitForExistence(timeout: 8))
        XCTAssertTrue(app.buttons["exerciseCard.alternating-1-12-lateral-lunge"].exists)

        let searchField = app.textFields["directorySearchField"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 4))
        searchField.tap()
        searchField.typeText("goblet squat")
        XCTAssertTrue(app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] %@", "Showing")).firstMatch.waitForExistence(timeout: 4))
        XCTAssertTrue(app.buttons.matching(NSPredicate(format: "label CONTAINS[c] %@", "Squat")).firstMatch.waitForExistence(timeout: 4))
    }

    func testFilterDetailAndMediaFlow() throws {
        XCTAssertTrue(app.staticTexts["Showing 778 of 778"].waitForExistence(timeout: 8))
        app.buttons["filtersButton"].tap()
        XCTAssertTrue(app.navigationBars["Filters"].waitForExistence(timeout: 4))
        app.buttons["Upper Body"].tap()
        app.buttons["Done"].tap()
        XCTAssertTrue(app.buttons.matching(NSPredicate(format: "label CONTAINS[c] %@", "Upper Body")).firstMatch.waitForExistence(timeout: 4))

        app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "exerciseCard.")).firstMatch.tap()
        XCTAssertTrue(app.staticTexts["Details"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["Video Library"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "watchVideo.")).firstMatch.exists)

        app.navigationBars.buttons.element(boundBy: 0).tap()
        XCTAssertTrue(app.textFields["directorySearchField"].waitForExistence(timeout: 4))
    }

    func testAboutSheetShowsDisclaimer() throws {
        XCTAssertTrue(app.staticTexts["Showing 778 of 778"].waitForExistence(timeout: 8))
        app.buttons["aboutButton"].tap()
        let disclaimer = app.staticTexts["aboutDisclaimer"]
        XCTAssertTrue(disclaimer.waitForExistence(timeout: 4))
        XCTAssertTrue(disclaimer.label.contains("not affiliated with Orangetheory Fitness"))
        app.buttons["Done"].tap()
        XCTAssertTrue(app.textFields["directorySearchField"].waitForExistence(timeout: 4))
    }

    /// Paced walkthrough used to record the portfolio screen capture. Skipped
    /// in normal runs; enable with `TEST_RUNNER_OTF_WALKTHROUGH=1 xcodebuild test ...`.
    func testRecordedWalkthrough() throws {
        try XCTSkipUnless(ProcessInfo.processInfo.environment["OTF_WALKTHROUGH"] == "1")

        XCTAssertTrue(app.staticTexts["Showing 778 of 778"].waitForExistence(timeout: 8))
        sleep(2)
        app.swipeUp(velocity: .slow)
        sleep(1)
        app.swipeDown(velocity: .fast)
        sleep(1)

        let searchField = app.textFields["directorySearchField"]
        searchField.tap()
        for character in "goblet squat" {
            searchField.typeText(String(character))
            usleep(140_000)
        }
        sleep(2)

        let card = app.buttons["exerciseCard.goblet-squat"]
        XCTAssertTrue(card.waitForExistence(timeout: 4))
        card.tap()
        XCTAssertTrue(app.staticTexts["Details"].waitForExistence(timeout: 4))
        sleep(2)
        app.swipeUp(velocity: .slow)
        sleep(2)
        app.swipeUp(velocity: .slow)
        sleep(2)
        app.navigationBars.buttons.element(boundBy: 0).tap()
        sleep(2)
    }
}
