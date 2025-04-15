import SwiftUI

struct CardFront: View {
    let character: String
    let pinyin: String?
    let offset: CGFloat
    private let goldColor = Color(red: 0.831, green: 0.686, blue: 0.216)
    
    var body: some View {
        VStack(spacing: 16) {
            Text(character)
                .font(.system(size: 72, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 32)
            
            if let pinyin = pinyin {
                Text(pinyin)
                    .font(.title)
                    .foregroundColor(goldColor)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: 300)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(goldColor, lineWidth: 1)
        )
        .padding(.horizontal)
        .offset(x: offset)
    }
}

#Preview {
    CardFront(character: "默认", pinyin: "mòrèn", offset: 0)
        .preferredColorScheme(.dark)
        .padding()
        .background(Color.black)
} 