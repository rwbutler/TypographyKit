//
//  PropertyListParsingService.swift
//  TypographyKit
//
//  Created by Ross Butler on 7/15/17.
//
//

import Foundation

struct PropertyListParsingService: ConfigurationParsingService {
    
    func parse(_ data: Data, with existingConfig: TypographyKitConfiguration) -> ConfigurationParsingResult {
        guard !data.isEmpty else {
            return .failure(.emptyPayload)
        }
        guard let plistDictionary = ((try? PropertyListSerialization.propertyList(from: data, options: [],
                                                                                format: nil)
            as? [String: Any]) as [String: Any]??),
            let result = plistDictionary else {
                return .failure(.unexpectedFormat)
        }
        return parse(result, with: existingConfig)
    }
    
}
