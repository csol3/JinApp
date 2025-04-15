import SwiftUI

struct VocabSetCard: View {
    let vocabularySet: VocabularySet
    let studyProgress: StudyProgress
    @State private var showingFlashcards = false
    
    var body: some View {
        Button(action: {
            showingFlashcards = true
        }) {
            VStack(alignment: .leading, spacing: 8) {
                Text(vocabularySet.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("\(vocabularySet.cards.count) cards")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 5)
        }
        .buttonStyle(PlainButtonStyle())
        .fullScreenCover(isPresented: $showingFlashcards) {
            let viewModel = FlashCardViewModel(
                vocabularySet: vocabularySet,
                studyProgress: studyProgress
            )
            FlashCardView(viewModel: viewModel)
        }
    }
}

#Preview {
    VocabSetCard(
        vocabularySet: VocabularySet.preview,
        studyProgress: StudyProgress()
    )
    .preferredColorScheme(.dark)
    .padding()
    .background(Color.black)
} 