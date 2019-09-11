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
        let fontAttribute = attrs[.font] as? UIFont
        if let font = fontAttribute ?? typography.font() {
            let fontSize = typography.font()?.pointSize ?? font.pointSize
            let fontWithSize = font.withSize(fontSize)
            // The font size of the typography size should be the priority in order to support Dynamic Type.
            attributedString.removeAttribute(.font, range: range)
            attributedString.addAttribute(.font, value: fontWithSize, range: range)
        }
        let textColorAttribute = attrs[.foregroundColor] as? UIColor
        if let textColor = textColorAttribute ?? typography.textColor {
            attributedString.removeAttribute(.foregroundColor, range: range)
            attributedString.addAttribute(.foregroundColor, value: textColor, range: range)
        }
    }
    
}
