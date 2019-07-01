//
//  UIButtonAdditions.swift
//  TypographyKit
//
//  Created by Ross Butler on 5/16/17.
//
//

import Foundation

extension UIButton {
    private var controlStates: [UIControl.State] {
        var controlStates: [UIControl.State] = [.normal, .highlighted, .disabled, .selected, .application]
        if #available(iOS 9, *) {
            controlStates.append(.focused)
        }
        return controlStates
    }

    @objc public var fontTextStyle: UIFont.TextStyle {
        get {
            // swiftlint:disable:next force_cast
            return objc_getAssociatedObject(self, &TypographyKitPropertyAdditionsKey.fontTextStyle) as! UIFont.TextStyle
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

    @objc public var fontTextStyleName: String {
        get {
            return fontTextStyle.rawValue
        }
        set {
            fontTextStyle = UIFont.TextStyle(rawValue: newValue)
        }
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
            let title = self.title(for: .normal)?.letterCase(newValue)
            self.setTitle(title, for: .normal)
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
                                                   name: UIContentSizeCategory.didChangeNotification,
                                                   object: nil)
        }
    }

    // MARK: Functions

    public func attributedText(_ text: NSAttributedString?,
                               style: UIFont.TextStyle,
                               letterCase: LetterCase = .regular,
                               textColor: UIColor? = nil) {

        let contentSizeCategory = UIApplication.shared.preferredContentSizeCategory
        let fontAttributeKey = NSAttributedString.Key.font
        let typography = Typography(for: style)
        if let textColor = textColor {
            self.titleLabel?.textColor = textColor
        }

        guard let text = text else { return }
        self.setAttributedTitle(text, for: .normal)
        let mutableText = NSMutableAttributedString(attributedString: text)
        mutableText.enumerateAttributes(in: NSRange(location: 0, length: text.string.count),
                                        options: [],
                                        using: { value, range, _ in
                                            if let fontAttribute = value[fontAttributeKey] as? UIFont,
                                                let newPointSize = typography?.font(contentSizeCategory)?.pointSize,
                                                let newFont = UIFont(name: fontAttribute.fontName, size: newPointSize) {
                                                mutableText.removeAttribute(fontAttributeKey, range: range)
                                                mutableText.addAttribute(fontAttributeKey, value: newFont, range: range)
                                            }
        })
        self.setAttributedTitle(mutableText, for: .normal)

    }

    public func text(_ text: String?, style: UIFont.TextStyle, letterCase: LetterCase? = nil,
                     textColor: UIColor? = nil) {
        if let text = text {
            self.setTitle(text, for: .normal)
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
        if let newValue = notification.userInfo?[UIContentSizeCategory.newValueUserInfoKey] as? UIContentSizeCategory {
            self.titleLabel?.font = self.typography.font(newValue)
        }
    }
}
