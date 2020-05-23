//
//  TypographyKitElement.swift
//  TypographyKit
//
//  Created by Ross Butler on 8/21/19.
//

import Foundation
import UIKit

@objc protocol TypographyKitElement {
    @objc func contentSizeCategoryDidChange(_ notification: NSNotification)
    func isAttributed() -> Bool
}

extension TypographyKitElement {
    
    func addObserver() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIContentSizeCategory.didChangeNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(contentSizeCategoryDidChange(_:)),
                                       name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    /// Determines the most used text color in the provided `NSAttributedString`.
    func defaultTextColor(in attributedString: NSAttributedString) -> UIColor {
        var colorAttributes: [UIColor: Int] = [:]
        let strRange = NSRange(location: 0, length: attributedString.string.count)
        attributedString.enumerateAttributes(in: strRange, options: [], using: { value, _, _ in
            if let colorAttribute = value[.foregroundColor] as? UIColor {
                if var count = colorAttributes[colorAttribute] {
                    count += 1
                    colorAttributes[colorAttribute] = count
                } else {
                    colorAttributes[colorAttribute] = 1
                }
            }
        })
        var defaultColorEntry = (color: UIColor.black, count: 0)
        for (color, colorCount) in colorAttributes where colorCount > defaultColorEntry.count {
            defaultColorEntry = (color: color, count: colorCount)
        }
        return defaultColorEntry.color
    }
    
    func replaceTextColor(_ color: UIColor, with newColor: UIColor?,
                          in attributedString: NSAttributedString) -> NSAttributedString {
        guard let newColor = newColor else {
            return attributedString
        }
        let mutableString = NSMutableAttributedString(attributedString: attributedString)
        let textRange = NSRange(location: 0, length: attributedString.string.count)
        mutableString.enumerateAttributes(in: textRange, options: [], using: { value, range, _ in
            if let textColorAttribute = value[.foregroundColor] as? UIColor,
                textColorAttribute == color {
                mutableString.removeAttribute(.foregroundColor, range: range)
                mutableString.addAttribute(.foregroundColor, value: newColor, range: range)
            }
        })
        return mutableString
    }
    
    /// Determines whether or not the element with the given `attributedText` value is `plain` or `attributed`.
    func isAttributed(_ attributedText: NSAttributedString?) -> Bool {
        guard let attributedText = attributedText, !attributedText.string.isEmpty else {
            return false
        }
        var range = NSRange()
        attributedText.attributes(at: 0, effectiveRange: &range)
        return attributedText.string.count != range.length
        
    }
    
    /// Updates a given `NSMutableAttributedString` with the given attributes and typography in the specified range.
    func update(attributedString: NSMutableAttributedString, with attrs: [NSAttributedString.Key: Any],
                in range: NSRange, and typography: Typography) {
        update(attributedString: attributedString, with: attrs, in: range,
               typographyFont: typography.font(), typographyTextColor: typography.textColor)
    }
    
    func update(attributedString: NSMutableAttributedString, with attrs: [NSAttributedString.Key: Any],
                in range: NSRange, typographyFont: UIFont?, typographyTextColor: UIColor?) {
        let fontAttribute = attrs[.font] as? UIFont
        if let font = fontAttribute ?? typographyFont {
            let fontSize = typographyFont?.pointSize ?? font.pointSize
            let fontWithSize = font.withSize(fontSize)
            // The font size of the typography size should be the priority in order to support Dynamic Type.
            attributedString.removeAttribute(.font, range: range)
            attributedString.addAttribute(.font, value: fontWithSize, range: range)
        }
        let textColorAttribute = attrs[.foregroundColor] as? UIColor
        if let textColor = textColorAttribute ?? typographyTextColor {
            attributedString.removeAttribute(.foregroundColor, range: range)
            attributedString.addAttribute(.foregroundColor, value: textColor, range: range)
        }
    }
    
}
