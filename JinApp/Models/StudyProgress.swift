import Foundation

struct StudySession: Codable {
    let id: UUID
    let date: Date
    let cardsStudied: Int
    let correctAnswers: Int
    let totalTime: TimeInterval
}

// Nonisolated data container
struct StudyProgressData: Codable {
    var sessions: [StudySession]
    var totalCards: Int
    var completedCards: Int
    var lastStudied: Date?
    var currentStreak: Int
    var bestStreak: Int
}

@MainActor
final class StudyProgress: ObservableObject {
    @Published var sessions: [StudySession]
    @Published var totalCards: Int
    @Published var completedCards: Int
    @Published var lastStudied: Date?
    @Published private(set) var currentStreak: Int
    @Published private(set) var bestStreak: Int
    
    private let defaults = UserDefaults.standard
    private let sessionsKey = "studySessions"
    private let streakKey = "studyStreak"
    private let bestStreakKey = "bestStudyStreak"
    private let lastStudyDateKey = "lastStudyDate"
    
    init(sessions: [StudySession] = [], totalCards: Int = 0, completedCards: Int = 0, lastStudied: Date? = nil) {
        self.sessions = sessions
        self.totalCards = totalCards
        self.completedCards = completedCards
        self.lastStudied = lastStudied
        self.currentStreak = 0
        self.bestStreak = 0
        loadFromDefaults()
    }
    
    var accuracy: Double {
        guard !sessions.isEmpty else { return 0.0 }
        let totalCorrect = sessions.reduce(0) { $0 + $1.correctAnswers }
        let totalStudied = sessions.reduce(0) { $0 + $1.cardsStudied }
        return Double(totalCorrect) / Double(totalStudied)
    }
    
    var averageTimePerCard: TimeInterval {
        guard !sessions.isEmpty else { return 0.0 }
        let totalTime = sessions.reduce(0.0) { $0 + $1.totalTime }
        let totalCards = sessions.reduce(0) { $0 + $1.cardsStudied }
        return totalTime / Double(totalCards)
    }
    
    // Calculate progress for a specific vocabulary set
    func progress(for vocabularySetId: UUID) -> Double {
        // For now, return a default progress value
        // In a real implementation, you would track progress per vocabulary set
        return 0.5
    }
    
    func recordSuccess() {
        completedCards += 1
        lastStudied = Date()
        updateStreak()
        saveToDefaults()
    }
    
    func recordFailure() {
        lastStudied = Date()
        updateStreak()
        saveToDefaults()
    }
    
    func completeSession(cardsStudied: Int, correctAnswers: Int, totalTime: TimeInterval) {
        let session = StudySession(
            id: UUID(),
            date: Date(),
            cardsStudied: cardsStudied,
            correctAnswers: correctAnswers,
            totalTime: totalTime
        )
        sessions.append(session)
        lastStudied = session.date
        updateStreak()
        saveToDefaults()
    }
    
    private func updateStreak() {
        guard let lastStudyDate = lastStudied else {
            currentStreak = 0
            return
        }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let lastStudy = calendar.startOfDay(for: lastStudyDate)
        
        if calendar.isDateInToday(lastStudy) {
            // Already counted for today
            return
        } else if let yesterday = calendar.date(byAdding: .day, value: -1, to: today),
                  calendar.isDate(lastStudy, inSameDayAs: yesterday) {
            // Studied yesterday, increment streak
            currentStreak += 1
            bestStreak = max(currentStreak, bestStreak)
        } else {
            // Streak broken
            currentStreak = 1
        }
    }
    
    // Analytics
    var totalCardsStudied: Int {
        sessions.reduce(0) { $0 + $1.cardsStudied }
    }
    
    var averageAccuracy: Double {
        guard !sessions.isEmpty else { return 0 }
        let totalAccuracy = sessions.reduce(into: 0.0) { result, session in
            result += Double(session.correctAnswers) / Double(session.cardsStudied)
        }
        return totalAccuracy / Double(sessions.count)
    }
    
    var totalStudyTime: TimeInterval {
        sessions.reduce(0) { $0 + $1.totalTime }
    }
    
    // Persistence
    private func loadFromDefaults() {
        if let sessionsData = defaults.data(forKey: sessionsKey),
           let data = try? JSONDecoder().decode(StudyProgressData.self, from: sessionsData) {
            self.sessions = data.sessions
            self.totalCards = data.totalCards
            self.completedCards = data.completedCards
            self.lastStudied = data.lastStudied
            self.currentStreak = data.currentStreak
            self.bestStreak = data.bestStreak
        }
    }
    
    private func saveToDefaults() {
        let data = StudyProgressData(
            sessions: sessions,
            totalCards: totalCards,
            completedCards: completedCards,
            lastStudied: lastStudied,
            currentStreak: currentStreak,
            bestStreak: bestStreak
        )
        
        if let encoded = try? JSONEncoder().encode(data) {
            defaults.set(encoded, forKey: sessionsKey)
        }
        
        defaults.set(currentStreak, forKey: streakKey)
        defaults.set(bestStreak, forKey: bestStreakKey)
    }
}