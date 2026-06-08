import XCTest

final class OTFExercisesUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testDirectoryAndSearchFlow() throws {
        XCTAssertTrue(app.staticTexts["Showing 1,231 of 1,231"].waitForExistence(timeout: 8))
        XCTAssertTrue(app.buttons["exerciseCard.hang-power-clean-options"].exists)

        app.searchFields.firstMatch.tap()
        app.searchFields.firstMatch.typeText("goblet squat")
        XCTAssertTrue(app.staticTexts.matching(NSPredicate(format: "label CONTAINS[c] %@", "Showing")).firstMatch.waitForExistence(timeout: 4))
        XCTAssertTrue(app.buttons.matching(NSPredicate(format: "label CONTAINS[c] %@", "Squat")).firstMatch.waitForExistence(timeout: 4))
    }

    func testFilterDetailAndMediaFlow() throws {
        XCTAssertTrue(app.staticTexts["Showing 1,231 of 1,231"].waitForExistence(timeout: 8))
        app.buttons["filtersButton"].tap()
        XCTAssertTrue(app.navigationBars["Filters"].waitForExistence(timeout: 4))
        app.buttons["Upper Body"].tap()
        app.buttons["Done"].tap()
        XCTAssertTrue(app.buttons.matching(NSPredicate(format: "label CONTAINS[c] %@", "Upper Body")).firstMatch.waitForExistence(timeout: 4))

        app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "exerciseCard.")).firstMatch.tap()
        XCTAssertTrue(app.staticTexts["Details"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.staticTexts["Video Library"].waitForExistence(timeout: 4))
        XCTAssertTrue(app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "watchVideo.")).firstMatch.exists)
    }
}
