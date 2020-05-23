//
//  ButtonTitleColorApplyMode.swift
//  TypographyKit
//
//  Created by Ross Butler on 23/05/2020.
//

import Foundation

@objc public enum ButtonTitleColorApplyMode: Int {
    case all                // applies the style color to all control states
    case none               // doesn't apply the style color to any control states
    case normal             // applies the style color to the .normal state only
    case whereUnspecified   // applies the style color to any state where a color hasn't been explicitly specified
    
    init?(string: String) {
        switch string {
        case "all":
            self = .all
        case "none":
            self = .none
        case "normal":
            self = .normal
        case "where-unspecified":
            self = .whereUnspecified
        default:
            return nil
        }
    }
}
