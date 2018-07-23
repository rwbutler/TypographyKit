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

    private func darker(darkness: Double) -> UIColor {
        guard darkness <= 1.0 else { return self }

        let scalingFactor: CGFloat = CGFloat(darkness)
        var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let newR = CGFloat.maximum(red * scalingFactor, 0.0),
        newG = CGFloat.maximum(green * scalingFactor, 0.0),
        newB = CGFloat.maximum(blue * scalingFactor, 0.0)
        return UIColor(red: newR, green: newG, blue: newB, alpha: alpha)
    }

    private func lighter(lightness: Double) -> UIColor {
        guard lightness >= 1.0 else { return self }

        let scalingFactor: CGFloat = CGFloat(lightness)
        var red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let newR = CGFloat.minimum(red * scalingFactor, 1.0),
        newG = CGFloat.minimum(green * scalingFactor, 1.0),
        newB = CGFloat.minimum(blue * scalingFactor, 1.0)
        return UIColor(red: newR, green: newG, blue: newB, alpha: alpha)
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
