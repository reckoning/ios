//
//  TimerCell.swift
//  app
//
//  Created by Marten Klitzke on 15.04.2017.
//  Copyright © 2017 Marten Klitzke. All rights reserved.
//

import UIKit

var interval: Foundation.Timer!

class TimerCell: UITableViewCell {
  @IBOutlet var runningIndicator: UIActivityIndicatorView!
  @IBOutlet var title: UILabel!
  @IBOutlet var customer: UILabel!
  @IBOutlet var subTitle: UILabel!
  @IBOutlet var hours: UILabel!
  var timer: Timer!

  func update() {
    hours.text = timeText(timer: timer)
  }
  
  func configure() {
    if timer.startedAt != nil {
      if (interval != nil) {
        interval.invalidate()
      }
      interval = Foundation.Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
      runningIndicator.startAnimating()
      hours.textColor = Colors.primary
    } else {
      runningIndicator.stopAnimating()
      hours.textColor = Colors.color
    }
    
    title.text = timer.projectName
    customer.text = timer.projectCustomerName
    subTitle.text = timer.taskName
    hours.text = timeText(timer: timer)
  }

  func timeText(from number: Int) -> String {
    return number < 10 ? "0\(number)" : "\(number)"
  }

  func hours(seconds: Double) -> Double {
    return (seconds / 3600.0)
  }

  func timeText(timer: Timer) -> String {
    var elapsed: Double = 0.0
    if (timer.startedAt != nil) {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSxxx"
      dateFormatter.locale = Locale.init(identifier: "en_US")
      let startedDate = dateFormatter.date(from: timer.startedAt!)
      elapsed = Date().timeIntervalSince(startedDate!)
    }
    return hoursToTime(hours: hours(seconds: Double(elapsed)) + Double(String(describing: timer.value))!)
  }

  func hoursToTime(hours : Double) -> String {
    let numberOfPlaces:Double = 2.0
    let powerOfTen:Double = pow(10.0, numberOfPlaces)
    let minutes = (hours.truncatingRemainder(dividingBy: 1) * powerOfTen) / powerOfTen
    return "\(Int(hours)):\(timeText(from: Int(minutes * 60)))"
  }
}
