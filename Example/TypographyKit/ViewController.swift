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

    @IBOutlet weak var attributedStringLabel: UILabel!
    @IBOutlet weak var colorsButton: UIButton!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        TypographyKit.configurationURL = Bundle.main.url(forResource: "TypographyKit", withExtension: "json")
        if #available(iOS 9.0, *) {
            colorsButton.isHidden = false
        }
        let text = attributedStringLabel.attributedText
        attributedStringLabel.attributedText(text, style: .paragraph)
    }

    @IBAction func presentTypographyColors(_ sender: UIButton) {
        if #available(iOS 9.0, *) {
            TypographyKit.presentTypographyColors()
        }
    }

    @IBAction func presentTypographyStyles(_ sender: UIButton) {
        TypographyKit.presentTypographyStyles()
    }

}
