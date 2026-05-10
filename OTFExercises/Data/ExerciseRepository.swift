import Foundation

enum ExerciseDataError: LocalizedError, Equatable {
    case missingResource(String)
    case decodingFailed(String)

    var errorDescription: String? {
        switch self {
        case .missingResource(let name):
            "Could not find \(name) in the app bundle."
        case .decodingFailed(let message):
            "Could not read exercise data. \(message)"
        }
    }
}

struct ExerciseRepository {
    var bundle: Bundle = .main
    var resourceName: String = "exercises"

    func loadExercises() async throws -> [Exercise] {
        let bundle = bundle
        let resourceName = resourceName

        return try await Task.detached(priority: .userInitiated) {
            guard let url = bundle.url(forResource: resourceName, withExtension: "json") else {
                throw ExerciseDataError.missingResource("\(resourceName).json")
            }

            do {
                let data = try Data(contentsOf: url)
                return try Self.decodeExercises(from: data)
            } catch let error as ExerciseDataError {
                throw error
            } catch {
                throw ExerciseDataError.decodingFailed(error.localizedDescription)
            }
        }.value
    }

    static func decodeExercises(from data: Data) throws -> [Exercise] {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Exercise].self, from: data)
        } catch {
            throw ExerciseDataError.decodingFailed(error.localizedDescription)
        }
    }
}

enum ThumbnailResolver {
    static func localURL(for thumbnail: String?, bundle: Bundle = .main) -> URL? {
        guard let thumbnail, thumbnail.hasPrefix("/thumbs/") else {
            return nil
        }

        let filename = String(thumbnail.dropFirst("/thumbs/".count))
        let nsFilename = filename as NSString
        let name = nsFilename.deletingPathExtension
        let ext = nsFilename.pathExtension.isEmpty ? "jpg" : nsFilename.pathExtension

        return bundle.url(forResource: name, withExtension: ext, subdirectory: "thumbs")
    }
}

