//
//  TimerCell.swift
//  app
//
//  Created by Marten Klitzke on 15.04.2017.
//  Copyright © 2017 Marten Klitzke. All rights reserved.
//

import UIKit

class TimerCell: UITableViewCell {
  @IBOutlet var runningIndicator: UIActivityIndicatorView!
  @IBOutlet var title: UILabel!
  @IBOutlet var customer: UILabel!
  @IBOutlet var subTitle: UILabel!
  @IBOutlet var hours: UILabel!
}
