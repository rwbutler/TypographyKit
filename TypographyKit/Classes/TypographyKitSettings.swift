//
//  TypographyKitSettings.swift
//  TypographyKit
//
//  Created by Ross Butler on 1/22/19.
//

import Foundation

public struct TypographyKitSettings {
    let colors: TypographyKit.Colors
    let configuration: TypographyKit.Configuration
    let styles: TypographyKit.Styles
    
    init(colors: TypographyKit.Colors, configuration: TypographyKit.Configuration, styles: TypographyKit.Styles) {
        self.colors = colors
        self.configuration = configuration
        self.styles = styles
    }
    
    private func clone(
        colors: TypographyKit.Colors? = nil,
        configuration: TypographyKit.Configuration? = nil,
        styles: TypographyKit.Styles? = nil
    ) -> Self {
        return .init(
            colors: colors ?? self.colors,
            configuration: configuration ?? self.configuration,
            styles: styles ?? self.styles
        )
    }
    
    public func updateConfiguration(_ configuration: TypographyKit.Configuration) -> Self {
        clone(configuration: configuration)
    }
}
