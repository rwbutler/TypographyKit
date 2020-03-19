//
//  NSLineBreakMode.swift
//  TypographyKit
//
//  Created by Ross Butler on 21/01/2020.
//

import Foundation
import UIKit

extension NSLineBreakMode {
    
    init?(string: String) {
        switch string {
        case "char-wrap":
            self = .byCharWrapping
        case "clip":
            self = .byClipping
        case "truncate-head":
            self = .byTruncatingHead
        case "truncate-middle":
            self = .byTruncatingMiddle
        case "truncate-tail":
            self = .byTruncatingTail
        case "word-wrap":
            self = .byWordWrapping
        default:
            return nil
        }
    }
    
}
