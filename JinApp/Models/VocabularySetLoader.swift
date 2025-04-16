import Foundation

struct CSVFlashCard {
    let character: String
    let pinyin: String
    let tones: String
    let meaning: String
    let strokeCount: Int
    let hskLevel: Int
    let length: Int
    let complexity: Double
    
    func toFlashCard() -> FlashCard {
        FlashCard(
            character: character,
            pinyin: pinyin,
            translation: meaning,
            example: nil
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
        // Direct path to the CSV files
        let path = "/Users/chrissole/Documents/Project/App2/JinApp/JinApp/Resources/DataNew/\(filename).csv"
        
        guard let content = try? String(contentsOfFile: path, encoding: .utf8) else {
            print("Failed to load \(filename).csv from \(path)")
            return nil
        }
        
        let rows = content.components(separatedBy: .newlines)
        var cards: [CSVFlashCard] = []
        
        for row in rows.dropFirst() { // Skip header row
            let columns = row.components(separatedBy: ",")
            guard columns.count >= 8 else { continue }
            
            let card = CSVFlashCard(
                character: columns[0].trimmingCharacters(in: .whitespaces),
                pinyin: columns[1].trimmingCharacters(in: .whitespaces),
                tones: columns[2].trimmingCharacters(in: .whitespaces),
                meaning: columns[3].trimmingCharacters(in: .whitespaces),
                strokeCount: Int(columns[4].trimmingCharacters(in: .whitespaces)) ?? 0,
                hskLevel: Int(columns[5].trimmingCharacters(in: .whitespaces)) ?? 1,
                length: Int(columns[6].trimmingCharacters(in: .whitespaces)) ?? 1,
                complexity: Double(columns[7].trimmingCharacters(in: .whitespaces)) ?? 1.0
            )
            cards.append(card)
        }
        
        print("Successfully loaded \(cards.count) cards from \(filename).csv")
        return cards
    }
} 