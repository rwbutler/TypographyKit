//
//  LetterCaseOptions.swift
//  LetterCase
//
//  Created by Ross Butler on 11/19/19.
//

import Foundation

public struct LetterCaseOptions: OptionSet {
    public let rawValue: Int

    static let preserveSuffix       = LetterCaseOptions(rawValue: 1 << 0)
    static let preservePunctuation  = LetterCaseOptions(rawValue: 1 << 1)
    static let stripPunctuation     = LetterCaseOptions(rawValue: 1 << 2)
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
