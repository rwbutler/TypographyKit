//
//  TypographyKit.swift
//  TypographyKit
//
//  Created by Ross Butler on 7/15/17.
//
//

public struct TypographyKit {
    fileprivate static let parsingService: ParsingService = PropertyListParsingService()
    fileprivate static let configurationName: String = "TypographyKit"
    fileprivate static let configurationType: ConfigurationType = .plist

    public static var pointStepSize: Float = 2.0
    public static var pointStepMultiplier: Float = 1.0
    // Lazily-initialised properties
    public static var colors: [String: UIColor] = {
        return configuration()?.typographyColors ?? [:]
    }()
    public static var fontTextStyles: [String: Typography] = {
        return configuration()?.typographyStyles ?? [:]
    }()
}

private extension TypographyKit {
    static func configuration() -> ParsingServiceResult? {
        if let data = try? Data(contentsOf: configurationURL()) {
            let result = parsingService.parse(data)
            if let result = result {
                pointStepSize = result.configurationSettings.pointStepSize
                pointStepMultiplier = result.configurationSettings.pointStepMultiplier
                colors = result.typographyColors
                fontTextStyles = result.typographyStyles
            }
            return result
        }
        return nil
    }
    static func configurationURL () -> URL {
        // Hard-coded so we know this will unwrap
        return Bundle.main.url(forResource: self.configurationName,
                               withExtension: self.configurationType.rawValue)!
    }
}
