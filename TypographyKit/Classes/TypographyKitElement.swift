//
//  TypographyKitElement.swift
//  TypographyKit
//
//  Created by Ross Butler on 8/21/19.
//

import Foundation

protocol TypographyKitElement {}
extension UIButton: TypographyKitElement {}
extension UILabel: TypographyKitElement {}
extension UITextField: TypographyKitElement {}
extension UITextView: TypographyKitElement {}

extension TypographyKitElement {
    
    /// Updates a given `NSMutableAttributedString` with the given attributes and typography in the specified range.
    func update(attributedString: NSMutableAttributedString, with attrs: [NSAttributedString.Key: Any],
                in range: NSRange, and typography: Typography) {
        let fontAttribute = attrs[.font] as? UIFont
        if let font = fontAttribute ?? typography.font() {
            let fontSize = typography.font()?.pointSize ?? font.pointSize
            if let fontWithSize = UIFont(name: font.fontName, size: fontSize) {
                // The font size of the typography size should be the priority in order to support Dynamic Type.
                attributedString.removeAttribute(.font, range: range)
                attributedString.addAttribute(.font, value: fontWithSize, range: range)
            }
        }
        let textColorAttribute = attrs[.foregroundColor] as? UIColor
        if let textColor = textColorAttribute ?? typography.textColor {
            attributedString.removeAttribute(.foregroundColor, range: range)
            attributedString.addAttribute(.foregroundColor, value: textColor, range: range)
        }
    }
    
}
