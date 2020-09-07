//
//  UIButtonAdditions.swift
//  TypographyKit
//
//  Created by Ross Butler on 5/16/17.
//
//

import Foundation
import UIKit

extension UIButton {
    
    public typealias TitleColorApplyMode = ButtonTitleColorApplyMode
    
    @objc public var fontTextStyle: UIFont.TextStyle {
        get {
            // swiftlint:disable:next force_cast
            return objc_getAssociatedObject(self, &TypographyKitPropertyAdditionsKey.fontTextStyle) as! UIFont.TextStyle
        }
        set {
            objc_setAssociatedObject(self, &TypographyKitPropertyAdditionsKey.fontTextStyle,
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
            objc_setAssociatedObject(self, &TypographyKitPropertyAdditionsKey.letterCase,
                                     newValue, .OBJC_ASSOCIATION_RETAIN)
            if !isAttributed() {
                let title = self.title(for: .normal)?.letterCase(newValue)
                self.setTitle(title, for: .normal)
            }
        }
    }
    
    @objc public var titleColorApplyMode: TitleColorApplyMode {
        get {
            objc_getAssociatedObject(
                self,
                &TypographyKitPropertyAdditionsKey.titleColorApplyMode
            ) as? TitleColorApplyMode ?? TypographyKit.buttonTitleColorApplyMode
        }
        set {
            objc_setAssociatedObject(
                self,
                &TypographyKitPropertyAdditionsKey.titleColorApplyMode,
                newValue,
                .OBJC_ASSOCIATION_RETAIN
            )
        }
    }
    
    public var typography: Typography {
        get {
            // swiftlint:disable:next force_cast
            return objc_getAssociatedObject(self, &TypographyKitPropertyAdditionsKey.typography) as! Typography
        }
        set {
            objc_setAssociatedObject(self, &TypographyKitPropertyAdditionsKey.typography,
                                     newValue, .OBJC_ASSOCIATION_RETAIN)
            addObserver()
            guard !isAttributed() else {
                return
            }
            if let newFont = newValue.font(UIApplication.shared.preferredContentSizeCategory) {
                self.titleLabel?.font = newFont
            }
            if let textColor = newValue.textColor {
                applyTitleColor(textColor, mode: titleColorApplyMode)
            }
            if let disabledTextColor = newValue.disabledTextColor {
                self.setTitleColor(disabledTextColor, for: .disabled)
            }
            if let highlightedTextColor = newValue.highlightedTextColor {
                self.setTitleColor(highlightedTextColor, for: .highlighted)
            }
            if let selectedTextColor = newValue.selectedTextColor {
                self.setTitleColor(selectedTextColor, for: .selected)
            }
            if let tintColor = newValue.tintColor {
                self.tintColor = tintColor
            }
            if let backgroundColor = newValue.backgroundColor {
                self.backgroundColor = backgroundColor
            }
            if let letterCase = newValue.letterCase {
                self.letterCase = letterCase
            }
        }
    }
    
    // MARK: Functions
    
    public func attributedText(_ text: NSAttributedString?, style: UIFont.TextStyle,
                               letterCase: LetterCase? = nil, textColor: UIColor? = nil,
                               replacingDefaultTextColor: Bool = false, replacingDefaultBackgroundColor: Bool = false) {
        // Update text.
        if let text = text {
            self.setAttributedTitle(text, for: .normal)
        }
        // Update text color.
        if let textColor = textColor {
            self.setTitleColor(textColor, for: .normal)
        }
        guard var typography = Typography(for: style), let attrString = text else {
            return
        }
        
        // Apply overriding parameters.
        typography.textColor = textColor ?? typography.textColor
        typography.letterCase = letterCase ?? typography.letterCase
        self.fontTextStyle = style
        self.typography = typography
        
        attributedText(attrString, for: .normal,
                       replacingDefaultTextColor: replacingDefaultTextColor, replacingTextColor: typography.textColor)
        if let textColor = typography.disabledTextColor {
            attributedText(attrString, for: .disabled,
                           replacingDefaultTextColor: replacingDefaultTextColor, replacingTextColor: textColor)
        }
        if let textColor = typography.highlightedTextColor {
            attributedText(attrString, for: .highlighted,
                           replacingDefaultTextColor: replacingDefaultTextColor, replacingTextColor: textColor)
        }
        if let textColor = typography.selectedTextColor {
            attributedText(attrString, for: .selected,
                           replacingDefaultTextColor: replacingDefaultTextColor, replacingTextColor: textColor)
        }
        if let backgroundColor = typography.backgroundColor {
            attributedText(attrString, for: .normal,
                           replacingDefaultBackgroundColor: replacingDefaultBackgroundColor,
                           replacingBackgroundColor: backgroundColor)
        }
    }
    
    private func attributedText(_ attrString: NSAttributedString, for state: UIControl.State,
                                replacingDefaultTextColor: Bool = false, replacingTextColor: UIColor? = nil,
                                replacingDefaultBackgroundColor: Bool = false,
                                replacingBackgroundColor: UIColor? = nil) {
        let mutableString = NSMutableAttributedString(attributedString: attrString)
        let textRange = NSRange(location: 0, length: attrString.string.count)
        mutableString.enumerateAttributes(in: textRange, options: [], using: { value, range, _ in
            update(attributedString: mutableString, with: value, in: range,
                   typographyFont: typography.font(), typographyTextColor: replacingTextColor)
        })

        if replacingDefaultTextColor {
            let defaultColor = defaultTextColor(in: mutableString)
            let replacementString = replaceTextColor(defaultColor, with: replacingTextColor, in: mutableString)
            mutableString.setAttributedString(replacementString)
        }
        
        if replacingDefaultBackgroundColor {
            let defaultColor = defaultTextColor(in: mutableString)
            let replacementString = replaceBackgroundColor(
                defaultColor,
                with: replacingBackgroundColor,
                in: mutableString)
            mutableString.setAttributedString(replacementString)
        }
        
        self.setAttributedTitle(mutableString, for: state)
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
    
}

extension UIButton: TypographyKitElement {
    
    func isAttributed() -> Bool {
        guard let attributedText = titleLabel?.attributedText else {
            return false
        }
        return isAttributed(attributedText)
    }
    
    func contentSizeCategoryDidChange(_ notification: NSNotification) {
        if let newValue = notification.userInfo?[UIContentSizeCategory.newValueUserInfoKey] as? UIContentSizeCategory {
            if let attributedText = titleLabel?.attributedText, isAttributed(attributedText) {
                self.attributedText(attributedText, style: fontTextStyle)
            } else {
                self.titleLabel?.font = self.typography.font(newValue)
            }
        }
    }
    
}

extension UIButton {
    
    func applyTitleColor(_ color: UIColor, mode: TitleColorApplyMode) {
        switch mode {
        case .all:
            UIControl.State.allCases.forEach { controlState in
                setTitleColor(color, for: controlState)
            }
        case .none:
            return
        case .normal:
            setTitleColor(color, for: .normal)
        case .whereUnspecified:
            applyTitleColorWhereNoneSpecified(color)
        }
    }
    
    private func applyTitleColorWhereNoneSpecified(_ color: UIColor) {
        let defaultButton = UIButton(type: buttonType)
        let normalStateColor = titleColor(for: .normal)
        UIControl.State.allCases.forEach { controlState in
            let defaultStateColor = defaultButton.titleColor(for: controlState)
            let currentStateColor = titleColor(for: controlState)
            if defaultStateColor == currentStateColor
                || (controlState != .normal && currentStateColor == normalStateColor) {
                setTitleColor(color, for: controlState)
            }
        }
    }
    
}
