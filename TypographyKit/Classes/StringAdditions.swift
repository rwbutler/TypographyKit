//
//  StringAdditions.swift
//  TypographyKit
//
//  Created by Ross Butler on 5/16/17.
//
//

import Foundation

public extension String {
    func letterCase(_ letterCase: LetterCase, preserveSuffix: Bool = false) -> String {
        switch letterCase {
        case .capitalized:
            return self.capitalized
        case .kebab:
            return self.kebabCased(preserveSuffix: preserveSuffix)
        case .lower:
            return self.lowercased()
        case .lowerCamel:
            return self.lowerCamelCased(preserveSuffix: preserveSuffix)
        case .macro:
            return self.macroCased()
        case .snake:
            return self.snakeCased()
        case .upper:
            return self.uppercased()
        case .upperCamel:
            return self.upperCamelCased(preserveSuffix: preserveSuffix)
        default:
            return self
        }
    }
    
    func kebabCased(preserveSuffix: Bool = false) -> String {
        return self.capitalizeSubSequences(capitalizeFirst: false, conjunction: "-", preserveSuffix: preserveSuffix)
    }
    
    func lowerCamelCased(preserveSuffix: Bool = false) -> String {
        let upperCamelCased = self.upperCamelCased(preserveSuffix: preserveSuffix)
        if let firstChar = self.characters.first {
            return String(firstChar).lowercased() + String(upperCamelCased.characters.dropFirst())
        }
        return upperCamelCased
    }
    
    func macroCased() -> String {
        return self.capitalizeSubSequences(capitalizeFirst: true, conjunction: "_").uppercased()
    }
    
    func snakeCased() -> String {
        return self.capitalizeSubSequences(capitalizeFirst: false)
    }
    
    func upperCamelCased(preserveSuffix: Bool = false) -> String {
        return self.capitalizeSubSequences(capitalizeFirst: true, preserveSuffix: preserveSuffix)
    }
    
    private func capitalizeSubSequences(capitalizeFirst: Bool, conjunction: String = "", preserveSuffix: Bool = false) -> String {
        var result = ""
        for subSequence in self.characters.split(separator: " ") {
            if let firstChar = subSequence.first {
                let prefixWithCase = (capitalizeFirst) ? String(firstChar).uppercased() : String(firstChar).lowercased()
                let suffix = String(subSequence.dropFirst())
                let suffixWithCase = preserveSuffix ? suffix : suffix.lowercased()
                result += prefixWithCase + suffixWithCase + conjunction
            }
        }
        if !conjunction.isEmpty, result.characters.count > 0 {
            return String(result.characters.dropLast())
        }
        return result
    }
}
