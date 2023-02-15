//
//  TypographyKit.swift
//  TypographyKit
//
//  Created by Ross Butler on 7/15/17.
//
//

import SwiftUI
import UIKit

// swiftlint:disable:next type_name
public typealias TK = TypographyKit

// Public interface
// swiftlint:disable:next type_body_length
public struct TypographyKit {
    
    public typealias Colors = [String: TypographyColor]
    public typealias Configuration = TypographyKitConfiguration
    public typealias Settings = TypographyKitSettings
    typealias Styles = [String: Typography]
    
    // MARK: Global state
    
    static func bundledConfigurationURL(name: String, type: ConfigurationType) -> URL? {
        let configurationURL = Bundle.main.url(forResource: name, withExtension: type.rawValue)
        return configurationURL
    }
    
    public static var buttonTitleColorApplyMode: UIButton.TitleColorApplyMode =
    TypographyKitConfiguration.default.buttons.titleColorApplyMode
    
    static var colors: Colors = {
        return settings?.colors ?? [:]
    }()
    
    public static func configurationType(configurationName: String) -> ConfigurationType {
        for configurationType in ConfigurationType.allCases
        where bundledConfigurationURL(name: configurationName, type: configurationType) != nil {
            return configurationType
        }
        return .json // Defaults to JSON.
    }
    
    public static var developmentColor: TypographyColor = TypographyKitConfiguration.default.developmentColor
    
    /// The color to be used if a color with the specified name cannot be found.
    public static var fallbackColor: TypographyColor = .clear
    
    public static var fontTextStyles: [String: Typography] = {
        return settings?.styles ?? [:]
    }()
    
    public static var isDevelopment: Bool = TypographyKitConfiguration.default.isDevelopment
    
    public static var lineBreak: NSLineBreakMode? = TypographyKitConfiguration.default.labels.lineBreakMode
    
    public static var minimumPointSize: Float? = TypographyKitConfiguration.default.minimumPointSize
    
    public static var maximumPointSize: Float? = TypographyKitConfiguration.default.maximumPointSize
    
    public static var pointStepSize: Float = TypographyKitConfiguration.default.pointStepSize
    
    public static var pointStepMultiplier: Float = TypographyKitConfiguration.default.pointStepMultiplier
    
    public static var scalingMode: ScalingMode = {
        return settings?.configuration.scalingMode ?? ScalingMode.default
    }()
    
    public static var shouldCrashIfColorNotFound: Bool = TypographyKitConfiguration.default.shouldCrashIfColorNotFound
    
    public static var shouldUseDevelopmentColors: Bool = TypographyKitConfiguration.default.shouldUseDevelopmentColors
    
    // MARK: Functions
    
    static func apply(_ settings: TypographyKitSettings?) {
        guard let settings = settings else {
            return
        }
        Self.settings = settings
        colors = settings.colors
        fontTextStyles = settings.styles
        let configuration = settings.configuration
        buttonTitleColorApplyMode = configuration.buttons.titleColorApplyMode
        developmentColor = configuration.developmentColor
        fallbackColor = configuration.fallbackColor
        isDevelopment = configuration.isDevelopment
        lineBreak = configuration.labels.lineBreakMode
        minimumPointSize = configuration.minimumPointSize
        maximumPointSize = configuration.maximumPointSize
        pointStepSize = configuration.pointStepSize
        pointStepMultiplier = configuration.pointStepMultiplier
        scalingMode = configuration.scalingMode
        shouldCrashIfColorNotFound = configuration.shouldCrashIfColorNotFound
        shouldUseDevelopmentColors = configuration.shouldUseDevelopmentColors
    }
    
    @available(iOS 13.0, *)
    public static func color(named colorName: String) -> Color {
        return tkColor(named: colorName).color
    }
    
    static func colorName(color: UIColor) -> String? {
        return colors.first(where: { $0.value.uiColor == color })?.key
    }
    
    @available(iOS 13.0, *)
    /// For use if the caller does not care about the `TypographyKitSettings` returned.
    public static func configure(with configuration: TypographyKitConfiguration = TypographyKitConfiguration.default) {
        Task {
            await configure(with: configuration)
        }
    }
    
    /// Requires iOS 13 in order to use as part of a task; otherwise must use the `await` keyword.
    @available(iOS 13.0, *)
    @discardableResult
    public static func configure(
        with configuration: TypographyKitConfiguration = TypographyKitConfiguration.default
    ) async -> TypographyKitSettings? {
        // Settings haven't been loaded therefore an initial load must be performed.
        guard let settings = Self.settings else {
            let updatedSettings = await loadSettings(configuration: configuration)
            apply(updatedSettings)
            return updatedSettings
        }
        // Settings have been loaded but configurationURL hasn't changed.
        guard settings.configuration.configurationURL != configuration.configurationURL else {
            let updatedSettings = settings.updateConfiguration(configuration)
            apply(updatedSettings)
            return updatedSettings
        }
        let updatedSettings = await loadSettings(configuration: configuration)
        apply(updatedSettings)
        return updatedSettings
    }
    
    // For use before iOS 13.0 - will be deprecated when Xcode drops support for iOS 11 & 12.
    public static func configure(
        with configuration: TypographyKitConfiguration = TypographyKitConfiguration.default,
        completion: ((TypographyKitSettings?) -> Void)? = nil
    ) {
        DispatchQueue.global(qos: .userInteractive).async {
            // Settings haven't been loaded therefore an initial load must be performed.
            guard let settings = Self.settings else {
                let updatedSettings = loadSettingsSync(configuration: configuration)
                apply(updatedSettings)
                completion?(updatedSettings)
                return
            }
            // Settings have been loaded but configurationURL hasn't changed.
            guard settings.configuration.configurationURL != configuration.configurationURL else {
                let updatedSettings = settings.updateConfiguration(configuration)
                apply(updatedSettings)
                completion?(updatedSettings)
                return
            }
            let updatedSettings = loadSettingsSync(configuration: configuration)
            apply(updatedSettings)
            completion?(updatedSettings)
        }
    }
    
    public static func refresh() {
        DispatchQueue.global(qos: .userInteractive).async {
            guard let configuration = Self.settings?.configuration else {
                return
            }
            let updatedSettings = loadSettingsSync(configuration: configuration)
            apply(updatedSettings)
        }
    }
    
    @available(iOS 13.0, *)
    public static func refresh() async {
        guard let configuration = Self.settings?.configuration else {
            return
        }
        let updatedSettings = await loadSettings(configuration: configuration)
        apply(updatedSettings)
    }
    
    public static func refresh(
        with data: Data,
        configuration: Configuration? = nil,
        completion: ((Settings?) -> Void)? = nil
    ) {
        let configuration = (configuration ?? Self.settings?.configuration) ?? TypographyKitConfiguration.default
        guard case let .success(settings) = loadSettings(from: data, configuration: configuration) else {
            completion?(nil)
            return
        }
        completion?(settings)
    }
    
    public static func tkColor(named colorName: String) -> TypographyColor {
        guard let color = colors[colorName] else {
            if isDevelopment {
                if shouldCrashIfColorNotFound {
                    fatalError("Unable to locate color named '\(colorName)' and 'shouldCrashIfColorNotFound' = 'true'.")
                } else if shouldUseDevelopmentColors {
                    return developmentColor
                } else {
                    return fallbackColor
                }
            } else {
                return fallbackColor
            }
        }
        return color
    }
    
    public static func uiColor(named colorName: String) -> UIColor {
        return tkColor(named: colorName).uiColor
    }
    
    public static func presentTypographyColors(
        delegate: TypographyKitViewControllerDelegate? = nil,
        animated: Bool = true,
        shouldRefresh: Bool = true
    ) {
        let viewController = TypographyKitColorsViewController()
        guard let presenter = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        viewController.delegate = delegate
        viewController.modalPresentationStyle = .overCurrentContext
        let navigationController = UINavigationController(rootViewController: viewController)
        let navigationSettings = TypographyKitViewController
            .NavigationSettings(
                animated: animated,
                autoClose: true,
                closeButtonAlignment: .closeButtonLeftExportButtonRight,
                isModal: true,
                isNavigationBarHidden: navigationController.isNavigationBarHidden,
                shouldRefresh: shouldRefresh
            )
        viewController.navigationSettings = navigationSettings
        if shouldRefresh {
            TypographyKit.refresh()
        }
        presenter.present(navigationController, animated: animated, completion: nil)
    }
    
    @available(iOS 9.0, *)
    public static func presentTypographyColors(
        delegate: TypographyKitViewControllerDelegate? = nil,
        navigationSettings: ViewControllerNavigationSettings
    ) {
        let viewController = TypographyKitColorsViewController()
        guard let presenter = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        viewController.delegate = delegate
        viewController.modalPresentationStyle = .overCurrentContext
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.navigationSettings = navigationSettings
        if navigationSettings.shouldRefresh {
            TypographyKit.refresh()
        }
        presenter.present(navigationController, animated: navigationSettings.animated, completion: nil)
    }
    
    /// Presents TypographyKitViewController modally.
    public static func presentTypographyStyles(
        delegate: TypographyKitViewControllerDelegate? = nil,
        animated: Bool = true,
        shouldRefresh: Bool = true
    ) {
        guard let presenter = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        let navigationSettings = TypographyKitViewController
            .NavigationSettings(
                animated: animated,
                autoClose: true,
                closeButtonAlignment: .closeButtonLeftExportButtonRight,
                isModal: true,
                isNavigationBarHidden: false,
                shouldRefresh: shouldRefresh
            )
        let viewController = typographyKitVC(navSettings: navigationSettings, delegate: delegate)
        viewController.modalPresentationStyle = .overCurrentContext
        let navigationController = UINavigationController(rootViewController: viewController)
        if navigationSettings.shouldRefresh {
            TypographyKit.refresh()
        }
        presenter.present(navigationController, animated: animated, completion: nil)
    }
    
    public static func presentTypographyStyles(
        delegate: TypographyKitViewControllerDelegate? = nil,
        navigationSettings: ViewControllerNavigationSettings
    ) {
        guard let presenter = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        let viewController = typographyKitVC(navSettings: navigationSettings, delegate: delegate)
        viewController.modalPresentationStyle = .overCurrentContext
        let navigationController = UINavigationController(rootViewController: viewController)
        
        if navigationSettings.shouldRefresh {
            TypographyKit.refresh()
        }
        presenter.present(navigationController, animated: navigationSettings.animated, completion: nil)
    }
    
    public static func pushTypographyColors(
        delegate: TypographyKitViewControllerDelegate? = nil,
        navigationController: UINavigationController,
        animated: Bool = false,
        shouldRefresh: Bool = true
    ) {
        let viewController = TypographyKitColorsViewController()
        viewController.delegate = delegate
        let navigationSettings = TypographyKitViewController
            .NavigationSettings(
                animated: animated,
                autoClose: true,
                isNavigationBarHidden: navigationController.isNavigationBarHidden,
                shouldRefresh: shouldRefresh
            )
        viewController.navigationSettings = navigationSettings
        navigationController.isNavigationBarHidden = false
        if shouldRefresh {
            TypographyKit.refresh()
        }
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    public static func pushTypographyColors(
        delegate: TypographyKitViewControllerDelegate? = nil,
        navigationController: UINavigationController,
        navigationSettings: ViewControllerNavigationSettings
    ) {
        let viewController = TypographyKitColorsViewController()
        viewController.delegate = delegate
        viewController.navigationSettings = navigationSettings
        navigationController.isNavigationBarHidden = false
        if navigationSettings.shouldRefresh {
            TypographyKit.refresh()
        }
        navigationController.pushViewController(viewController, animated: navigationSettings.animated)
    }
    
    /// Allows TypographyKitViewController to be pushed onto a navigation stack
    public static func pushTypographyStyles(
        delegate: TypographyKitViewControllerDelegate? = nil,
        navigationController: UINavigationController,
        animated: Bool = false,
        shouldRefresh: Bool = true
    ) {
        let navigationSettings = TypographyKitViewController
            .NavigationSettings(
                animated: animated,
                autoClose: true,
                isNavigationBarHidden: navigationController.isNavigationBarHidden,
                shouldRefresh: shouldRefresh
            )
        let viewController = typographyKitVC(navSettings: navigationSettings, delegate: delegate)
        navigationController.isNavigationBarHidden = false
        if navigationSettings.shouldRefresh {
            TypographyKit.refresh()
        }
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    public static func pushTypographyStyles(
        delegate: TypographyKitViewControllerDelegate? = nil,
        navigationController: UINavigationController,
        navigationSettings: ViewControllerNavigationSettings
    ) {
        let viewController = typographyKitVC(navSettings: navigationSettings, delegate: delegate)
        navigationController.isNavigationBarHidden = false
        if navigationSettings.shouldRefresh {
            TypographyKit.refresh()
        }
        navigationController.pushViewController(viewController, animated: navigationSettings.animated)
    }
    
    static func typographyKitVC(navSettings: ViewControllerNavigationSettings,
                                delegate: TypographyKitViewControllerDelegate?) -> TypographyKitViewController {
        let typographyKitViewController = TypographyKitViewController(style: .plain)
        typographyKitViewController.delegate = delegate
        typographyKitViewController.navigationSettings = navSettings
        return typographyKitViewController
    }
}

// Private properties & functions
private extension TypographyKit {
    private static var cachedConfigurationURL: URL? {
        let configuration = Self.settings?.configuration
        guard let configurationName = configuration?.configurationName,
              let configurationType = configuration?.configurationType else {
            return nil
        }
        return try? FileManager.default
            .url(
                for: .cachesDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            ).appendingPathComponent("\(configurationName).\(configurationType.rawValue)")
    }
    
    static var settings: TypographyKitSettings?
    
    @available(iOS 13.0, *)
    static func loadSettings(
        configuration: TypographyKitConfiguration
    ) async -> TypographyKitSettings? {
        guard let configurationURL = configuration.configurationURL, let data = try? Data(contentsOf: configurationURL) else {
            // Data not received - load from cache.
            guard case let .success(model) = loadSettings(from: nil, configuration: configuration) else {
                return nil
            }
            return model
        }
        guard case let .success(model) = loadSettings(from: data, configuration: configuration) else {
            return nil
        }
        return model
    }
    
    static func loadSettingsSync(
        configuration: TypographyKitConfiguration
    ) -> TypographyKitSettings? {
        guard let configurationURL = configuration.configurationURL, let data = try? Data(contentsOf: configurationURL) else {
            // Data not received - load from cache.
            guard case let .success(model) = loadSettings(from: nil, configuration: configuration) else {
                return nil
            }
            return model
        }
        guard case let .success(model) = loadSettings(from: data, configuration: configuration) else {
            return nil
        }
        return model
    }
    
    static func loadSettings(from data: Data?, configuration: Configuration) -> ConfigurationParsingResult {
        guard let data = data else {
            guard let cachedConfigurationURL = cachedConfigurationURL,
                  let cachedData = try? Data(contentsOf: cachedConfigurationURL) else {
                return .failure(.emptyPayload)
            }
            return parseConfiguration(data: cachedData, configuration: configuration)
        }
        if let cachedConfigurationURL = cachedConfigurationURL {
            try? data.write(to: cachedConfigurationURL)
        }
        return parseConfiguration(data: data, configuration: configuration)
    }
    
    private static func parseConfiguration(
        data: Data,
        configuration: TypographyKitConfiguration
    ) -> ConfigurationParsingResult {
        let parsingService = StrategicConfigurationParsingService(strategy: configuration.configurationType)
        return parsingService.parse(data, with: configuration)
    }
    // swiftlint:disable:next file_length
}
