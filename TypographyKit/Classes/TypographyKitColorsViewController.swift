//
//  TypographyKitColorsViewController.swift
//  TypographyKit
//
//  Created by Ross Butler on 04/08/2020.
//

import Foundation
import UIKit

@available(iOS 9.0, *)
class TypographyKitColorsViewController: UIViewController {
    
    // MARK: Type Definitions
    public typealias Delegate = TypographyKitViewControllerDelegate
    public typealias NavigationSettings = ViewControllerNavigationSettings
    
    lazy var headerView: UISegmentedControl = {
        let segControl = UISegmentedControl(items: [])
        segControl.addTarget(self, action: #selector(changeStyle), for: .valueChanged)
        if #available(iOS 13, *) {
            view.backgroundColor = .systemBackground
        }
        return segControl
    }()
    
    // MARK: State
    weak var delegate: Delegate?
    var navigationSettings: NavigationSettings?
    
    override func viewDidLoad() {
        title = "TypographyKit Colors"
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.register(TypographyKitColorCell.self, forCellReuseIdentifier: "cell")
        configureView()
    }
    
    @objc func close() {
        if viewControllerShouldDismiss() {
            let isAnimated: Bool = navigationSettings?.animated ?? true
            let isModal: Bool = navigationSettings?.isModal ?? (navigationController == nil)
            
            if isModal {
                dismiss(animated: isAnimated, completion: nil)
            } else {
                hideNavigationBarIfNeeded()
                navigationController?.popViewController(animated: isAnimated)
            }
        }
        delegate?.viewControllerDidFinish()
    }
    
    @IBAction func changeStyle(_ sender: UISegmentedControl) {
        guard #available(iOS 13, *) else { print("unavailable"); return}
        let style = TypographyInterfaceStyle.allCases[sender.selectedSegmentIndex]
        overrideUserInterfaceStyle = style.userInterfaceStyle
    }
}

@available(iOS 9.0, *)
extension TypographyKitColorsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TypographyKit.colors.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let colorCell = cell as? TypographyKitColorCell else {
            return cell
        }
        let colors = TypographyKit.colors
        let colorName = Array(colors.keys).sorted()[indexPath.row]
        let colorValue = colors[colorName]
        colorCell.configure(title: colorName, color: colorValue)
        return colorCell
    }
    
}

@available(iOS 9.0, *)
extension TypographyKitColorsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard #available(iOS 13, *) else { return nil }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard #available(iOS 13, *) else { return 0 }
        return headerView.frame.height
    }
    
}

@available(iOS 9.0, *)
private extension TypographyKitColorsViewController {
    
    private func configureNavigationBar() {
        let closeButtonType = navigationSettings?.closeButton ?? .done
        let doneButton = UIBarButtonItem(barButtonSystemItem: closeButtonType,
                                         target: self,
                                         action: #selector(close))
        let closeButtonAlignment = navigationSettings?.closeButtonAlignment ?? .closeButtonLeftExportButtonRight
        switch closeButtonAlignment {
        case .closeButtonLeftExportButtonRight:
            navigationItem.leftBarButtonItem = doneButton
        case .closeButtonRightExportButtonLeft:
            navigationItem.rightBarButtonItem = doneButton
        case .noCloseButtonExportButtonLeft:
            break
        case .noCloseButtonExportButtonRight:
            break
        }
        navigationItem.leftItemsSupplementBackButton = true
    }
    
    func configureView() {
        configureHeader()
        configureNavigationBar()
    }
    
    private func configureHeader() {
        guard #available(iOS 13, *) else { return }
        headerView.removeAllSegments()
        TypographyInterfaceStyle.allCases.enumerated().forEach { x in
            let (index, style) = x
            headerView.insertSegment(withTitle: style.rawValue.upperCamelCased(), at: index, animated: false)
        }
        
        let currentStyle = TypographyInterfaceStyle(style: traitCollection.userInterfaceStyle)
        headerView.selectedSegmentIndex = TypographyInterfaceStyle.allCases.firstIndex(of: currentStyle) ?? 0
    }
    
    /// Hides or unhides the navigation bar according to navigational preferences.
    private func hideNavigationBarIfNeeded() {
        let isNavigationBarHidden: Bool? = navigationSettings?.isNavigationBarHidden
        if let isNavigationBarHidden = isNavigationBarHidden {
            navigationController?.isNavigationBarHidden = isNavigationBarHidden
        }
    }
    
    /// Determines whether or not this view controller should dismiss itself
    /// or whether code outside the controller is responsible for this.
    private func viewControllerShouldDismiss() -> Bool {
        return navigationSettings?.autoClose ?? true // default to auto-close
    }
    
}
