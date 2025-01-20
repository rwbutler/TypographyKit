//
//  LetterCase.swift
//  LetterCase
//
//  Created by Ross Butler on 11/19/19.
//

import Foundation

public enum LetterCase: String {
    
    public typealias Options = LetterCaseOptions
    
    case regular                     // No transformation applied.
    case capitalized                 // e.g. Capitalized Case
    case kebab                       // e.g. kebab-case
    case lower                       // e.g. lower case
    case lowerCamel = "lower-camel"  // e.g. lowerCamelCase
    case macro                       // e.g. MACRO_CASE
    case train                       // e.g. TRAIN-CASE
    case snake                       // e.g. snake_case
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
            return "Regular"
        case .snake:
            return "Snake case"
        case .train:
            return "Train case"
        case .upper:
            return "Upper case"
        case .upperCamel:
            return "Upper camel case"
        }
    }
}
