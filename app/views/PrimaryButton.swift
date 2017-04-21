  //
//  Button.swift
//  app
//
//  Created by Marten Klitzke on 16.04.2017.
//  Copyright © 2017 Marten Klitzke. All rights reserved.
//

import UIKit

class PrimaryButton: Button {
  override func draw(_ rect: CGRect) {
    color = Colors.buttonColorPrimary
    colorTouch = Colors.buttonColorPrimary
    bgColor = Colors.buttonBgPrimary
    bgColorTouch = Colors.buttonBgPrimaryTouch
    bgColorLoading = Colors.buttonBgPrimaryLoading
    borderColor = Colors.buttonBorderPrimary
    borderColorTouch = Colors.buttonBorderPrimaryTouch

    super.draw(rect)
    
    layer.cornerRadius = 6
    layer.borderWidth = 1
  }
}
