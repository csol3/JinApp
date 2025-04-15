import Foundation

struct CSVFlashCard {
    let character: String
    let pinyin: String
    let translation: String
    let complexity: Int
    let example: String?
    
    func toFlashCard() -> FlashCard {
        FlashCard(
            character: character,
            pinyin: pinyin,
            translation: translation,
            example: example
        )
    }
}

class VocabularySetLoader {
    static func loadVocabularySets() -> [VocabularySet] {
        var sets: [VocabularySet] = []
        
        // Load HSK sets
        if let hsk1Cards = loadCSV(filename: "HSK1") {
            sets.append(VocabularySet(
                type: .hsk,
                name: "HSK 1",
                difficulty: 1,
                cards: hsk1Cards.map { $0.toFlashCard() }
            ))
        }
        
        // Load genre-based sets
        if let academicCards = loadCSV(filename: "Academic") {
            sets.append(VocabularySet(
                type: .academic,
                name: "Academic",
                difficulty: 3,
                cards: academicCards.map { $0.toFlashCard() }
            ))
        }
        
        if let pressCards = loadCSV(filename: "Press") {
            sets.append(VocabularySet(
                type: .press,
                name: "Press",
                difficulty: 4,
                cards: pressCards.map { $0.toFlashCard() }
            ))
        }
        
        if let fictionCards = loadCSV(filename: "Fiction") {
            sets.append(VocabularySet(
                type: .fiction,
                name: "Fiction",
                difficulty: 5,
                cards: fictionCards.map { $0.toFlashCard() }
            ))
        }
        
        return sets
    }
    
    private static func loadCSV(filename: String) -> [CSVFlashCard]? {
        guard let path = Bundle.main.path(forResource: filename, ofType: "csv"),
              let content = try? String(contentsOfFile: path, encoding: .utf8) else {
            print("Failed to load \(filename).csv")
            return nil
        }
        
        let rows = content.components(separatedBy: .newlines)
        var cards: [CSVFlashCard] = []
        
        for row in rows.dropFirst() { // Skip header row
            let columns = row.components(separatedBy: ",")
            guard columns.count >= 4 else { continue }
            
            let card = CSVFlashCard(
                character: columns[0].trimmingCharacters(in: .whitespaces),
                pinyin: columns[1].trimmingCharacters(in: .whitespaces),
                translation: columns[2].trimmingCharacters(in: .whitespaces),
                complexity: Int(columns[3].trimmingCharacters(in: .whitespaces)) ?? 1,
                example: columns.count > 4 ? columns[4].trimmingCharacters(in: .whitespaces) : nil
            )
            cards.append(card)
        }
        
        return cards
    }
} 