import SwiftUI

struct HSKSelectView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    private let goldColor = Color(red: 0.831, green: 0.686, blue: 0.216)
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select Your HSK Level")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top)
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(1...6, id: \.self) { level in
                        Button(action: {
                            viewModel.selectedHSKLevel = level
                        }) {
                            HStack {
                                Text("HSK Level \(level)")
                                    .font(.headline)
                                Spacer()
                                if viewModel.selectedHSKLevel == level {
                                    Image(systemName: "checkmark.circle.fill")
                                }
                            }
                            .foregroundColor(viewModel.selectedHSKLevel == level ? .black : .white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(viewModel.selectedHSKLevel == level ? goldColor : Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(goldColor, lineWidth: 2)
                            )
                            .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    HSKSelectView(viewModel: OnboardingViewModel())
        .preferredColorScheme(.dark)
} 