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
    public static var buttonTitleColorApplyMode: UIButton.TitleColorApplyMode = {
        settings?.configuration.buttons.titleColorApplyMode ?? .whereUnspecified
    }()
    
    static var colors: Colors = {
        return settings?.colors ?? [:]
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
    
    /// The color to be used if a color with the specified name cannot be found.
    public static var fallbackColor: TypographyColor = .clear
    
    public static var fontTextStyles: [String: Typography] = {
        return settings?.styles ?? [:]
    }()
    
    public static var isDevelopment: Bool = {
#if DEBUG
        return true
#else
        return false
#endif
    }()
    
    // These property must be initialised *after* `isDevelopment` because it is dependent on it.
    public static var developmentColor: TypographyColor = {
        if isDevelopment {
            return .red
        } else {
            return .clear
        }
    }()
    
    public static var lineBreak: NSLineBreakMode? = {
        return settings?.configuration.labels.lineBreakMode
    }()
    
    public static var minimumPointSize: Float? = {
        return settings?.configuration.minimumPointSize
    }()
    
    public static var maximumPointSize: Float? = {
        return settings?.configuration.maximumPointSize
    }()
    
    public static var pointStepSize: Float = {
        return settings?.configuration.pointStepSize ?? 2.0
    }()
    
    public static var pointStepMultiplier: Float = {
        return settings?.configuration.pointStepMultiplier ?? 1.0
    }()
    
    public static var scalingMode: ScalingMode = {
        return settings?.configuration.scalingMode ?? ScalingMode.default
    }()
    
    public static var shouldCrashIfColorNotFound: Bool = {
        return settings?.configuration.shouldCrashIfColorNotFound ?? false
    }()
    
    public static var shouldUseDevelopmentColors: Bool = {
        return settings?.configuration.shouldUseDevelopmentColors ?? false
    }()
    
    // MARK: Functions
    @available(iOS 13.0, *)
    public static func color(named colorName: String) -> Color {
        return tkColor(named: colorName).color
    }
    
    static func colorName(color: UIColor) -> String? {
        return colors.first(where: { $0.value.uiColor == color })?.key
    }
    
    public static func configure(with configuration: TypographyKitConfiguration) {
        guard let settings = loadSettings() else {
            return
        }
        Self.settings = settings.updateConfiguration(configuration)
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
    
    @available(iOS 9.0, *)
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
            .NavigationSettings(animated: animated,
                                autoClose: true,
                                closeButtonAlignment: .closeButtonLeftExportButtonRight,
                                isModal: true,
                                isNavigationBarHidden: navigationController.isNavigationBarHidden,
                                shouldRefresh: shouldRefresh)
        viewController.navigationSettings = navigationSettings
        if shouldRefresh {
            TypographyKit.refresh()
        }
        presenter.present(navigationController, animated: animated, completion: nil)
    }
    
    @available(iOS 9.0, *)
    public static func presentTypographyColors(delegate: TypographyKitViewControllerDelegate? = nil,
                                               navigationSettings: ViewControllerNavigationSettings) {
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
    public static func presentTypographyStyles(delegate: TypographyKitViewControllerDelegate? = nil,
                                               animated: Bool = true, shouldRefresh: Bool = true) {
        guard let presenter = UIApplication.shared.keyWindow?.rootViewController else { return }
        let navigationSettings = TypographyKitViewController
            .NavigationSettings(animated: animated,
                                autoClose: true,
                                closeButtonAlignment: .closeButtonLeftExportButtonRight,
                                isModal: true,
                                isNavigationBarHidden: false,
                                shouldRefresh: shouldRefresh)
        let viewController = typographyKitVC(navSettings: navigationSettings, delegate: delegate)
        viewController.modalPresentationStyle = .overCurrentContext
        let navigationController = UINavigationController(rootViewController: viewController)
        if navigationSettings.shouldRefresh {
            TypographyKit.refresh()
        }
        presenter.present(navigationController, animated: animated, completion: nil)
    }
    
    public static func presentTypographyStyles(delegate: TypographyKitViewControllerDelegate? = nil,
                                               navigationSettings: ViewControllerNavigationSettings) {
        guard let presenter = UIApplication.shared.keyWindow?.rootViewController else { return }
        let viewController = typographyKitVC(navSettings: navigationSettings, delegate: delegate)
        viewController.modalPresentationStyle = .overCurrentContext
        let navigationController = UINavigationController(rootViewController: viewController)
        
        if navigationSettings.shouldRefresh {
            TypographyKit.refresh()
        }
        presenter.present(navigationController, animated: navigationSettings.animated, completion: nil)
    }
    
    @available(iOS 9.0, *)
    public static func pushTypographyColors(delegate: TypographyKitViewControllerDelegate? = nil,
                                            navigationController: UINavigationController,
                                            animated: Bool = false,
                                            shouldRefresh: Bool = true) {
        let viewController = TypographyKitColorsViewController()
        viewController.delegate = delegate
        let navigationSettings = TypographyKitViewController
            .NavigationSettings(animated: animated,
                                autoClose: true,
                                isNavigationBarHidden: navigationController.isNavigationBarHidden,
                                shouldRefresh: shouldRefresh)
        viewController.navigationSettings = navigationSettings
        navigationController.isNavigationBarHidden = false
        if shouldRefresh {
            TypographyKit.refresh()
        }
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    @available(iOS 9.0, *)
    public static func pushTypographyColors(delegate: TypographyKitViewControllerDelegate? = nil,
                                            navigationController: UINavigationController,
                                            navigationSettings: ViewControllerNavigationSettings) {
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
    public static func pushTypographyStyles(delegate: TypographyKitViewControllerDelegate? = nil,
                                            navigationController: UINavigationController,
                                            animated: Bool = false,
                                            shouldRefresh: Bool = true) {
        let navigationSettings = TypographyKitViewController
            .NavigationSettings(animated: animated,
                                autoClose: true,
                                isNavigationBarHidden: navigationController.isNavigationBarHidden,
                                shouldRefresh: shouldRefresh)
        let viewController = typographyKitVC(navSettings: navigationSettings, delegate: delegate)
        navigationController.isNavigationBarHidden = false
        if navigationSettings.shouldRefresh {
            TypographyKit.refresh()
        }
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    public static func pushTypographyStyles(delegate: TypographyKitViewControllerDelegate? = nil,
                                            navigationController: UINavigationController,
                                            navigationSettings: ViewControllerNavigationSettings) {
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
    
    public static func refresh(_ completion: ((Settings?) -> Void)? = nil) {
        settings = loadSettings()
        guard let colors = settings?.colors,
              let configSettings = settings?.configuration,
              let styles = settings?.styles else {
            completion?(nil)
            return
        }
        let settings = Settings(colors: colors, configuration: configSettings, styles: styles)
        completion?(settings)
    }
    
    public static func refreshWithData(_ data: Data, completion: ((Settings?) -> Void)? = nil) {
        guard case let .success(settings) = loadSettings(from: data) else {
            completion?(nil)
            return
        }
        completion?(settings)
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
    
    static let configurationName: String = "TypographyKit"
    
    static func bundledConfigurationURL(_ configType: ConfigurationType = TypographyKit.configurationType) -> URL? {
        return Bundle.main.url(forResource: configurationName, withExtension: configType.rawValue)
    }
    
    static var settings: TypographyKitSettings? = loadSettings()
    
    static func loadSettings() -> TypographyKitSettings? {
        guard let configurationURL = configurationURL, let data = try? Data(contentsOf: configurationURL) else {
            guard case let .success(model) = loadSettings(from: nil) else {
                return nil
            }
            return model
        }
        guard case let .success(model) = loadSettings(from: data) else {
            return nil
        }
        return model
    }
    
    static func loadSettings(from data: Data?) -> ConfigurationParsingResult {
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
