//
//  TypographyInterfaceStyle.swift
//  TypographyKit
//
//  Created by Roger Smith on 02/08/2019.
//

public enum TypographyInterfaceStyle: String, CaseIterable {
    case light
    case dark
    
    @available(iOS 12, *)
    init(style: UIUserInterfaceStyle) {
        switch style {
        case .light: self = .light
        case .dark: self = .dark
        case .unspecified: self = .light
        @unknown default: self = .light
        }
    }
    
    @available(iOS 12, *)
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .light: return .light
        case .dark: return .dark
        }
    }
}
