//
//  ColorParser.swift
//  TypographyKit
//
//  Created by Roger Smith on 02/08/2019.
//

struct ColorParser {
    
    typealias ColorResult = Result<TypographyColor, ParsingError>
    
    let colors: [String: Any]
    var typographyColors: [String: TypographyColor] = [:]
    static let shades = ["light", "lighter", "lightest", "dark", "darker", "darkest"]
    
    var backTrace: [String] = []
    var invalidColors: [String: ParsingError] = [:]
    
    mutating func parseColors() -> TypographyColors {
        colors.forEach { (key, value) in
            backTrace = []
            parseCol(key: key, value: value)
        }
        return typographyColors
    }
    
}

private extension ColorParser {
    
    mutating func parseCol(key: String, value: Any?) {
        if typographyColors[key] != nil { return } // Already Parsed
    
        if invalidColors[key] != nil { return } // Already found to be invalid
        
        backTrace.append(key)
        switch parseColor(key, value) {
        case .success(let color):
            backTrace.removeLast()
            typographyColors[key] = color
        case .failure(let error):
            backTrace.removeLast()
            invalidColors[key] = error
            LoggingService.log(error: error, key: key)
        }
    }
    
    mutating func parseColor(_ key: String, _ value: Any?) -> ColorResult {
        switch value {
        case let dynamicDictionary as [String: String]:
            return parseDynamicColor(dynamicDictionary)
        case let value as String:
            return parseColorString(value)
        case .some:
            return .failure(.invalidFormat)
        case .none:
            return .failure(.notFound(element: key))
        }
    }
    
    mutating func parseColorString(_ value: String) -> ColorResult {
        // Check if value is already found to be invalid
        if invalidColors[value] != nil {
            return .failure(.invalidReference(element: value))
        }
        
        // Check for a cyclic reference
        if let lastIndex = backTrace.lastIndex(of: value), backTrace.count > 1 {
            let cycle = Array(backTrace[lastIndex...])
            return .failure(.cyclicReference(values: cycle))
        }
        
        // Check if it is an already parsed color or
        if let standardColor = typographyColors[value] {
            return .success(standardColor)
        }
        
        // Check if color is aliased version of another color
        if let aliasValue = colors[value] {
            if let color = parseAliasedColor(value, aliasValue) {
                return .success(color)
            }
            
            return .failure(.invalidReference(element: value))
        }
        
        if let standardColor = TypographyColor(string: value) {
            return .success(standardColor)
        }
        
        // Check if colour is a shade of another existing color
        #if !TYPOGRAPHYKIT_UICOLOR_EXTENSION
        if let shadedColor = parseShadedColor(value: value) {
            return .success(shadedColor)
        }
        #endif
        
        return .failure(.notFound(element: value))
    }
    
}

// Shades
private extension ColorParser {
    
    mutating func parseShadedColor(value: String) -> TypographyColor? {
        let colorWords = value.split(separator: " ")
        guard let shade = colorWords.first(where: { ColorParser.shades.contains(String($0)) }) else {
            return nil
        }
        let newValue = value.replacingOccurrences(of: shade, with: "")
        let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
        let result: ColorResult = parseColorString(trimmed).map {
            .shade(shade: String(shade), color: $0)
        }
        return try? result.get()
    }
    
}

// Aliased Colors
private extension ColorParser {
    
    mutating func parseAliasedColor(_ key: String, _ value: Any) -> TypographyColor? {
        parseCol(key: key, value: value)
        return typographyColors[key]
    }
    
}

// Dynamic Colors
private extension ColorParser {
    
    mutating func parseDynamicColor(_ colorDictionary: [String: String]) -> ColorResult {
        var colors: [TypographyInterfaceStyle: TypographyColor] = [:]
        
        colorDictionary.forEach { (styleName, value) in
            guard let style = TypographyInterfaceStyle(rawValue: styleName.lowercased()) else { return }
            switch parseColorString(value) {
            case .success(let color):
                colors[style] = color
            case .failure(let error):
                LoggingService.log(error: error, key: styleName)
            }
        }
        
        guard colors[.light] != nil else {
            return .failure(ParsingError.invalidDynamicColor)
        }
        return .success(.dynamicColor(colors: colors))
    }
    
}
