import SwiftUI

struct CompletionView: View {
    let correctAnswers: Int
    let totalCards: Int
    let onReviewMistakes: () -> Void
    
    private var accuracy: Double {
        Double(correctAnswers) / Double(totalCards) * 100
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Study Session Complete!")
                .font(.title)
                .bold()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Results:")
                    .font(.headline)
                
                Text("Cards Studied: \(totalCards)")
                Text("Correct Answers: \(correctAnswers)")
                Text("Accuracy: \(String(format: "%.1f", accuracy))%")
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 5)
            
            Button(action: onReviewMistakes) {
                Text("Review Mistakes")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding()
    }
} 