//
//  StrategicParsingService.swift
//  TypographyKit
//
//  Created by Ross Butler on 13/04/2020.
//

import Foundation

struct StrategicParsingService: ParsingService {
    
    typealias ParsingStrategy = ConfigurationType
    private let strategy: ParsingStrategy
    
    init(strategy: ParsingStrategy) {
        self.strategy = strategy
    }
    
    func parse(_ data: Data) -> ParsingServiceResult? {
        let parsingImplementation: ParsingService
        switch strategy {
        case .json:
            parsingImplementation = JSONParsingService()
        case .plist:
            parsingImplementation = PropertyListParsingService()
        }
        return parsingImplementation.parse(data)
    }
    
}
