import SwiftUI

struct CardBack: View {
    let translation: String
    let pinyin: String
    let example: String?
    let offset: CGFloat
    private let goldColor = Color(red: 0.831, green: 0.686, blue: 0.216)
    
    var body: some View {
        VStack(spacing: 16) {
            Text(translation)
                .font(.title)
                .foregroundColor(.white)
                .padding(.top, 32)
            
            Text(pinyin)
                .font(.title2)
                .foregroundColor(goldColor)
            
            if let example = example {
                Text(example)
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
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
    CardBack(
        translation: "Default",
        pinyin: "mòrèn",
        example: "这是默认设置。\nThis is the default setting.",
        offset: 0
    )
    .preferredColorScheme(.dark)
    .padding()
    .background(Color.black)
} 