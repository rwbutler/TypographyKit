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
    
    public enum Lightness {
        private static let lightScalingFactor: Double       = 1.25
        private static let lighterScalingFactor: Double     = 1.5
        private static let lightestScalingFactor: Double    = 1.75
        private static let whiteScalingFactor: Double       = Double.greatestFiniteMagnitude

        case lightness(scalingFactor: Double)
        case light
        case lighter
        case lightest
        case white

        fileprivate var scale: Double {
            switch self {
            case .lightness(let scalingFactor):
                return scalingFactor
            case .light:
                return Lightness.lightScalingFactor
            case .lighter:
                return Lightness.lighterScalingFactor
            case .lightest:
                return Lightness.lightestScalingFactor
            case .white:
                return Lightness.whiteScalingFactor
            }
        }
    }

    public enum Darkness {
        private static let darkScalingFactor: Double    = 0.75
        private static let darkerScalingFactor: Double  = 0.5
        private static let darkestScalingFactor: Double = 0.25
        private static let blackScalingFactor: Double   = 0.0

        case darkness(Double)
        case dark
        case darker
        case darkest
        case black

        fileprivate var scale: Double {
            switch self {
            case .darkness(let scalingFactor):
                return scalingFactor
            case .dark:
                return Darkness.darkScalingFactor
            case .darker:
                return Darkness.darkerScalingFactor
            case .darkest:
                return Darkness.darkestScalingFactor
            case .black:
                return Darkness.blackScalingFactor
            }
        }
    }

    private func colorComponents(scalingFactor: CGFloat) -> ColorComponents {
        var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return ColorComponents(red: red * scalingFactor, green: green * scalingFactor, blue: blue * scalingFactor,
                               alpha: alpha)
    }
    
    private func darker(darkness: Double) -> UIColor {
        guard darkness <= 1.0 else { return self }
        var components = colorComponents(scalingFactor: CGFloat(darkness))
        components.red = CGFloat.maximum(components.red, 0.0)
        components.green = CGFloat.maximum(components.green, 0.0)
        components.blue = CGFloat.maximum(components.blue, 0.0)
        return UIColor(red: components.red, green: components.green, blue: components.blue, alpha: components.alpha)
    }
    
    private func lighter(lightness: Double) -> UIColor {
        guard lightness >= 1.0 else { return self }
        var components = colorComponents(scalingFactor: CGFloat(lightness))
        components.red = CGFloat.minimum(components.red, 1.0)
        components.green = CGFloat.minimum(components.green, 1.0)
        components.blue = CGFloat.minimum(components.blue, 1.0)
        return UIColor(red: components.red, green: components.green, blue: components.blue, alpha: components.alpha)
    }

    public func shade(_ lightness: Lightness) -> UIColor {
        switch lightness {
        case .white:
            return UIColor.white
        default:
            return self.lighter(lightness: lightness.scale)
        }
    }

    public func shade(_ darkness: Darkness) -> UIColor {
        return self.darker(darkness: darkness.scale)
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
