import SwiftUI

struct HeaderView: View {
    let learningProfile: String
    private let goldColor = Color(red: 0.831, green: 0.686, blue: 0.216)
    @State private var userName: String = ""
    
    var body: some View {
        HStack {
            Button(action: {
                // Settings action
            }) {
                Image(systemName: "gearshape.fill")
                    .font(.title2)
                    .foregroundColor(goldColor)
            }
            
            Spacer()
            
            Text("Welcome, \(userName.isEmpty ? learningProfile : userName)")
                .font(.headline)
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {
                // Profile action
            }) {
                Image(systemName: "person.circle.fill")
                    .font(.title2)
                    .foregroundColor(goldColor)
            }
        }
        .padding()
        .onAppear {
            userName = UserDefaults.standard.string(forKey: "userName") ?? ""
        }
    }
}

#Preview {
    HeaderView(learningProfile: "Student")
        .preferredColorScheme(.dark)
        .background(Color.black)
} 