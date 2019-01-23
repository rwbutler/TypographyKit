//
//  TypographyKitConfiguration.swift
//  TypographyKit
//
//  Created by Ross Butler on 1/22/19.
//

import Foundation

public class TypographyKitConfiguration {
    let colors: TypographyKit.Colors
    let settings: TypographyKit.Settings
    let styles: TypographyKit.Styles
    
    init(colors: TypographyKit.Colors, settings: TypographyKit.Settings, styles: TypographyKit.Styles) {
        self.colors = colors
        self.settings = settings
        self.styles = styles
    }
}
