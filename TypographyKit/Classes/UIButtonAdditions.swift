//
//  UIButtonAdditions.swift
//  TypographyKit
//
//  Created by Ross Butler on 5/16/17.
//
//

import Foundation

public extension UIButton {
    private var controlStates: [UIControlState] {
        var controlStates: [UIControlState] = [.normal, .highlighted, .disabled, .selected, .application]
        if #available(iOS 9, *) {
            controlStates.append(.focused)
        }
        return controlStates
    }

    public var letterCase: LetterCase {
        get {
            // swiftlint:disable:next force_cast
            return objc_getAssociatedObject(self, &TypographyKitPropertyAdditionsKey.letterCase) as! LetterCase
        }
        set {
            objc_setAssociatedObject(self,
                                     &TypographyKitPropertyAdditionsKey.letterCase,
                                     newValue, .OBJC_ASSOCIATION_RETAIN)

            for controlState in controlStates {
                let title = self.title(for: controlState)?.letterCase(newValue)
                self.setTitle(title, for: controlState)
            }
        }
    }

    public var fontTextStyle: UIFontTextStyle {
        get {
            // swiftlint:disable:next force_cast
            return objc_getAssociatedObject(self, &TypographyKitPropertyAdditionsKey.fontTextStyle) as! UIFontTextStyle
        }
        set {
            objc_setAssociatedObject(self,
                                     &TypographyKitPropertyAdditionsKey.fontTextStyle,
                                     newValue, .OBJC_ASSOCIATION_RETAIN)
            if let typography = Typography(for: newValue) {
                self.typography = typography
            }
        }
    }

    public var typography: Typography {
        get {
            // swiftlint:disable:next force_cast
            return objc_getAssociatedObject(self, &TypographyKitPropertyAdditionsKey.typography) as! Typography
        }
        set {
            objc_setAssociatedObject(self,
                                     &TypographyKitPropertyAdditionsKey.typography,
                                     newValue, .OBJC_ASSOCIATION_RETAIN)
            if let newFont = newValue.font(UIApplication.shared.preferredContentSizeCategory) {
                self.titleLabel?.font = newFont
            }
            if let textColor = newValue.textColor {
                for controlState in controlStates {
                    self.setTitleColor(textColor, for: controlState)
                }
            }
            if let letterCase = newValue.letterCase {
                self.letterCase = letterCase
            }
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(contentSizeCategoryDidChange(_:)),
                                                   name: NSNotification.Name.UIContentSizeCategoryDidChange,
                                                   object: nil)
        }
    }

    public func text(_ text: String?,
                     style: UIFontTextStyle,
                     letterCase: LetterCase? = nil,
                     textColor: UIColor? = nil) {
        if let text = text {
            for controlState in controlStates {
                self.setTitle(text, for: controlState)
            }
        }
        if var typography = Typography(for: style) {
            // Only override letterCase and textColor if explicitly specified
            if let textColor = textColor {
                typography.textColor = textColor
            }
            if let letterCase = letterCase {
                typography.letterCase = letterCase
            }
            self.typography = typography
        }
    }

    @objc private func contentSizeCategoryDidChange(_ notification: NSNotification) {
        if let newValue = notification.userInfo?[UIContentSizeCategoryNewValueKey] as? UIContentSizeCategory {
            self.titleLabel?.font = self.typography.font(newValue)
        }
    }
}
