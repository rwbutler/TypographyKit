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

    // Lazily-initialised properties
    private static var configuration: ParsingServiceResult? = {
        if let data = try? Data(contentsOf: configurationURL()) {
            return parsingService.parse(data)
        }
        return nil
    }()
    public static var pointStepSize: Float = {
        return configuration?.configurationSettings.pointStepSize ?? 2.0
    }()
    public static var pointStepMultiplier: Float = {
        return configuration?.configurationSettings.pointStepMultiplier ?? 1.0
    }()
    public static var colors: [String: UIColor] = {
        return configuration?.typographyColors ?? [:]
    }()
    public static var fontTextStyles: [String: Typography] = {
        return configuration?.typographyStyles ?? [:]
    }()
}

private extension TypographyKit {
    static func configurationURL () -> URL {
        // Hard-coded so we know this will unwrap
        return Bundle.main.url(forResource: self.configurationName,
                               withExtension: self.configurationType.rawValue)!
    }
}
