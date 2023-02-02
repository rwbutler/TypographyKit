//
//  LabelSettings.swift
//  TypographyKit
//
//  Created by Ross Butler on 20/01/2020.
//

import Foundation
import UIKit

struct LabelSettings: Codable {
    let lineBreakMode: NSLineBreakMode
    
    init(lineBreakMode: NSLineBreakMode = .byWordWrapping) {
        self.lineBreakMode = lineBreakMode
    }
}

extension NSLineBreakMode: Codable {}
