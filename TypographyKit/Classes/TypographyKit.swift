//
//  TypographyKit.swift
//  TypographyKit
//
//  Created by Ross Butler on 7/15/17.
//
//

import UIKit

// Public interface
public struct TypographyKit {
    
    typealias Colors = [String: UIColor]
    public typealias Configuration = TypographyKitConfiguration
    typealias Settings = ConfigurationSettings
    typealias Styles = [String: Typography]
    
    // MARK: Global state
    public static var buttonTitleColorApplyMode: UIButton.TitleColorApplyMode = {
        configuration?.configurationSettings.buttons.titleColorApplyMode ?? .whereUnspecified
    }()
    
    public static var colors: [String: UIColor] = {
        return configuration?.typographyColors ?? [:]
    }()
    
    public static var configurationURL: URL? = bundledConfigurationURL() {
        didSet { // detect configuration format by extension
            guard let lastPathComponent = configurationURL?.lastPathComponent.lowercased() else { return }
            for configurationType in ConfigurationType.allCases {
                if lastPathComponent.contains(configurationType.rawValue.lowercased()) {
                    TypographyKit.configurationType = configurationType
                    break
                }
            }
            refresh()
        }
    }
    
    public static var configurationType: ConfigurationType = {
        for configurationType in ConfigurationType.allCases {
            if bundledConfigurationURL(configurationType) != nil {
                return configurationType
            }
        }
        return .json // default
    }()
    
    public static var fontTextStyles: [String: Typography] = {
        return configuration?.typographyStyles ?? [:]
    }()
    
    public static var lineBreak: NSLineBreakMode? = {
        return configuration?.configurationSettings.labels.lineBreak
    }()
    
    public static var minimumPointSize: Float? = {
        return configuration?.configurationSettings.minimumPointSize
    }()
    
    public static var maximumPointSize: Float? = {
        return configuration?.configurationSettings.maximumPointSize
    }()
    
    public static var pointStepSize: Float = {
        return configuration?.configurationSettings.pointStepSize ?? 2.0
    }()
    
    public static var pointStepMultiplier: Float = {
        return configuration?.configurationSettings.pointStepMultiplier ?? 1.0
    }()
    
    public static var scalingMode: ScalingMode = {
        return configuration?.configurationSettings.scalingMode ?? .fontMetricsWithSteppingFallback
    }()
    
    // MARK: Functions
    internal static func colorName(color: UIColor) -> String? {
        return colors.first(where: { $0.value == color })?.key 
    }
    
    public static func refresh(_ completion: ((Configuration?) -> Void)? = nil) {
        configuration = loadConfiguration()
        guard let colors = configuration?.typographyColors,
            let settings = configuration?.configurationSettings,
            let styles = configuration?.typographyStyles else {
                completion?(nil)
                return
        }
        let config = Configuration(colors: colors, settings: settings, styles: styles)
        completion?(config)
    }
    
    public static func refreshWithData(_ data: Data, completion: ((Configuration?) -> Void)? = nil) {
        guard case let .success(configuration) = loadConfigurationWithData(data) else {
            completion?(nil)
            return
        }
        let colors = configuration.typographyColors
        let settings = configuration.configurationSettings
        let styles = configuration.typographyStyles
        let config = Configuration(colors: colors, settings: settings, styles: styles)
        completion?(config)
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
    
    static var configuration: ConfigurationModel? = loadConfiguration()
    
    static let configurationName: String = "TypographyKit"
    
    static func bundledConfigurationURL(_ configType: ConfigurationType = TypographyKit.configurationType) -> URL? {
        return Bundle.main.url(forResource: configurationName, withExtension: configType.rawValue)
    }
    
    static func loadConfiguration() -> ConfigurationModel? {
        guard let configurationURL = configurationURL,
            let data = try? Data(contentsOf: configurationURL) else {
                guard case let .success(model) = loadConfigurationWithData(nil) else {
                    return nil
                }
                return model
        }
        guard case let .success(model) = loadConfigurationWithData(data) else {
            return nil
        }
        return model
    }
    
    static func loadConfigurationWithData(_ data: Data?) -> ConfigurationParsingResult {
        guard let data = data else {
            guard let cachedConfigurationURL = cachedConfigurationURL,
                let cachedData = try? Data(contentsOf: cachedConfigurationURL) else {
                    guard let bundledConfigurationURL = bundledConfigurationURL(),
                        let bundledData = try? Data(contentsOf: bundledConfigurationURL) else {
                            return .failure(.emptyPayload)
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
    
    private static func parseConfiguration(data: Data) -> ConfigurationParsingResult {
        let parsingService = StrategicConfigurationParsingService(strategy: configurationType)
        return parsingService.parse(data)
    }
}
