//
//  ViewController.swift
//  TypographyKit
//
//  Created by Ross Butler on 05/09/2017.
//  Copyright (c) 2017 Ross Butler. All rights reserved.
//

import UIKit
import TypographyKit

class ViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
    }

    @IBAction func presentTypographyStyles(_ sender: UIButton) {
        TypographyKit.presentTypographyStyles()
    }
}
