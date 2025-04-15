import SwiftUI

struct ProfileSelectView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    private let goldColor = Color(red: 0.831, green: 0.686, blue: 0.216)
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select Your Learning Profile")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top)
            
            ScrollView {
                VStack(spacing: 12) {
                    makeButton(title: "Beginner", description: "New to Chinese language")
                    makeButton(title: "Student", description: "Currently studying Chinese")
                    makeButton(title: "Professional", description: "Using Chinese for work")
                    makeButton(title: "Enthusiast", description: "Learning for personal interest")
                }
                .padding(.horizontal)
            }
        }
    }
    
    private func makeButton(title: String, description: String) -> some View {
        Button(action: {
            viewModel.selectedProfile = title
        }) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .font(.headline)
                    Spacer()
                    if viewModel.selectedProfile == title {
                        Image(systemName: "checkmark.circle.fill")
                    }
                }
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(viewModel.selectedProfile == title ? .black.opacity(0.8) : .gray)
            }
            .foregroundColor(viewModel.selectedProfile == title ? .black : .white)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(viewModel.selectedProfile == title ? goldColor : Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(goldColor, lineWidth: 2)
            )
            .cornerRadius(10)
        }
    }
}

#Preview {
    ProfileSelectView(viewModel: OnboardingViewModel())
        .preferredColorScheme(.dark)
} 