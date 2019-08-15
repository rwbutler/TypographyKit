//
//  TKColorCell.swift
//  TypographyKit
//
//  Created by Ross Butler on 8/13/19.
//

import Foundation

@available(iOS 9.0, *)
class TKColorCell: UITableViewCell {
    
    @IBOutlet weak var effectView: UIVisualEffectView!
    @IBOutlet weak var title: UILabel!
    
    func configure(title: String, color: UIColor?) {
        self.effectView.clipsToBounds = true
        self.effectView.layer.cornerRadius = 5.0
        self.title.text = title
        if let backgroundColor = color {
            self.contentView.backgroundColor = backgroundColor
        }
    }
    
}
