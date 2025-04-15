import Foundation

struct FlashCard: Identifiable {
    let id: UUID
    let character: String
    let pinyin: String
    let translation: String
    let example: String?
    
    // Study tracking
    var hasBeenStudied: Bool
    var correctAttempts: Int
    var totalAttempts: Int
    var lastStudied: Date?
    
    init(id: UUID = UUID(), character: String, pinyin: String, translation: String, example: String? = nil) {
        self.id = id
        self.character = character
        self.pinyin = pinyin
        self.translation = translation
        self.example = example
        
        self.hasBeenStudied = false
        self.correctAttempts = 0
        self.totalAttempts = 0
        self.lastStudied = nil
    }
    
    var accuracy: Double {
        guard totalAttempts > 0 else { return 0 }
        return Double(correctAttempts) / Double(totalAttempts) * 100
    }
    
    mutating func recordAttempt(correct: Bool) {
        hasBeenStudied = true
        totalAttempts += 1
        if correct {
            correctAttempts += 1
        }
        lastStudied = Date()
    }
}

// Extension for study analytics
extension FlashCard {
    var needsReview: Bool {
        guard let lastStudied = lastStudied else { return true }
        
        // Review logic based on accuracy:
        // - Below 50%: Review after 1 hour
        // - 50-80%: Review after 1 day
        // - Above 80%: Review after 3 days
        let reviewInterval: TimeInterval
        
        switch accuracy {
        case 0..<50:
            reviewInterval = 3600 // 1 hour
        case 50..<80:
            reviewInterval = 86400 // 1 day
        default:
            reviewInterval = 259200 // 3 days
        }
        
        return Date().timeIntervalSince(lastStudied) >= reviewInterval
    }
    
    var difficultyLevel: Int {
        switch accuracy {
        case 0..<40: return 3 // Hard
        case 40..<75: return 2 // Medium
        default: return 1 // Easy
        }
    }
} 