//
//  JSONParsingService.swift
//  TypographyKit
//
//  Created by Ross Butler on 2/28/18.
//

import Foundation

struct JSONParsingService: ParsingService {
    
    func parse(_ data: Data) -> ParsingServiceResult? {
        guard let jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: [])
            as? [String: Any] else {
                return nil
        }
        return parse(jsonDictionary)
    }
    
}
