//
//  LabelSettings.swift
//  TypographyKit
//
//  Created by Ross Butler on 20/01/2020.
//

import Foundation
import UIKit

public struct LabelSettings: Codable {
    let lineBreakMode: NSLineBreakMode
    
    init(lineBreakMode: NSLineBreakMode) {
        self.lineBreakMode = lineBreakMode
    }
    
    private func copy(lineBreakMode: NSLineBreakMode? = nil) -> Self {
        .init(lineBreakMode: lineBreakMode ?? self.lineBreakMode)
    }
    
    func setLineBreakMode(_ lineBreakMode: NSLineBreakMode?) -> Self {
        copy(lineBreakMode: lineBreakMode)
    }
}

extension NSLineBreakMode: Codable {}
