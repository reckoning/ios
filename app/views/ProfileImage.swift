//
//  ProfileImage.swift
//  app
//
//  Created by Marten Klitzke on 21.04.2017.
//  Copyright © 2017 Marten Klitzke. All rights reserved.
//

import UIKit

class ProfileImage: UIImageView {
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    
    layer.cornerRadius = frame.size.width / 2;
    clipsToBounds = true
    layer.borderWidth = 1
    layer.borderColor = Colors.profileImageBorder.cgColor
  }
  
  func setImage(image: String) {
    let url = URL(string: image)
    self.af_setImage(withURL: url!)
  }
}
