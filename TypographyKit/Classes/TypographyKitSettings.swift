//
//  TypographyKitSettings.swift
//  TypographyKit
//
//  Created by Ross Butler on 1/22/19.
//

import Foundation

public class TypographyKitSettings {
    let colors: TypographyKit.Colors
    let configuration: TypographyKit.Configuration
    let styles: TypographyKit.Styles
    
    init(colors: TypographyKit.Colors, configuration: TypographyKit.Configuration, styles: TypographyKit.Styles) {
        self.colors = colors
        self.configuration = configuration
        self.styles = styles
    }
}
