//
//  Button.swift
//  app
//
//  Created by Marten Klitzke on 16.04.2017.
//  Copyright © 2017 Marten Klitzke. All rights reserved.
//

import UIKit

class PrimaryButton: UIButton {
    
    let borderColor = UIColor(red:0.208, green:0.494, blue:0.741, alpha:1.000)
    let borderColorHighlight = UIColor(red:0.157, green:0.369, blue:0.557, alpha:1.000)
    let buttonBackgroundColor = UIColor(red:0.259, green:0.545, blue:0.792, alpha:1.000)
    let buttonBackgroundColorHighlight = UIColor(red:0.188, green:0.443, blue:0.663, alpha:1.000)
    let buttonBackgroundColorLoading = UIColor(red:0.522, green:0.706, blue:0.867, alpha:1.000)
    var title: String!
    var isLoading: Bool = false
    
    override func draw(_ rect: CGRect) {
        addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50))
        
        layer.cornerRadius = 6
        layer.borderWidth = 1
        
        setTitleColor(UIColor.white, for: .normal)
        setTitleColor(UIColor.white, for: .highlighted)
        setTitleColor(UIColor.white, for: .focused)
        setTitleColor(UIColor.white, for: .selected)
        adjustsImageWhenDisabled = false
        adjustsImageWhenHighlighted = false
        
        titleLabel?.font = UIFont.systemFont(ofSize: 20)
        
        clipsToBounds = true
        backgroundColor = buttonBackgroundColor
    }
    
    func startLoading() {
        isLoading = true
        title = titleLabel?.text
        setTitle("Bitte warten...", for: .normal)
        isEnabled = false
    }
    
    func stopLoading() {
        isLoading = false
        setTitle(title, for: .normal)
        isEnabled = true
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isLoading {
                backgroundColor = buttonBackgroundColorLoading
            } else if isHighlighted {
                backgroundColor = buttonBackgroundColorHighlight
                layer.borderColor = borderColor.cgColor
            } else {
                backgroundColor = buttonBackgroundColor
                layer.borderColor = borderColorHighlight.cgColor
            }
        }
    }
}
