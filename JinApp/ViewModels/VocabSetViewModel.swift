import SwiftUI

enum VocabSetType: Hashable {
    case hsk(level: Int)
    case genre(VocabularySetType)
    
    var vocabularySetType: VocabularySetType {
        switch self {
        case .hsk: return .hsk
        case .genre(let type): return type
        }
    }
}

@MainActor
class VocabSetViewModel: ObservableObject {
    @Published private var vocabularySets: [VocabSetType: VocabularySet] = [:]
    @Published private var studyProgress: [VocabSetType: StudyProgress] = [:]
    private let userProfile: UserProfile
    
    init(userProfile: UserProfile) {
        self.userProfile = userProfile
    }
    
    var genrePreferences: GenrePreferences {
        userProfile.genrePreferences
    }
    
    func loadVocabularySets() async {
        print("Loading vocabulary sets...")
        let loadedSets = VocabularySetLoader.loadVocabularySets()
        print("Loaded vocabulary sets: \(loadedSets.map { $0.type })")
        
        // Clear existing sets
        vocabularySets.removeAll()
        studyProgress.removeAll()
        
        // Map loaded sets to their types
        for set in loadedSets {
            let vocabSetType: VocabSetType
            switch set.type {
            case .hsk:
                vocabSetType = .hsk(level: set.difficulty)
            case .academic:
                vocabSetType = .genre(.academic)
            case .press:
                vocabSetType = .genre(.press)
            case .fiction:
                vocabSetType = .genre(.fiction)
            }
            
            vocabularySets[vocabSetType] = set
            studyProgress[vocabSetType] = StudyProgress(
                sessions: [],
                totalCards: set.cards.count,
                completedCards: 0,
                lastStudied: nil
            )
        }
        
        print("Genre preferences: \(genrePreferences)")
        print("HSK sets: \(vocabularySets.keys)")
        print("Genre sets: \(vocabularySets.keys)")
    }
    
    func vocabularySet(for type: VocabSetType) -> VocabularySet {
        if let set = vocabularySets[type] {
            return set
        }
        print("No set found for type: \(type)") // Debug print
        return VocabularySet(
            type: .hsk,
            name: "Preview Set",
            difficulty: 1,
            cards: []
        )
    }
    
    func progress(for type: VocabSetType) -> Double {
        guard let progress = studyProgress[type] else { return 0.0 }
        return Double(progress.completedCards) / Double(progress.totalCards)
    }
    
    func lastStudied(for type: VocabSetType) -> Date? {
        studyProgress[type]?.lastStudied
    }
    
    func cardCount(for type: VocabSetType) -> Int {
        vocabularySets[type]?.cards.count ?? 0
    }
    
    func updateProgress(_ progress: StudyProgress, for type: VocabSetType) {
        studyProgress[type] = progress
    }
    
    func studyProgress(for type: VocabSetType) -> StudyProgress {
        if let progress = studyProgress[type] {
            return progress
        }
        let set = vocabularySet(for: type)
        return StudyProgress(
            sessions: [],
            totalCards: set.cards.count,
            completedCards: 0,
            lastStudied: nil
        )
    }
    
    // Separate method to initialize progress if needed
    func initializeProgress(for type: VocabSetType) {
        let set = vocabularySet(for: type)
        studyProgress[type] = StudyProgress(
            sessions: [],
            totalCards: set.cards.count,
            completedCards: 0,
            lastStudied: nil
        )
    }
} 