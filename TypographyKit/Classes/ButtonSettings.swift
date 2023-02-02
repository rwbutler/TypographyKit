//
//  ButtonSettings.swift
//  TypographyKit
//
//  Created by Ross Butler on 23/05/2020.
//

import Foundation
import UIKit

struct ButtonSettings: Codable {
    let titleColorApplyMode: ButtonTitleColorApplyMode
    
    init(titleColorApplyMode: ButtonTitleColorApplyMode = .whereUnspecified) {
        self.titleColorApplyMode = titleColorApplyMode
    }
}
