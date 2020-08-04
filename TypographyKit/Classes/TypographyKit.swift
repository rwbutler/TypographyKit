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
    
    @available(iOS 9.0, *)
    public static func presentTypographyColors(delegate: TypographyKitViewControllerDelegate? = nil,
                                               animated: Bool = true, shouldRefresh: Bool = true) {
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
