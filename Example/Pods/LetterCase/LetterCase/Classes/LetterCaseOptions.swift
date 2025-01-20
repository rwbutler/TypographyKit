//
//  LetterCaseOptions.swift
//  LetterCase
//
//  Created by Ross Butler on 11/19/19.
//

import Foundation

public struct LetterCaseOptions: OptionSet {
    public let rawValue: Int

    public static let preserveSuffix       = LetterCaseOptions(rawValue: 1 << 0)
    public static let preservePunctuation  = LetterCaseOptions(rawValue: 1 << 1)
    public static let stripPunctuation     = LetterCaseOptions(rawValue: 1 << 2)
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
