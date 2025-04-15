import SwiftUI

@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var currentStep: OnboardingStep = .name
    @Published var userName: String = ""
    @Published var selectedProfile: String = ""
    @Published var selectedHSKLevel: Int = 1
    @Published var selectedGenres: Set<String> = []
    @Published var toneColors: [Int: Color] = [
        1: .red,
        2: .orange,
        3: .green,
        4: .blue
    ]
    
    enum OnboardingStep: Int, CaseIterable {
        case name
        case profile
        case hskLevel
        case genres
        case toneColors
        
        var next: OnboardingStep? {
            let allCases = OnboardingStep.allCases
            let nextIndex = allCases.firstIndex(of: self)?.advanced(by: 1)
            return nextIndex.flatMap { allCases[safe: $0] }
        }
    }
    
    init() {
        self.currentStep = .name
    }
    
    func updateUserName(_ name: String) {
        userName = name.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func updateLearningProfile(_ profile: String) {
        selectedProfile = profile
    }
    
    func updateHSKLevel(_ level: Int) {
        selectedHSKLevel = level
    }
    
    func updateGenrePreferences(academic: Bool? = nil, press: Bool? = nil, fiction: Bool? = nil) {
        if let academic = academic {
            if academic {
                selectedGenres.insert("academic")
            } else {
                selectedGenres.remove("academic")
            }
        }
        if let press = press {
            if press {
                selectedGenres.insert("press")
            } else {
                selectedGenres.remove("press")
            }
        }
        if let fiction = fiction {
            if fiction {
                selectedGenres.insert("fiction")
            } else {
                selectedGenres.remove("fiction")
            }
        }
    }
    
    func updateToneColor(tone: Int, color: Color) {
        toneColors[tone] = color
    }
    
    func resetToneColors() {
        toneColors = [
            1: .red,
            2: .orange,
            3: .green,
            4: .blue
        ]
    }
    
    func moveToNextStep() {
        if let next = currentStep.next {
            currentStep = next
        }
    }
    
    func completeOnboarding() {
        // Save all user preferences to UserDefaults
        UserDefaults.standard.set(userName, forKey: "userName")
        UserDefaults.standard.set(selectedProfile, forKey: "learningProfile")
        UserDefaults.standard.set(selectedHSKLevel, forKey: "hskLevel")
        UserDefaults.standard.set(Array(selectedGenres), forKey: "genrePreferences")
        
        // Save tone colors
        for (tone, color) in toneColors {
            UserDefaults.standard.set(color.toHex(), forKey: "toneColor_\(tone)")
        }
        
        // Mark onboarding as complete
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
    }
}

// Helper extension for safe array access
private extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

// Helper extension for Color to convert to hex string
extension Color {
    func toHex() -> String {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return String(
            format: "#%02lX%02lX%02lX",
            lroundf(Float(red) * 255),
            lroundf(Float(green) * 255),
            lroundf(Float(blue) * 255)
        )
    }
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 