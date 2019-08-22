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

    @IBOutlet weak var attributedStringButton: UIButton!
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
        let buttonText = attributedStringButton.titleLabel?.attributedText
        attributedStringButton.attributedText(buttonText, style: .paragraph)
        let labelText = attributedStringLabel.attributedText
        attributedStringLabel.attributedText(labelText, style: .paragraph)
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
