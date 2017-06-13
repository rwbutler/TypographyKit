//
//  ViewController.swift
//  TypographyKit
//
//  Created by rwbutler on 05/09/2017.
//  Copyright (c) 2017 rwbutler. All rights reserved.
//

import UIKit
import TypographyKit

class ViewController: UIViewController {
    @IBOutlet weak var heading: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        heading.fontTextStyle = .heading
    }
}
