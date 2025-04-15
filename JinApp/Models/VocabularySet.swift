import Foundation

enum VocabularySetType {
    case hsk
    case academic
    case press
    case fiction
}

struct VocabularySet: Identifiable {
    let id = UUID()
    let type: VocabularySetType
    let name: String
    let difficulty: Int
    var cards: [FlashCard]
}

// Preview extension for development and testing
extension VocabularySet {
    static var preview: VocabularySet {
        VocabularySet(
            type: .hsk,
            name: "HSK 1",
            difficulty: 1,
            cards: [
                FlashCard(
                    id: UUID(),
                    character: "默认",
                    pinyin: "mòrèn",
                    translation: "default",
                    example: "这是默认设置。\nThis is the default setting."
                ),
                FlashCard(
                    id: UUID(),
                    character: "学习",
                    pinyin: "xuéxí",
                    translation: "study",
                    example: "我喜欢学习中文。\nI like studying Chinese."
                )
            ]
        )
    }
} 