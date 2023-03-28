import Foundation
import Bond
import ReactiveKit

class RegistrationViewModel: AppViewModel {
    var word: String = ""
    var synonyms = Property<[String: [String]]>([:])
    let synonymsDidUpdate = SafePublishSubject<Void>()
    
    override init() {
        super.init()
        // Load the saved data from UserDefaults for all words and their synonyms
        var savedSynonyms: [String: [String]] = [:]
        for (key, _) in UserDefaults.standard.dictionaryRepresentation() {
            let synonymsArray = UserDefaults.standard.array(forKey: key) as? [String] ?? []
            savedSynonyms[key] = synonymsArray
        }
        self.synonyms.value = savedSynonyms
    }
    
    func setWord(_ word: String) {
        self.word = word
        self.synonyms.value = synonymsForWord(word)
        synonymsDidUpdate.send()
        print(word)
    }
    
    func synonymsForWord(_ word: String) -> [String: [String]] {
        let synonymsArray = UserDefaults.standard.array(forKey: word) as? [String] ?? []
        var synonyms = [word: synonymsArray]
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            if let synonymsForKey = value as? [String], synonymsForKey.contains(word) {
                let synonymsForKeyArray = UserDefaults.standard.array(forKey: key) as? [String] ?? []
                synonyms[key] = synonymsForKeyArray
            }
        }
        return synonyms
    }
    
    func addSynonym(_ synonym: String, toWord word: String) throws {
        guard !synonym.isEmpty else { return }
        if var synonymsForKey = UserDefaults.standard.array(forKey: word) as? [String] {
            // If the word already has some synonyms, append the new synonym to its list of synonyms
            if !synonymsForKey.contains(synonym) {
                synonymsForKey.append(synonym)
                UserDefaults.standard.set(synonymsForKey, forKey: word)
                synonyms.value = synonymsForWord(word)
                synonymsDidUpdate.send()
                print("Synonym added: \(synonym) to word: \(word)")
                print("Updated synonyms: \(synonyms.value)")
            }
        } else {
            // If the word does not have any synonyms yet, create a new dictionary entry with the word and the new synonym
            UserDefaults.standard.set([synonym], forKey: word)
            synonyms.value = synonymsForWord(word)
            synonymsDidUpdate.send()
            print("Synonym added: \(synonym) to new word: \(word)")
            print("Updated synonyms: \(synonyms.value)")
        }
    }
    
    func removeSynonym(_ synonym: String, fromWord word: String) throws {
        guard var synonymsForKey = UserDefaults.standard.array(forKey: word) as? [String],
              let index = synonymsForKey.firstIndex(of: synonym)
        else {
            return
        }
        synonymsForKey.remove(at: index)
        if synonymsForKey.isEmpty {
            UserDefaults.standard.removeObject(forKey: word)
        } else {
            UserDefaults.standard.set(synonymsForKey, forKey: word)
        }
        synonyms.value = synonymsForWord(word)
        synonymsDidUpdate.send()
        print("Synonym removed: \(synonym) from word: \(word)")
        print("Updated synonyms: \(synonyms.value)")
    }

}
