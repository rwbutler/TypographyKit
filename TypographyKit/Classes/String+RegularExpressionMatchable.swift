//
//  String+RegularExpressionMatchable.swift
//  TypographyKit
//
//  Created by Ross Butler on 5/20/17.
//
//

import Foundation

extension String: RegularExpressionPatternMatchable {
    static func ~= (lhs: String, rhs: String) -> Bool {
        let matchRange = rhs.range(of: lhs, options: .regularExpression)
        return matchRange != nil && matchRange == (rhs.startIndex..<rhs.endIndex)
    }
}
