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
        guard let textColor = Typography(for: style, scalingMode: scalingMode)?.textColor else {
            return nil
        }
        return Color(textColor)
    }
    
    var font: Font? {
        guard let font = Typography(for: style, scalingMode: scalingMode)?.font() else {
            return nil
        }
        return Font(font as CTFont)
    }
    
    let scalingMode: ScalingMode?
    let style: UIFont.TextStyle
    
    func body(content: Content) -> some View {
        return content
            .ifLet(font) { content, font in
                content.font(font) }
            .ifLet(color) { view, color in
                view.foregroundColor(color)
            }
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
    func typography(style: UIFont.TextStyle, scalingMode: ScalingMode? = .disabled) -> some View {
        return modifier(TypographyStyle(scalingMode: scalingMode, style: style))
    }
}

#endif
