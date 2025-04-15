import SwiftUI

struct ProgressBar: View {
    let progress: Double
    private let goldColor = Color(red: 0.831, green: 0.686, blue: 0.216)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                
                Rectangle()
                    .fill(goldColor)
                    .frame(width: geometry.size.width * progress)
            }
            .cornerRadius(2)
        }
    }
}

#Preview {
    ProgressBar(progress: 0.7)
        .frame(height: 4)
        .padding()
        .preferredColorScheme(.dark)
        .background(Color.black)
} 