import Foundation
import SwiftUI

enum LearningProfile: String, Codable, CaseIterable {
    case student = "Student"
    case recreational = "Recreational Learner"
    case teacher = "Teacher"
}

enum HSKLevel: Int, Codable, CaseIterable {
    case hsk1 = 1
    case hsk2 = 2
    case hsk3 = 3
    case hsk4 = 4
    case hsk5 = 5
    
    var description: String {
        return "HSK \(rawValue)"
    }
}

struct GenrePreferences: Codable, Equatable {
    var academic: Bool
    var press: Bool
    var fiction: Bool
    
    static let none = GenrePreferences(academic: false, press: false, fiction: false)
}

struct ToneColors: Codable, Equatable {
    var tone1: Color
    var tone2: Color
    var tone3: Color
    var tone4: Color
    
    static let `default` = ToneColors(
        tone1: .red,
        tone2: .orange,
        tone3: .green,
        tone4: .blue
    )
}

// Extension to make Color Codable
extension Color: Codable {
    enum CodingKeys: String, CodingKey {
        case red, green, blue, alpha
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let r = try container.decode(Double.self, forKey: .red)
        let g = try container.decode(Double.self, forKey: .green)
        let b = try container.decode(Double.self, forKey: .blue)
        let a = try container.decode(Double.self, forKey: .alpha)
        
        self.init(red: r, green: g, blue: b, opacity: a)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
        
        try container.encode(r, forKey: .red)
        try container.encode(g, forKey: .green)
        try container.encode(b, forKey: .blue)
        try container.encode(a, forKey: .alpha)
    }
}

// User profile data structure
struct UserProfileData {
    var learningProfile: LearningProfile
    var hskLevel: HSKLevel
    var genrePreferences: GenrePreferences
    var toneColors: ToneColors
    var hasCompletedOnboarding: Bool
    var userName: String
    
    static let `default` = UserProfileData(
        learningProfile: .student,
        hskLevel: .hsk1,
        genrePreferences: .none,
        toneColors: .default,
        hasCompletedOnboarding: false,
        userName: ""
    )
}

@MainActor
class UserProfile: ObservableObject {
    @Published private(set) var data: UserProfileData
    
    private let defaults = UserDefaults.standard
    private let profileKey = "userProfile"
    
    init() {
        self.data = .default
        loadFromDefaults()
    }
    
    var learningProfile: LearningProfile {
        get { data.learningProfile }
        set { data.learningProfile = newValue }
    }
    
    var hskLevel: HSKLevel {
        get { data.hskLevel }
        set { data.hskLevel = newValue }
    }
    
    var genrePreferences: GenrePreferences {
        get { data.genrePreferences }
        set { data.genrePreferences = newValue }
    }
    
    var toneColors: ToneColors {
        get { data.toneColors }
        set { data.toneColors = newValue }
    }
    
    var hasCompletedOnboarding: Bool {
        get { data.hasCompletedOnboarding }
        set { data.hasCompletedOnboarding = newValue }
    }
    
    var userName: String {
        get { data.userName }
        set { data.userName = newValue }
    }
    
    private func loadFromDefaults() {
        if let data = defaults.data(forKey: profileKey),
           let profile = try? JSONDecoder().decode(UserProfileCodable.self, from: data) {
            self.data = UserProfileData(
                learningProfile: profile.learningProfile,
                hskLevel: profile.hskLevel,
                genrePreferences: profile.genrePreferences,
                toneColors: profile.toneColors,
                hasCompletedOnboarding: profile.hasCompletedOnboarding,
                userName: profile.userName
            )
        }
    }
    
    func saveToDefaults() {
        let codable = UserProfileCodable(
            learningProfile: data.learningProfile,
            hskLevel: data.hskLevel,
            genrePreferences: data.genrePreferences,
            toneColors: data.toneColors,
            hasCompletedOnboarding: data.hasCompletedOnboarding,
            userName: data.userName
        )
        if let encoded = try? JSONEncoder().encode(codable) {
            defaults.set(encoded, forKey: profileKey)
        }
    }
}

// Separate non-isolated codable structure
private struct UserProfileCodable: Codable {
    let learningProfile: LearningProfile
    let hskLevel: HSKLevel
    let genrePreferences: GenrePreferences
    let toneColors: ToneColors
    let hasCompletedOnboarding: Bool
    let userName: String
} 