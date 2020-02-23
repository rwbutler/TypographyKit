//
//  MenuViewController.swift
//  TypographyKit
//
//  Created by Ross Butler on 22/02/2020.
//  Copyright © 2020 Ross Butler. All rights reserved.
//

import Foundation
import UIKit
import TypographyKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TypographyKit"
    }

    @IBAction func presentTypographyColors(_ sender: UIButton) {
        if #available(iOS 9.0, *), let navController = navigationController {
            let navSettings = ViewControllerNavigationSettings(animated: true,
                                                               closeButtonAlignment: .noCloseButtonExportButtonRight)
            TypographyKit.pushTypographyColors(navigationController: navController, navigationSettings: navSettings)
        }
    }

    @IBAction func presentTypographyStyles(_ sender: UIButton) {
        if let navController = navigationController {
            let navSettings = ViewControllerNavigationSettings(animated: true,
                                                               closeButtonAlignment: .noCloseButtonExportButtonRight)
            TypographyKit.pushTypographyStyles(navigationController: navController, navigationSettings: navSettings)
        }
    }

}
