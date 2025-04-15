import SwiftUI

struct FlashCardView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: FlashCardViewModel
    @State private var userInput = ""
    @State private var borderColor = Color.gray
    @State private var borderWidth: CGFloat = 1
    private let goldColor = Color(red: 0.831, green: 0.686, blue: 0.216)
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isNameInput {
                    nameInputView
                } else {
                    flashcardView
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
    
    private var nameInputView: some View {
        VStack(spacing: 20) {
            Text("Welcome to JinApp!")
                .font(.title)
                .foregroundColor(.white)
            
            Text("Please enter your name to begin")
                .foregroundColor(.gray)
            
            TextField("Your name", text: $userInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button(action: {
                viewModel.submitName(userInput)
            }) {
                Text("Start Learning")
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(goldColor)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .disabled(userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
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
                    .fill(Color(.systemBackground))
                    .shadow(radius: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(borderColor, lineWidth: borderWidth)
                    )
                
                VStack(spacing: 20) {
                    if let card = viewModel.currentCard {
                        Text(card.character)
                            .font(.system(size: 48))
                            .foregroundColor(.white)
                        
                        Text(card.pinyin)
                            .font(.title2)
                            .foregroundColor(.gray)
                        
                        if viewModel.isShowingAnswer {
                            Text(card.translation)
                                .font(.title3)
                                .foregroundColor(.white)
                                .transition(.opacity)
                        }
                    }
                }
                .padding()
            }
            .frame(height: 300)
            .padding()
            
            // Input field
            TextField("Enter translation", text: $userInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
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
            .disabled(userInput.isEmpty || viewModel.isShowingAnswer)
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