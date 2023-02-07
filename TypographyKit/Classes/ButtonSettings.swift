//
//  ButtonSettings.swift
//  TypographyKit
//
//  Created by Ross Butler on 23/05/2020.
//

import Foundation
import UIKit

public struct ButtonSettings: Codable {
    let titleColorApplyMode: ButtonTitleColorApplyMode
    
    init(titleColorApplyMode: ButtonTitleColorApplyMode = .whereUnspecified) {
        self.titleColorApplyMode = titleColorApplyMode
    }
    
    private func copy(titleColorApplyMode: ButtonTitleColorApplyMode? = nil) -> Self {
        .init(titleColorApplyMode: titleColorApplyMode ?? self.titleColorApplyMode)
    }
    
    func setTitleColorApplyMode(titleColorApplyMode: ButtonTitleColorApplyMode?) -> Self {
        copy(titleColorApplyMode: titleColorApplyMode)
    }
}
