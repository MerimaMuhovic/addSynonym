import Foundation

class WelcomeViewModel: AppViewModel {
    var words: [String] = []
    var synonyms: [String: [String]] = [:]
    var synonymsDict: [String: [String]] {
        return synonyms
    }
    var filteredWords: [String]?
    override init() {
        
    }
    
    func addWord(_ word: String) {
        guard !word.isEmpty else { return }
        if !words.contains(word) {
            words.append(word)
            synonyms[word] = []
        }
    }
    
    func addSynonym(_ synonym: String, to word: String) {
        guard !synonym.isEmpty else { return }
        if words.contains(word) && !synonyms[word]!.contains(synonym) {
            synonyms[word]!.append(synonym)
            // add the synonym to all transitive words
            for (key, value) in synonyms {
                if value.contains(word) && !synonyms[key]!.contains(synonym) {
                    synonyms[key]!.append(synonym)
                }
            }
        }
    }
    
    func removeWord(_ word: String) {
        if let index = words.firstIndex(of: word) {
            words.remove(at: index)
        }
        // Remove the word from UserDefaults
        let defaults = UserDefaults.standard
        defaults.set(words, forKey: "savedWords")
        // Remove the synonyms for the word
        synonyms.removeValue(forKey: word)
    }
}
