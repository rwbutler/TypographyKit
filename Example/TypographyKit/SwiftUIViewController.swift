//
//  SwiftUIViewController.swift
//  TypographyKit
//
//  Created by Ross Butler on 22/02/2020.
//  Copyright © 2020 Ross Butler. All rights reserved.
//

import Foundation
import SwiftUI

@available(iOS 13.0.0, *)
class SwiftUIViewController: UIHostingController<SwiftUIView> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: SwiftUIView())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SwiftUI Example"
    }
}
