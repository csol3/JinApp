import SwiftUI

struct FlashcardView: View {
    @ObservedObject var viewModel: FlashCardViewModel
    @State private var showAnswer = false
    @State private var borderColor: Color
    @State private var borderWidth: CGFloat = 2
    private let goldColor = Color(red: 0.831, green: 0.686, blue: 0.216)
    
    init(viewModel: FlashCardViewModel) {
        self.viewModel = viewModel
        _borderColor = State(initialValue: Color(red: 0.831, green: 0.686, blue: 0.216))
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Progress bar
                ProgressView(value: viewModel.progress)
                    .progressViewStyle(.linear)
                    .tint(goldColor)
                    .padding()
                
                // Card
                VStack(spacing: 20) {
                    if let card = viewModel.currentCard {
                        Text(card.character)
                            .font(.system(size: 48))
                            .bold()
                            .foregroundColor(.white)
                        
                        Text(card.pinyin)
                            .font(.title2)
                            .foregroundColor(goldColor)
                        
                        if viewModel.isShowingAnswer {
                            Text(card.translation)
                                .font(.title3)
                                .foregroundColor(.white)
                                .transition(.opacity)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 200)
                .padding()
                .background(Color.black)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
                .padding()
                .onChange(of: viewModel.isShowingAnswer) { oldValue, newValue in
                    print("isShowingAnswer changed to: \(newValue)")
                    if newValue {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            borderColor = viewModel.isCorrect ? .green : .red
                            borderWidth = 4
                            showAnswer = true
                        }
                    } else {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            borderColor = goldColor
                            borderWidth = 2
                            showAnswer = false
                        }
                    }
                }
                
                // Input field
                TextField("Enter translation", text: $viewModel.userInput)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .disabled(viewModel.isShowingAnswer)
                
                // Submit button
                Button(action: {
                    viewModel.submitAnswer()
                }) {
                    Text("Submit")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(goldColor)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(viewModel.isShowingAnswer)
            }
        }
        .sheet(isPresented: $viewModel.showingCompletion) {
            CompletionView(
                correctAnswers: viewModel.correctAnswers,
                totalCards: viewModel.totalCards,
                onReviewMistakes: viewModel.reviewMistakes
            )
        }
    }
}

#Preview {
    let viewModel = FlashCardViewModel(
        vocabularySet: VocabularySet.preview,
        studyProgress: StudyProgress()
    )
    return FlashcardView(viewModel: viewModel)
} 