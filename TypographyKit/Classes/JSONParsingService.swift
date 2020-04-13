//
//  JSONParsingService.swift
//  TypographyKit
//
//  Created by Ross Butler on 2/28/18.
//

import Foundation

struct JSONParsingService: ConfigurationParsingService {
    
    func parse(_ data: Data) -> ConfigurationParsingResult {
        guard !data.isEmpty else {
            return .failure(.emptyPayload)
        }
        guard let jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: [])
            as? [String: Any] else {
                return .failure(.unexpectedFormat)
        }
        return parse(jsonDictionary)
    }
    
}
