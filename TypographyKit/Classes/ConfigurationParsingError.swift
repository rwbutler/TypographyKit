//
//  ConfigurationParsingError.swift
//  TypographyKit
//
//  Created by Ross Butler on 13/04/2020.
//

import Foundation

public enum ConfigurationParsingError: Error {
    case emptyPayload
    case unexpectedFormat
}
