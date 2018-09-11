//
//  LetterCase.swift
//  TypographyKit
//
//  Created by Ross Butler on 5/16/17.
//
//

public enum LetterCase: String {
    case regular
    case capitalized                 // e.g. Capitalized Case
    case kebab                       // e.g. kebab-case
    case lower                       // e.g. lower case
    case lowerCamel = "lower-camel"  // e.g. lowerCamelCase
    case macro                       // e.g. MACRO_CASE
    case snake                       // e.g. snakecase
    case upper                       // e.g. UPPER CASE
    case upperCamel = "upper-camel"  // e.g. UpperCamelCase
}

extension LetterCase: CustomStringConvertible {
    public var description: String {
        switch self {
        case .capitalized:
            return "Capitalized"
        case .kebab:
            return "Kebab case"
        case .lower:
            return "Lower case"
        case .lowerCamel:
            return "Lower camel case"
        case .macro:
            return "Macro case"
        case .regular:
            return "" // No letter casing is applied
        case .snake:
            return "Snake case"
        case .upper:
            return "Upper case"
        case .upperCamel:
            return "Upper camel case"
        }
    }
}
