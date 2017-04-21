//
//  Button.swift
//  app
//
//  Created by Marten Klitzke on 21.04.2017.
//  Copyright © 2017 Marten Klitzke. All rights reserved.
//

import UIKit

class Button: UIButton {
  var color = Colors.buttonColor
  var colorTouch = Colors.buttonColor
  var bgColor = Colors.buttonBg
  var bgColorTouch = Colors.buttonBgTouch
  var bgColorLoading = Colors.buttonBgLoading
  var borderColor = Colors.buttonBorder
  var borderColorTouch = Colors.buttonBorderTouch
  var title: String!
  var isLoading: Bool!
  
  override func draw(_ rect: CGRect) {
    addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 46))
    
    layer.cornerRadius = 6
    layer.borderWidth = 1
    
    setTitleColor(color, for: .normal)
    setTitleColor(colorTouch, for: .highlighted)
    setTitleColor(colorTouch, for: .focused)
    setTitleColor(colorTouch, for: .selected)
    adjustsImageWhenDisabled = false
    adjustsImageWhenHighlighted = true
    
    titleLabel?.font = UIFont(name: "HelveticaNeue", size: 18)
    
    clipsToBounds = true
    layer.backgroundColor = bgColor.cgColor
    layer.borderColor = borderColor.cgColor
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
  
  override var isEnabled: Bool {
    didSet {
      if isLoading {
        layer.backgroundColor = bgColorLoading.cgColor
      } else {
        layer.backgroundColor = bgColor.cgColor
        layer.borderColor = borderColor.cgColor
      }
    }
  }
  
  override var isHighlighted: Bool {
    didSet {
      if isHighlighted {
        layer.backgroundColor = bgColorTouch.cgColor
        layer.borderColor = borderColorTouch.cgColor
      } else {
        layer.backgroundColor = bgColor.cgColor
        layer.borderColor = borderColor.cgColor
      }
    }
  }
}
