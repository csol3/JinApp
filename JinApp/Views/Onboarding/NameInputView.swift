import SwiftUI

struct NameInputView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    private let goldColor = Color(red: 0.831, green: 0.686, blue: 0.216)
    @State private var nameInput = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to JinApp!")
                .font(.title)
                .foregroundColor(.white)
                .padding(.top)
            
            Text("Please enter your name to begin")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            TextField("Your name", text: $nameInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .onChange(of: nameInput) { oldValue, newValue in
                    viewModel.updateUserName(newValue)
                }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    NameInputView(viewModel: OnboardingViewModel())
        .preferredColorScheme(.dark)
        .background(Color.black)
} 