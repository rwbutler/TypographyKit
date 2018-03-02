//
//  ConfigurationType.swift
//  TypographyKit
//
//  Created by Ross Butler on 7/15/17.
//
//

public enum ConfigurationType: String {
    case plist
    case json

    static var values: [ConfigurationType] {
        return [.json, .plist]
    }
}
