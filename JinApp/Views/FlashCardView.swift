import SwiftUI

struct FlashCardView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: FlashCardViewModel
    @State private var nameInput = ""
    @State private var borderColor = Color(red: 0.831, green: 0.686, blue: 0.216)
    @State private var borderWidth: CGFloat = 2
    @State private var isFlipped = false
    private let goldColor = Color(red: 0.831, green: 0.686, blue: 0.216)
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
                    if viewModel.isNameInput {
                        nameInputView
                    } else {
                        flashcardView
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(goldColor)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private var nameInputView: some View {
        VStack(spacing: 20) {
            Text("Welcome to JinApp!")
                .font(.title)
                .foregroundColor(.white)
            
            Text("Please enter your name to begin")
                .foregroundColor(.gray)
            
            TextField("Your name", text: $nameInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button(action: {
                viewModel.submitName(nameInput)
            }) {
                Text("Start Learning")
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(goldColor)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .disabled(nameInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
    }
    
    private var flashcardView: some View {
        VStack {
            // Progress bar
            ProgressView(value: viewModel.progress)
                .progressViewStyle(LinearProgressViewStyle(tint: goldColor))
                .padding()
            
            // Card
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black)
                    .shadow(radius: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(borderColor, lineWidth: borderWidth)
                    )
                
                if isFlipped {
                    // Back of card (translation)
                    if let card = viewModel.currentCard {
                        VStack(spacing: 20) {
                            Text(card.translation)
                                .font(.title)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                    }
                } else {
                    // Front of card (character and pinyin)
                    if let card = viewModel.currentCard {
                        VStack(spacing: 20) {
                            Text(card.character)
                                .font(.system(size: 48))
                                .foregroundColor(.white)
                            
                            Text(card.pinyin)
                                .font(.title2)
                                .foregroundColor(goldColor)
                        }
                        .padding()
                    }
                }
            }
            .frame(height: 300)
            .padding()
            .onChange(of: viewModel.isShowingAnswer) { oldValue, newValue in
                if newValue {
                    // First show the color feedback
                    withAnimation(.easeInOut(duration: 0.5)) {
                        borderColor = viewModel.isCorrect ? .green : .red
                        borderWidth = 4
                    }
                    
                    // Then flip the card after a short delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isFlipped = true
                        }
                    }
                } else {
                    // Reset the card
                    withAnimation(.easeInOut(duration: 0.3)) {
                        borderColor = goldColor
                        borderWidth = 2
                        isFlipped = false
                    }
                }
            }
            
            // Input field
            TextField("Enter translation", text: $viewModel.userInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .disabled(viewModel.isShowingAnswer)
            
            // Submit button
            Button(action: {
                viewModel.submitAnswer()
            }) {
                Text("Submit")
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(goldColor)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .disabled(viewModel.userInput.isEmpty || viewModel.isShowingAnswer)
            
            // Next card button (only visible when ready)
            if viewModel.isReadyForNextCard {
                Button(action: {
                    viewModel.nextCard()
                }) {
                    Text("Next Card")
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(goldColor)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .transition(.opacity)
            }
        }
    }
}

#Preview {
    FlashCardView(
        viewModel: FlashCardViewModel(
            vocabularySet: VocabularySet.preview,
            studyProgress: StudyProgress()
        )
    )
    .preferredColorScheme(.dark)
} 