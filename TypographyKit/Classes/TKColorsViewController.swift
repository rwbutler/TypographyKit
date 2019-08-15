//
//  TKColorsViewController.swift
//  TypographyKit
//
//  Created by Ross Butler on 8/13/19.
//

import Foundation

@available(iOS 9.0, *)
class TKColorsViewController: UIViewController {
    
    // MARK: Type Definitions
    public typealias Delegate = TypographyKitViewControllerDelegate
    public typealias NavigationSettings = ViewControllerNavigationSettings
    
    // MARK: State
    weak var delegate: Delegate?
    var navigationSettings: NavigationSettings?
    
    override func viewDidLoad() {
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
    
}

@available(iOS 9.0, *)
extension TKColorsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TypographyKit.colors.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let colorCell = cell as? TKColorCell else {
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
extension TKColorsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
}

@available(iOS 9.0, *)
private extension TKColorsViewController {
    
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
        configureNavigationBar()
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
