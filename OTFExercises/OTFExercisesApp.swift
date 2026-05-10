import SwiftUI

@main
struct OTFExercisesApp: App {
    private let repository = ExerciseRepository()

    var body: some Scene {
        WindowGroup {
            ExerciseDirectoryView(repository: repository)
        }
    }
}

