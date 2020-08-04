//
//  TKColorCell.swift
//  TypographyKit
//
//  Created by Ross Butler on 8/13/19.
//

import Foundation
import UIKit

@available(iOS 9.0, *)
class TypographyKitColorCell: UITableViewCell {
    
    private var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "Avenir-Book", size: 17.0)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, color: UIColor?) {
        titleLabel.text = title
        if let backgroundColor = color {
            self.contentView.backgroundColor = backgroundColor
        }
        layoutIfNeeded()
    }
    
}

@available(iOS 9.0, *)
private extension TypographyKitColorCell {
    
    private func configureView() {
        let effectView = self.effectView()
        effectView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: effectView.leftAnchor, constant: 10.0),
            titleLabel.rightAnchor.constraint(equalTo: effectView.rightAnchor, constant: -10.0),
            titleLabel.topAnchor.constraint(equalTo: effectView.topAnchor, constant: 10.0),
            titleLabel.bottomAnchor.constraint(equalTo: effectView.bottomAnchor, constant: -10.0)
        ])
    }
    
    private func effectView() -> UIView {
        let blur = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: blur)
        effectView.translatesAutoresizingMaskIntoConstraints = false
        effectView.clipsToBounds = true
        effectView.layer.cornerRadius = 5.0
        contentView.addSubview(effectView)
        NSLayoutConstraint.activate([
            effectView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10.0),
            effectView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        return effectView.contentView
    }
    
}
