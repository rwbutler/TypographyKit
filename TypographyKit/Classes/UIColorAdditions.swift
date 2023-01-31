//
//  UIColorAdditions.swift
//  TypographyKit
//
//  Created by Ross Butler on 4/12/18.
//

import Foundation
import UIKit

#if !TYPOGRAPHYKIT_UICOLOR_EXTENSION
extension UIColor {
    
    private struct ColorComponents {
        var red: CGFloat
        var green: CGFloat
        var blue: CGFloat
        var alpha: CGFloat = 0.0
    }
    
    public enum Shade: CaseIterable {
        public static var allCases: [UIColor.Shade] = [
            .black,
            .dark,
            .darker,
            .darkest,
            .light,
            .lighter,
            .lightest,
            .white
        ]
        
        private static let blackScalingFactor: Double    = 0.0
        private static let darkScalingFactor: Double     = 0.75
        private static let darkerScalingFactor: Double   = 0.5
        private static let darkestScalingFactor: Double  = 0.25
        private static let lightScalingFactor: Double    = 1.25
        private static let lighterScalingFactor: Double  = 1.5
        private static let lightestScalingFactor: Double = 1.75
        private static let whiteScalingFactor: Double    = Double.greatestFiniteMagnitude

        case black
        case darkness(Double)
        case dark
        case darker
        case darkest
        case lightness(scalingFactor: Double)
        case light
        case lighter
        case lightest
        case white

        fileprivate var scale: Double {
            switch self {
            case let .darkness(scalingFactor), let .lightness(scalingFactor):
                return scalingFactor
            case .black:
                return Shade.blackScalingFactor
            case .dark:
                return Shade.darkScalingFactor
            case .darker:
                return Shade.darkerScalingFactor
            case .darkest:
                return Shade.darkestScalingFactor
            case .light:
                return Shade.lightScalingFactor
            case .lighter:
                return Shade.lighterScalingFactor
            case .lightest:
                return Shade.lightestScalingFactor
            case .white:
                return Shade.whiteScalingFactor
            }
        }
    }

    private func colorComponents(scalingFactor: CGFloat) -> ColorComponents {
        var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return ColorComponents(
            red: red * scalingFactor,
            green: green * scalingFactor,
            blue: blue * scalingFactor,
            alpha: alpha
        )
    }

    public func shade(_ shade: Shade) -> UIColor {
        var components = colorComponents(scalingFactor: CGFloat(shade.scale))
        switch shade {
        case .black, .dark, .darker, .darkest, .darkness:
            if shade.scale > 1.0 {
                return self
            }
            components.red = CGFloat.maximum(components.red, 0.0)
            components.green = CGFloat.maximum(components.green, 0.0)
            components.blue = CGFloat.maximum(components.blue, 0.0)
        case .white, .light, .lighter, .lightest, .lightness:
            if shade.scale < 1.0 {
                return self
            }
            components.red = CGFloat.minimum(components.red, 1.0)
            components.green = CGFloat.minimum(components.green, 1.0)
            components.blue = CGFloat.minimum(components.blue, 1.0)
        }
        return UIColor(
            red: components.red,
            green: components.green,
            blue: components.blue,
            alpha: components.alpha
        )
    }

    public func shade(_ name: String) -> UIColor {
        switch name {
        case "light":
            return shade(.light)
        case "lighter":
            return shade(.lighter)
        case "lightest":
            return shade(.lightest)
        case "dark":
            return shade(.dark)
        case "darker":
            return shade(.darker)
        case "darkest":
            return shade(.darkest)
        default:
            return self
        }
    }
}
#endif
