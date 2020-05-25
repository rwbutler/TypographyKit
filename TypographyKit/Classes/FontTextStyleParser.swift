//
//  FontTextStyleParser.swift
//  TypographyKit
//
//  Created by Roger Smith on 02/08/2019.
//

import UIKit

struct FontTextStyleParser {
    
    typealias TextStyleResult = Result<Typography, ParsingError>
    
    let textStyles: FontTextStyleEntries
    let colorEntries: TypographyColors
    var typographyFontStyles: TypographyStyles = [:]
    var backTrace: [String] = []
    var invalidStyles: [String: ParsingError] = [:]
    
    mutating func parseFonts() -> TypographyStyles {
        textStyles.forEach { (key, value) in
            backTrace = []
            parse(key, value)
        }
        return typographyFontStyles
    }
    
}

private extension FontTextStyleParser {
    
    mutating func parse(_ key: String, _ value: [String: Any]) {
        //Already Parsed
        if typographyFontStyles[key] != nil { return }
        
        //Already found to be invalid
        if invalidStyles[key] != nil { return }
            
        backTrace.append(key)
        switch parseFontTextStyle(key, value) {
        case .success(let color):
            backTrace.removeLast()
            typographyFontStyles[key] = color
        case .failure(let error):
            backTrace.removeLast()
            invalidStyles[key] = error
            LoggingService.log(error: error, key: key)
        }
    }
    
    mutating func parseFontTextStyle(_ key: String, _ fontTextStyle: [String: Any]) -> TextStyleResult {
        let newStyle = typography(key, fontTextStyle)
        
        // If does not extend, return new style
        guard let existingStyleName = fontTextStyle[ConfigurationKey.extends.rawValue] as? String else {
            return .success(newStyle)
        }
        
        // Check for a cyclic reference
        if let lastIndex = backTrace.lastIndex(of: existingStyleName), backTrace.count > 1 {
            let cycle = Array(backTrace[lastIndex...])
            return .failure(.cyclicReference(values: cycle))
        }
        
        // Extending from another style
        if let existingStyle = textStyles[existingStyleName] {
            parse(existingStyleName, existingStyle)
            
            guard let fontToExtend = typographyFontStyles[existingStyleName] else {
                return .failure(.invalidReference(element: existingStyleName))
            }
            
            let extendedFont = extend(fontToExtend, with: newStyle)
            return .success(extendedFont)
        }
        
        return .failure(.notFound(element: key))
    }
    
}

private extension FontTextStyleParser {
    
    func typography(_ key: String, _ fontTextStyle: [String: Any]) -> Typography {
        let fontName = fontTextStyle[ConfigurationKey.fontName.rawValue] as? String
        let maxPointSize = fontTextStyle[ConfigurationKey.maximumPointSize.rawValue] as? Float
        let minPointSize = fontTextStyle[ConfigurationKey.minimumPointSize.rawValue] as? Float
        let pointSize = fontTextStyle[ConfigurationKey.pointSize.rawValue] as? Float
        var textColor: UIColor?
        if let textColorName = fontTextStyle[ConfigurationKey.textColor.rawValue] as? String {
            textColor = colorEntries[textColorName]?.uiColor ?? TypographyColor(string: textColorName)?.uiColor
        }
        var disabledTextColor: UIColor?
        if let textColorName = fontTextStyle[ConfigurationKey.disabledTextColor.rawValue] as? String {
            disabledTextColor = colorEntries[textColorName]?.uiColor ?? TypographyColor(string: textColorName)?.uiColor
        }
        var highlightedTextColor: UIColor?
        if let textColorName = fontTextStyle[ConfigurationKey.highlightedTextColor.rawValue] as? String {
            // swiftlint:disable line_length
            highlightedTextColor = colorEntries[textColorName]?.uiColor ?? TypographyColor(string: textColorName)?.uiColor
        }
        var selectedTextColor: UIColor?
        if let textColorName = fontTextStyle[ConfigurationKey.selectedTextColor.rawValue] as? String {
            selectedTextColor = colorEntries[textColorName]?.uiColor ?? TypographyColor(string: textColorName)?.uiColor
        }
        var tintColor: UIColor?
        if let tintColorName = fontTextStyle[ConfigurationKey.tintColor.rawValue] as? String {
            tintColor = colorEntries[tintColorName]?.uiColor ?? TypographyColor(string: tintColorName)?.uiColor
        }
        var letterCase: LetterCase?
        if let letterCaseName = fontTextStyle[ConfigurationKey.letterCase.rawValue] as? String {
            letterCase = LetterCase(rawValue: letterCaseName)
        }
        var scalingMode: ScalingMode?
        if let scalingModeName = fontTextStyle[ConfigurationKey.scalingMode.rawValue] as? String {
            scalingMode = ScalingMode(rawValue: scalingModeName)
        }
        return Typography(name: key, fontName: fontName, fontSize: pointSize, letterCase: letterCase,
                          maximumPointSize: maxPointSize, minimumPointSize: minPointSize, scalingMode: scalingMode,
                          textColor: textColor, disabledTextColor: disabledTextColor,
                          highlightedTextColor: highlightedTextColor, selectedTextColor: selectedTextColor,
                          tintColor: tintColor)
    }
    
    /// Extends the original Typography style with another style, replacing properties of the
    /// original with those of the new style where defined.
    func extend(_ original: Typography, with modified: Typography) -> Typography {
        let newFace = modified.fontName ?? original.fontName
        let newSize = modified.pointSize ?? original.pointSize
        let newMaxSize = modified.maximumPointSize ?? original.maximumPointSize
        let newMinSize = modified.minimumPointSize ?? original.minimumPointSize
        let newCase = modified.letterCase ?? original.letterCase
        let newColor = modified.textColor ?? original.textColor
        let newDisabledColor = modified.disabledTextColor ?? original.disabledTextColor
        let newHighlightedColor = modified.highlightedTextColor ?? original.highlightedTextColor
        let newSelectedColor = modified.selectedTextColor ?? original.selectedTextColor
        let newTintColor = modified.tintColor ?? original.tintColor
        let newScalingMode = modified.scalingMode ?? original.scalingMode
        return Typography(name: modified.name, fontName: newFace, fontSize: newSize, letterCase: newCase,
                          maximumPointSize: newMaxSize, minimumPointSize: newMinSize,
                          scalingMode: newScalingMode, textColor: newColor, disabledTextColor: newDisabledColor,
                          highlightedTextColor: newHighlightedColor, selectedTextColor: newSelectedColor,
                          tintColor: newTintColor)
    }
    
}
