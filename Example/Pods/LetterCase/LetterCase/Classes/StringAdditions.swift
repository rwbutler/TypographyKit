//
//  StringAdditions.swift
//  LetterCase
//
//  Created by Ross Butler on 11/19/19.
//

import Foundation

public extension String {
    
    func convert(
        from letterCase: LetterCase,
        to newLetterCase: LetterCase,
        options: LetterCase.Options = []
    ) -> String {
        switch letterCase {
        case .capitalized, .lower, .regular, .upper:
            return convertFromCaseWith(separator: " ", to: newLetterCase, options: options)
        case .kebab, .train:
            return convertFromCaseWith(separator: "-", to: newLetterCase, options: options)
        case .lowerCamel, .upperCamel:
            return convertFromCaseWith(separator: nil, to: newLetterCase, options: options)
        case .macro, .snake:
            return convertFromCaseWith(separator: "_", to: newLetterCase, options: options)
        }
    }
    
    func letterCase(_ letterCase: LetterCase, options: LetterCase.Options = []) -> String {
        switch letterCase {
        case .capitalized:
            return capitalized(options: options)
        case .kebab:
            return kebabCased(options: options)
        case .lower:
            return lowerCased(options: options)
        case .lowerCamel:
            return lowerCamelCased(options: options)
        case .macro:
            return macroCased(options: options)
        case .snake:
            return snakeCased(options: options)
        case .upper:
            return upperCased(options: options)
        case .upperCamel:
            return upperCamelCased(options: options)
        default:
            var input = self
            if options.contains(.stripPunctuation) {
                input = stripPunctuation(input)
            }
            return input
        }
    }
    
    func capitalized(options: LetterCase.Options = [], separator: String.Element? = " ") -> String {
        var input = self
        if options.contains(.stripPunctuation) {
            input = stripPunctuation(input)
        }
        return capitalizeSubSequences(capitalizeFirst: true, conjunction: " ", options: options, separator: separator)
    }
    
    func kebabCased(options: LetterCase.Options = [], separator: String.Element? = " ") -> String {
        var options: LetterCase.Options = options
        if !options.contains(.preservePunctuation) {
            options.update(with: .stripPunctuation)
        }
        return capitalizeSubSequences(capitalizeFirst: false, conjunction: "-", options: options, separator: separator)
    }
    
    func lowerCased(options: LetterCase.Options = [], separator: String.Element? = " ") -> String {
        var input = self
        if options.contains(.stripPunctuation) {
            input = stripPunctuation(input)
        }
        return capitalizeSubSequences(capitalizeFirst: false, conjunction: " ", options: options, separator: separator)
            .lowercased()
    }
    
    func lowerCamelCased(options: LetterCase.Options = [], separator: String.Element? = " ") -> String {
        var options: LetterCase.Options = options
        if !options.contains(.preservePunctuation) {
            options.update(with: .stripPunctuation)
        }
        let upperCamelCased = self.upperCamelCased(options: options, separator: separator)
        if let firstChar = upperCamelCased.first {
            return String(firstChar).lowercased() + String(upperCamelCased.dropFirst())
        }
        return upperCamelCased
    }
    
    func macroCased(options: LetterCase.Options = [], separator: String.Element? = " ") -> String {
        var options: LetterCase.Options = [options]
        if !options.contains(.preservePunctuation) {
            options.update(with: .stripPunctuation)
        }
        return capitalizeSubSequences(capitalizeFirst: true, conjunction: "_", options: options, separator: separator)
            .uppercased()
    }
    
    func snakeCased(options: LetterCase.Options = [], separator: String.Element? = " ") -> String {
        var options: LetterCase.Options = options
        if !options.contains(.preservePunctuation) {
            options.update(with: .stripPunctuation)
        }
        return capitalizeSubSequences(capitalizeFirst: false, conjunction: "_", options: options, separator: separator)
    }
    
    func trainCased(options: LetterCase.Options = [], separator: String.Element? = " ") -> String {
        return kebabCased(options: options, separator: separator).upperCased()
    }
    
    func upperCamelCased(options: LetterCase.Options = [], separator: String.Element? = " ") -> String {
        var options: LetterCase.Options = options
        if !options.contains(.preservePunctuation) {
            options.update(with: .stripPunctuation)
        }
        return capitalizeSubSequences(capitalizeFirst: true, options: options, separator: separator)
    }
    
    func upperCased(options: LetterCase.Options = [], separator: String.Element? = " ") -> String {
        var input = self
        if options.contains(.stripPunctuation) {
            input = stripPunctuation(input)
        }
        return capitalizeSubSequences(capitalizeFirst: true, conjunction: " ", options: options, separator: separator)
            .uppercased()
    }
    
}

// Private API
private extension String {
    
    private func capitalizedSubSequences() -> [String.SubSequence] {
        let input = self
        var seqStartIndex = input.startIndex
        var subSequences: [String.SubSequence] = []
        for index in input.indices {
            let currentCharacter = input[index]
            if currentCharacter.isUppercase {
                if index != input.startIndex {
                    let seqEndIndex = input.index(before: index)
                    let subSequence = input[seqStartIndex...seqEndIndex]
                    subSequences.append(subSequence)
                }
                seqStartIndex = index
            }
        }
        let subSequence = input[seqStartIndex..<input.endIndex]
        subSequences.append(subSequence)
        return subSequences
    }
    
    func capitalizeSubSequences(
        capitalizeFirst: Bool,
        conjunction: String = "",
        options: LetterCase.Options = [],
        separator: String.Element? = " "
    ) -> String {
        var result = ""
        let subSequences: [String.SubSequence]
        if let separator = separator {
            subSequences = split(separator: separator)
        } else {
            subSequences = capitalizedSubSequences()
        }
        for subSequence in subSequences {
            if let firstChar = subSequence.first {
                let prefixWithCase = (capitalizeFirst) ? String(firstChar).uppercased() : String(firstChar).lowercased()
                let suffix = String(subSequence.dropFirst())
                let suffixWithCase = options.contains(.preserveSuffix) ? suffix : suffix.lowercased()
                result += prefixWithCase + suffixWithCase + conjunction
            }
        }
        if !conjunction.isEmpty, !result.isEmpty {
            result = String(result.dropLast())
        }
        if options.contains(.stripPunctuation) {
            result = stripPunctuation(result, except: conjunction.first)
        }
        return result
    }
    
    private func convertFromCaseWith(
        separator: String.Element?,
        to letterCase: LetterCase, options: LetterCase.Options = []
    ) -> String {
        switch letterCase {
        case .capitalized:
            return capitalized(options: options, separator: separator)
        case .kebab:
            return kebabCased(options: options, separator: separator)
        case .lower:
            return lowerCased(options: options, separator: separator)
        case .lowerCamel:
            return lowerCamelCased(options: options, separator: separator)
        case .macro:
            return macroCased(options: options, separator: separator)
        case .regular:
            return self // No change
        case .snake:
            return snakeCased(options: options, separator: separator)
        case .train:
            return trainCased(options: options, separator: separator)
        case .upper:
            return upperCased(options: options, separator: separator)
        case .upperCamel:
            return upperCamelCased(options: options, separator: separator)
        }
    }
    
    /// Strips punctuation from the provided input `String` leaving only alphanumeric characters except
    /// for a given special character if one is specified.
    private func stripPunctuation(_ input: String, except: Character? = nil) -> String {
        let chars = input.compactMap {
            return ($0.isLetter || $0.isWholeNumber || $0 == except) ? $0 : nil
        }
        return String(chars)
    }
    
}
