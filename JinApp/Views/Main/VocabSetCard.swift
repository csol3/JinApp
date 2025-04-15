import SwiftUI

struct VocabSetCard: View {
    let vocabularySet: VocabularySet
    @StateObject private var studyProgress = StudyProgress()
    @State private var showingFlashcards = false
    
    private let goldColor = Color(red: 212/255, green: 175/255, blue: 55/255)
    
    var body: some View {
        Button(action: {
            showingFlashcards = true
        }) {
            VStack(alignment: .leading, spacing: 12) {
                Text(vocabularySet.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text("\(vocabularySet.cards.count) cards")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                ProgressView(value: studyProgress.progress(for: vocabularySet.id))
                    .progressViewStyle(LinearProgressViewStyle(tint: goldColor))
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(4)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.black)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(goldColor, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .fullScreenCover(isPresented: $showingFlashcards) {
            let viewModel = FlashCardViewModel(vocabularySet: vocabularySet, studyProgress: studyProgress)
            FlashCardView(viewModel: viewModel)
        }
    }
}

#Preview {
    VocabSetCard(
        vocabularySet: VocabularySet.preview
    )
    .preferredColorScheme(.dark)
    .padding()
    .background(Color.black)
} 