//
//  MainViewController.swift
//  timer
//
//  Created by Marten Klitzke on 13.04.2017.
//  Copyright © 2017 Marten Klitzke. All rights reserved.
//

import UIKit
import Alamofire
import Argo
import FontAwesome_swift

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  @IBOutlet var timerLabel: UILabel!
  @IBOutlet var timerList: UITableView!
  var interval: Foundation.Timer!
  var runningTimer: IndexPath!
  var timers: Array<Timer> = []
  let primaryColor = UIColor(red:0.259,  green:0.545,  blue:0.792, alpha:1)

  lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(MainViewController.load), for: UIControlEvents.valueChanged)

    return refreshControl
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    let grayColor = UIColor(red:0.200,  green:0.200,  blue:0.200, alpha:1)

    timerList.allowsSelection = false

    let logoutButton = UIBarButtonItem(
      title: "",
      style: .plain,
      target: self,
      action: #selector(self.logout)
    )
    let logoutButtonAttributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 20)] as [String: Any]
    logoutButton.setTitleTextAttributes(logoutButtonAttributes, for: .normal)
    logoutButton.title = String.fontAwesomeIcon(name: .signOut)
    logoutButton.tintColor = primaryColor
    self.navigationItem.leftBarButtonItem = logoutButton
    self.navigationController?.navigationBar.titleTextAttributes =
      [NSForegroundColorAttributeName: grayColor,
       NSFontAttributeName: UIFont(name: "Orbitron-Regular", size: 21)!]

    timerList.dataSource = self
    timerList.delegate = self

    timerList.addSubview(self.refreshControl)

    title = "Timers"
  }

  override func viewDidAppear(_ animated: Bool) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    if appDelegate.isAuthenticated() {
      load()
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  //MARK: TableView

  @available(iOS 2.0, *)
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return timers.count
  }

  @available(iOS 2.0, *)
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier = "timerCell"
    var cell: TimerCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? TimerCell
    if cell == nil {
      tableView.register(UINib(nibName: "TimerCell", bundle: nil), forCellReuseIdentifier: identifier)
      cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? TimerCell
    }

    let timer = timers[indexPath.row]

    if timer.startedAt != nil {
      self.runningTimer = indexPath
      if (self.interval != nil) {
          self.interval.invalidate()
      }
      self.interval = Foundation.Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
      cell.runningIndicator.startAnimating()
    } else {
      cell.runningIndicator.stopAnimating()
    }

    if self.runningTimer == nil {
      if (self.interval != nil) {
        self.interval.invalidate()
      }
      self.interval = nil
    }

    cell.title.text = timer.projectName
    cell.customer.text = timer.projectCustomerName
    cell.subTitle.text = timer.taskName
    cell.hours.text = timeText(timer: timer)

    return cell
  }


  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 75.0;
  }

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let timer = timers[indexPath.row]
    var action = UITableViewRowAction(
      style: .normal,
      title: "Start"
    ) { action, index in
      print("call api")
      self.timerList.setEditing(false, animated: true)
      self.timerList.reloadRows(at: [indexPath], with: .none)
    }
    action.backgroundColor = primaryColor
    if timer.startedAt != nil {
      action = UITableViewRowAction(
        style: .normal,
        title: "Stop"
      ) { action, index in
        print("call api")
        self.timerList.setEditing(false, animated: true)
        self.timerList.reloadRows(at: [indexPath], with: .none)
      }
      action.backgroundColor = UIColor.white
    }
    let delete = UITableViewRowAction(style: .default, title: "Löschen") { action, index in
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      appDelegate.confirmAlert(title: "Timer Löschen", message: "Sind Sie sich sicher?", completion: {
        print("call api to delete the timer")
        self.timers.remove(at: indexPath.row)
        self.timerList.deleteRows(at: [indexPath], with: .automatic)
      })
    }
    return [action, delete]
  }

  //MARK: Actions

  func load() {
    var configuration = Configuration()
    let authToken = UserDefaults.standard.value(forKey: "authToken") as? NSString
    let headers: HTTPHeaders = [
      "Authorization": "Bearer \"\(authToken ?? "")\"",
      "Accept": "application/json"
    ]
    let parameters: Parameters = ["limit": 20]
    Alamofire.request("\(configuration.environment.baseURL)/timers", parameters: parameters, headers: headers)
      .validate(statusCode: 200..<300)
      .responseJSON { response in
        switch response.result {
        case .success:
          let json: Any? = try? JSONSerialization.jsonObject(with: response.data!, options: [])
          var runningTimerPresent: Bool = false
          self.timers = []
          for j in json as! Array<Any> {
            let decodedTimer = Timer.decode(JSON(j))
            let timer = decodedTimer.value
            self.timers.append(timer!)
            if timer?.startedAt != nil {
              runningTimerPresent = true
            }
          }
          if !runningTimerPresent {
            self.runningTimer = nil
          }
          self.timerList.reloadData()
          self.refreshControl.endRefreshing()
        case .failure(let error):
          let appDelegate = UIApplication.shared.delegate as! AppDelegate
          appDelegate.showAlert(title: "Anfrage fehlgeschlagen", message: error.localizedDescription)
          self.refreshControl.endRefreshing()
        }
    }
  }

  func hoursToTime(hours : Double) -> String {
    let numberOfPlaces:Double = 2.0
    let powerOfTen:Double = pow(10.0, numberOfPlaces)
    let minutes = (hours.truncatingRemainder(dividingBy: 1) * powerOfTen) / powerOfTen
    return "\(Int(hours)):\(timeText(from: Int(minutes * 60)))"
  }

  func logout() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.confirmAlert(title: "Bitte bestätigen", message: "Wollen Sie sich wirklich abmelden?", completion: {
      appDelegate.logout()
      self.timers = []
      self.timerList.reloadData()
    })
  }

  func timeText(from number: Int) -> String {
    return number < 10 ? "0\(number)" : "\(number)"
  }

  func hours(seconds: Double) -> Double {
    return (seconds / 3600.0)
  }

  //MARK: Helpers

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

  func update() {
    if (runningTimer != nil) {
      timerList.reloadRows(at: [runningTimer], with: UITableViewRowAnimation.none)
    }
  }
}
