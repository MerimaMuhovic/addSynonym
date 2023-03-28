//
//  AppConstants.swift


import Foundation
import UIKit

struct Design {
    struct Color {
        static let blue = UIColor.rgba(red: 3, green: 16, blue: 89, alpha: 1)
        static let gray = UIColor.rgba(red: 44, green: 61, blue: 115, alpha: 1)
        static let orange = UIColor.rgba(red: 242, green: 68, blue: 5, alpha: 1)
        static let beige = UIColor.rgba(red: 242, green: 131, blue: 107, alpha: 1)
    }
    struct Image {
        static let searchIcon = UIImage(named: "search")
        static let messageIcon = UIImage(named: "message")

    }
    struct Font {
        struct Heading {
            static let Huge = UIFont.systemFont(ofSize: 69, weight: .bold)
            
        }
        struct Body {
            static let Body = UIFont.systemFont(ofSize: 16, weight: .regular)
            
        }
    }
    
}

struct Content {
    static let headerText = "Sequi libero quis rerum dolor ab minus nisi perferendis."
    static let search = "Search"
    static let addSynonyms = "Add new synonyms"

}

struct API {
    // example: static let DB_REF = Firestore.firestore()
}
extension UIColor {
    static func rgba(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}
