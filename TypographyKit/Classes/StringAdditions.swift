//
//  StringAdditions.swift
//  TypographyKit
//
//  Created by Ross Butler on 5/16/17.
//
//

import LetterCase
import UIKit

public extension String {
    
    func letterCase(style: UIFont.TextStyle) -> String {
        guard let letterCase = Typography(for: style)?.letterCase else {
            return self
        }
        return self.letterCase(letterCase)
    }
    
}
