import SwiftUI
import Foundation

@MainActor
class FlashCardViewModel: ObservableObject {
    private var vocabularySet: VocabularySet
    private var cards: [FlashCard]
    private var incorrectCards: [FlashCard] = []
    private var studyStartTime: Date?
    private var studyProgress: StudyProgress
    
    @Published var currentCardIndex = 0
    @Published var userInput = ""
    @Published var showPinyin = false
    @Published var isShowingAnswer = false
    @Published var showingCompletion = false
    @Published var correctAnswers = 0
    @Published var incorrectAnswers = 0
    @Published var isCorrect = false
    @Published var cardOffset: CGFloat = 0
    @Published var cardRotation: Double = 0
    @Published var isNameInput = true
    @Published var userName = ""
    @Published var totalCards = 0
    @Published var isReadyForNextCard = false
    
    var currentCard: FlashCard? {
        guard currentCardIndex < cards.count else { return nil }
        return cards[currentCardIndex]
    }
    
    var progress: Double {
        guard cards.count > 0 else { return 0 }
        return Double(currentCardIndex) / Double(cards.count)
    }
    
    init(vocabularySet: VocabularySet, studyProgress: StudyProgress) {
        self.vocabularySet = vocabularySet
        self.cards = vocabularySet.cards.shuffled()
        self.studyProgress = studyProgress
        self.studyStartTime = Date()
        self.isNameInput = UserDefaults.standard.string(forKey: "userName") == nil
        self.totalCards = vocabularySet.cards.count
    }
    
    func submitName(_ name: String) {
        userName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        isNameInput = false
        UserDefaults.standard.set(userName, forKey: "userName")
    }
    
    func submitAnswer() {
        guard let card = currentCard else { return }
        
        let trimmedInput = userInput.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let trimmedAnswer = card.translation.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        print("User input: '\(userInput)'")
        print("Trimmed input: '\(trimmedInput)'")
        print("Correct answer: '\(card.translation)'")
        print("Trimmed answer: '\(trimmedAnswer)'")
        
        isCorrect = trimmedInput == trimmedAnswer
        print("Answer is correct: \(isCorrect)")
        
        if isCorrect {
            correctAnswers += 1
            studyProgress.recordSuccess()
        } else {
            incorrectAnswers += 1
            studyProgress.recordFailure()
        }
        
        // Show answer feedback
        isShowingAnswer = true
        isReadyForNextCard = false
        
        // Provide haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(isCorrect ? .success : .error)
        
        // After showing the answer, mark as ready for next card
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isReadyForNextCard = true
        }
    }
    
    func nextCard() {
        // Only proceed if we're ready for the next card
        guard isReadyForNextCard else { return }
        
        isShowingAnswer = false
        isReadyForNextCard = false
        userInput = ""
        
        if currentCardIndex < cards.count - 1 {
            currentCardIndex += 1
        } else {
            showingCompletion = true
            completeSession()
        }
    }
    
    private func completeSession() {
        guard let startTime = studyStartTime else { return }
        let totalTime = Date().timeIntervalSince(startTime)
        studyProgress.completeSession(
            cardsStudied: totalCards,
            correctAnswers: correctAnswers,
            totalTime: totalTime
        )
    }
    
    func reviewMistakes() {
        guard !incorrectCards.isEmpty else { return }
        
        // Reset state for review
        currentCardIndex = 0
        correctAnswers = 0
        incorrectAnswers = 0
        isShowingAnswer = false
        isReadyForNextCard = false
        userInput = ""
        showingCompletion = false
        
        // Replace current set with incorrect cards
        cards = incorrectCards.shuffled()
        incorrectCards = []
        totalCards = cards.count
    }
} 