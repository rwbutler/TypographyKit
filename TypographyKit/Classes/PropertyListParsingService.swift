//
//  PropertyListParsingService.swift
//  TypographyKit
//
//  Created by Ross Butler on 7/15/17.
//
//

struct PropertyListParsingService: ParsingService {
    
    func parse(_ data: Data) -> ParsingServiceResult? {
        guard let plistDictionary = ((try? PropertyListSerialization.propertyList(from: data, options: [],
                                                                                format: nil)
            as? [String: Any]) as [String: Any]??),
            let result = plistDictionary else {
                return nil
        }
        return parse(result)
    }
    
}
