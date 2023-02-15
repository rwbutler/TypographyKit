//
//  StrategicParsingService.swift
//  TypographyKit
//
//  Created by Ross Butler on 13/04/2020.
//

import Foundation

struct StrategicConfigurationParsingService: ConfigurationParsingService {
    
    typealias ParsingStrategy = ConfigurationType
    private let strategy: ParsingStrategy
    
    init(strategy: ParsingStrategy) {
        self.strategy = strategy
    }
    
    func parse(_ data: Data, with existingConfig: TypographyKitConfiguration) -> ConfigurationParsingResult {
        let parsingImplementation: ConfigurationParsingService
        switch strategy {
        case .json:
            parsingImplementation = JSONParsingService()
        case .plist:
            parsingImplementation = PropertyListParsingService()
        }
        return parsingImplementation.parse(data, with: existingConfig)
    }
    
}
