//
//  ParsingError.swift
//  TypographyKit
//
//  Created by Roger Smith on 02/08/2019.
//

indirect enum ParsingError: Error {
    case cyclicReference(values: [String])
    case invalidDynamicColor
    case invalidFormat
    case notFound(element: String)
    case invalidReference(element: String)
        
    var localizedDescription: String {
        switch self {
        case .cyclicReference(let values):
            return "Reference cycle: " + values.joined(separator: "->")
        case .invalidDynamicColor:
            return "Invalid dynamic color. Must supply at least valid 'light' variant"
        case .invalidFormat:
            return "Invalid format. Must be a string or a dynamic color dictionary"
        case .notFound(let element):
            return "Not found: \(element)"
        case .invalidReference(let element):
            return "References an invalid element: \(element)"
        }
    }
}
