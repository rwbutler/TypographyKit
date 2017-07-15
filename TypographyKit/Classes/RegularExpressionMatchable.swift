//
//  RegularExpressionMatchable.swift
//  TypographyKit
//
//  Created by Ross Butler on 5/20/17.
//
//

import Foundation

protocol RegularExpressionPatternMatchable {
    static func ~= (lhs: Self, rhs: Self) -> Bool
}
