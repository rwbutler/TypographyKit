//
//  ViewAdditions.swift
//  TypographyKit
//
//  Created by Ross Butler on 22/02/2020.
//

#if (arch(x86_64) || arch(arm64)) && canImport(SwiftUI)

import Foundation
import SwiftUI

@available(iOS 13, macCatalyst 13, tvOS 13, watchOS 6, *)
private struct TypographyStyle: ViewModifier {
    
    @Environment(\.sizeCategory) var sizeCategory
    
    var color: Color? {
        guard let textColor = Typography(for: style)?.textColor else {
            return nil
        }
        return Color(textColor)
    }
    
    var font: Font? {
        guard let font = Typography(for: style)?.font() else {
            return nil
        }
        return Font.custom(font.fontName, size: font.pointSize)
    }
    
    var style: UIFont.TextStyle
    
    func body(content: Content) -> some View {
        return content
            .ifLet(font) { $0.font($1) }
            .ifLet(color) { $0.foregroundColor($1) }
    }
    
}

@available(iOS 13, *)
extension View {
    @ViewBuilder
    func ifLet<V, Transform: View>(
        _ value: V?,
        transform: (Self, V) -> Transform
    ) -> some View {
        if let value = value {
            transform(self, value)
        } else {
            self
        }
    }
}

@available(iOS 13, macCatalyst 13, tvOS 13, watchOS 6, *)
public extension View {
    func typography(style: UIFont.TextStyle) -> some View {
        return modifier(TypographyStyle(style: style))
    }
}

#endif
