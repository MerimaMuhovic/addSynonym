//
//  String+Regex.swift
//  Merima Muhovic
//
//  Created by Merima Muhovic on 26. 3. 2023..
//

import Foundation

enum RegEx: String {
    case string = "^[A-Z a-z]+$"
    }

extension String {
    
    func isString() -> Bool {
        let stringPredicate = NSPredicate(format: "SELF MATCHES %@", RegEx.string.rawValue)
        return stringPredicate.evaluate(with: self)
    }
}
