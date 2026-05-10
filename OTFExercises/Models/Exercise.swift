import Foundation
import SwiftUI

private enum SocialURLPolicy {
    static func creatorProfileURL(from rawValue: String) -> URL? {
        url(from: rawValue, allowedHosts: [.instagram, .tiktok])
    }

    static func videoURL(from rawValue: String, source: VideoSource) -> URL? {
        switch source {
        case .instagram:
            url(from: rawValue, allowedHosts: [.instagram])
        case .tiktok:
            url(from: rawValue, allowedHosts: [.tiktok])
        }
    }

    private static func url(from rawValue: String, allowedHosts: Set<SocialHost>) -> URL? {
        let trimmed = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard var components = URLComponents(string: trimmed),
              components.scheme?.lowercased() == "https",
              components.user == nil,
              components.password == nil,
              let host = components.host?.lowercased()
        else {
            return nil
        }

        let normalizedHost = host.hasPrefix("www.") ? String(host.dropFirst(4)) : host
        guard let socialHost = SocialHost(rawValue: normalizedHost),
              allowedHosts.contains(socialHost)
        else {
            return nil
        }

        components.scheme = "https"
        components.host = host
        return components.url
    }

    private enum SocialHost: String {
        case instagram = "instagram.com"
        case tiktok = "tiktok.com"
    }
}

struct Creator: Codable, Hashable, Identifiable {
    let id: String
    let displayName: String
    let handle: String
    let profileURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case handle
        case profileURL = "profile_url"
    }

    var formattedHandle: String {
        handle.hasPrefix("@") ? handle : "@\(handle)"
    }

    var url: URL? {
        SocialURLPolicy.creatorProfileURL(from: profileURL)
    }
}

enum VideoSource: String, Codable, CaseIterable, Hashable, Identifiable {
    case instagram
    case tiktok

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .instagram: "Instagram"
        case .tiktok: "TikTok"
        }
    }

    var systemImage: String {
        switch self {
        case .instagram: "camera"
        case .tiktok: "music.note"
        }
    }
}

struct ExerciseVideo: Codable, Hashable, Identifiable {
    let id: String
    let url: String
    let source: VideoSource
    let thumbnail: String
    let description: String
    let creator: Creator

    var videoURL: URL? {
        SocialURLPolicy.videoURL(from: url, source: source)
    }

    var firstDescriptionLine: String? {
        let line = description
            .components(separatedBy: "#")
            .first?
            .components(separatedBy: .newlines)
            .first?
            .trimmingCharacters(in: .whitespacesAndNewlines)

        return line?.isEmpty == false ? line : nil
    }
}

enum ExerciseCategory: String, Codable, CaseIterable, Hashable, Identifiable {
    case upperBody = "upper_body"
    case lowerBody = "lower_body"
    case core
    case fullBody = "full_body"
    case cardio
    case mobility
    case other

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .upperBody: "Upper Body"
        case .lowerBody: "Lower Body"
        case .core: "Core"
        case .fullBody: "Full Body"
        case .cardio: "Cardio"
        case .mobility: "Mobility"
        case .other: "Other"
        }
    }

    var tint: Color {
        switch self {
        case .upperBody: .orange
        case .lowerBody: .yellow
        case .core: .red
        case .fullBody: .orange
        case .cardio: .pink
        case .mobility: .teal
        case .other: .secondary
        }
    }
}

enum MovementType: String, Codable, CaseIterable, Hashable, Identifiable {
    case compound
    case isolation
    case cardio
    case stretch
    case other

    var id: String { rawValue }

    var displayName: String {
        rawValue
            .replacingOccurrences(of: "_", with: " ")
            .capitalized
    }
}

struct Exercise: Codable, Hashable, Identifiable {
    let id: String
    let exerciseName: String
    let category: ExerciseCategory
    let muscleGroups: [String]
    let equipment: [String]
    let movementType: MovementType
    let coachingCues: [String]
    let videos: [ExerciseVideo]

    enum CodingKeys: String, CodingKey {
        case id
        case exerciseName = "exercise_name"
        case category
        case muscleGroups = "muscle_groups"
        case equipment
        case movementType = "movement_type"
        case coachingCues = "coaching_cues"
        case videos
    }

    var uniqueCreators: [Creator] {
        var seen = Set<String>()

        return videos
            .map(\.creator)
            .filter { creator in
                if seen.contains(creator.id) {
                    return false
                }

                seen.insert(creator.id)
                return true
            }
            .sorted { $0.displayName.localizedCaseInsensitiveCompare($1.displayName) == .orderedAscending }
    }

    var creatorSummary: String {
        switch uniqueCreators.count {
        case 0:
            "Creator pending"
        case 1:
            uniqueCreators[0].displayName
        default:
            "\(uniqueCreators.count) creators"
        }
    }

    var equipmentSummary: String {
        equipment.isEmpty ? "Bodyweight" : equipment.joined(separator: ", ")
    }

    var primaryThumbnail: String? {
        videos.first { $0.thumbnail.hasPrefix("/thumbs/") }?.thumbnail
    }
}

extension String {
    var titleCasedFilterLabel: String {
        replacingOccurrences(of: "_", with: " ")
            .split(separator: " ")
            .map { word in
                word.prefix(1).uppercased() + word.dropFirst()
            }
            .joined(separator: " ")
    }
}
