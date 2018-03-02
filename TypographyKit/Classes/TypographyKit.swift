//
//  TypographyKit.swift
//  TypographyKit
//
//  Created by Ross Butler on 7/15/17.
//
//

// Public interface
public struct TypographyKit {
    public static var configurationURL: URL? = bundledConfigurationURL() {
        didSet { // detect configuration format by extension
            guard let lastPathComponent = configurationURL?.lastPathComponent.lowercased() else { return }
            for configurationType in ConfigurationType.values {
                if lastPathComponent.contains(configurationType.rawValue.lowercased()) {
                    TypographyKit.configurationType = configurationType
                    return
                }
            }
        }
    }

    // Lazily-initialised properties
    public static var configurationType: ConfigurationType = {
        for configurationType in ConfigurationType.values {
            if bundledConfigurationURL(configurationType) != nil {
                return configurationType
            }
        }
        return .plist // default
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

    public static func refresh() {
        configuration = loadConfiguration()
    }
}

// Private properties & functions
private extension TypographyKit {
    private static var cachedConfigurationURL: URL? {
        return try? FileManager.default
            .url(for: .cachesDirectory,
                 in: .userDomainMask,
                 appropriateFor: nil,
                 create: true)
            .appendingPathComponent("\(configurationName).\(configurationType.rawValue)")
    }

    static var configuration: ParsingServiceResult? = loadConfiguration()

    static let configurationName: String = "TypographyKit"

    static func bundledConfigurationURL(_ configType: ConfigurationType = TypographyKit.configurationType) -> URL? {
        return Bundle.main.url(forResource: configurationName, withExtension: configType.rawValue)
    }

    static func loadConfiguration() -> ParsingServiceResult? {
        guard let configurationURL = configurationURL,
            let data = try? Data(contentsOf: configurationURL) else {
                guard let cachedConfigurationURL = cachedConfigurationURL,
                    let cachedData = try? Data(contentsOf: cachedConfigurationURL) else {
                        guard let bundledConfigurationURL = bundledConfigurationURL(),
                            let bundledData = try? Data(contentsOf: bundledConfigurationURL) else {
                            return nil
                        }
                        return parseConfiguration(data: bundledData)
                }
                return parseConfiguration(data: cachedData)
        }
        if let cachedConfigurationURL = cachedConfigurationURL {
            try? data.write(to: cachedConfigurationURL)
        }
        return parseConfiguration(data: data)
    }

    private static func parseConfiguration(data: Data) -> ParsingServiceResult? {
        var parsingService: ParsingService? = nil
        switch configurationType {
        case .plist:
            parsingService = PropertyListParsingService()
        case .json:
            parsingService = JSONParsingService()
        }
        return parsingService?.parse(data)
    }
}
