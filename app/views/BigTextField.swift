//
//  BigTextField.swift
//  app
//
//  Created by Marten Klitzke on 16.04.2017.
//  Copyright © 2017 Marten Klitzke. All rights reserved.
//

import UIKit

class BigTextField: UITextField {
    override func draw(_ rect: CGRect) {
        addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50))
        borderStyle = .bezel
        layer.borderWidth = 1
        layer.cornerRadius = 4
        textColor = UIColor(red:0.333, green:0.333, blue:0.333, alpha:1.000)
        layer.borderColor = UIColor(red:0.800, green:0.800, blue:0.800, alpha:1.000).cgColor
        font = UIFont.systemFont(ofSize: 20)
        clearButtonMode = .unlessEditing
    }
}
