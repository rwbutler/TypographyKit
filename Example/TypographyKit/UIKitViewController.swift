//
//  UIKitViewController.swift
//  TypographyKit
//
//  Created by Ross Butler on 05/09/2017.
//  Copyright (c) 2017 Ross Butler. All rights reserved.
//

import Foundation
import UIKit

class UIKitViewController: UIViewController {

    @IBOutlet weak var attributedStringButton: UIButton!
    @IBOutlet weak var attributedStringLabel: UILabel!
    @IBOutlet weak var colorsButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UIKit Example"
        view.backgroundColor = .background
        let buttonText = attributedStringButton.titleLabel?.attributedText
        attributedStringButton.attributedText(buttonText, style: .paragraph)
        let labelText = attributedStringLabel.attributedText
        attributedStringLabel.attributedText(labelText, style: .paragraph)
    }

}
