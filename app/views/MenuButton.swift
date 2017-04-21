//
//  MenuButton.swift
//  app
//
//  Created by Marten Klitzke on 21.04.2017.
//  Copyright © 2017 Marten Klitzke. All rights reserved.
//

import UIKit

class MenuButton: Button {
  override func draw(_ rect: CGRect) {
    bgColor = UIColor.clear
    super.draw(rect)
    
    layer.borderWidth = 0
    layer.cornerRadius = 0
    
    contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
    titleEdgeInsets.left = 10
    titleEdgeInsets.right = 10
  }
}
