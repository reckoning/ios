//
//  MainViewController.swift
//  timer
//
//  Created by Marten Klitzke on 13.04.2017.
//  Copyright © 2017 Marten Klitzke. All rights reserved.
//

import UIKit
import FontAwesome_swift

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  @IBOutlet var timerList: UITableView!
  var timers: Array<Timer> = []
  var dates: Array<String> = []
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
    let date = dates[section]
    return timers.filter({ (timer: Timer) -> Bool in
      return timer.date == date
    }).count
  }

  func setDates() {
    self.dates = []
    self.timers.forEach { (timer: Timer) in
      if !self.dates.contains(timer.date) {
        self.dates.append(timer.date)
      }
    }
  }

  @available(iOS 2.0, *)
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier = "timerCell"
    var cell: TimerCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? TimerCell
    if cell == nil {
      tableView.register(UINib(nibName: "TimerCell", bundle: nil), forCellReuseIdentifier: identifier)
      cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? TimerCell
    }

    let date = dates[indexPath.section]
    let timersForSection = timers.filter({ (timer: Timer) -> Bool in
      return timer.date == date
    })
    cell.timer = timersForSection[indexPath.row]
    cell.configure()

    return cell
  }


  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 75.0;
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return self.dates.count
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let date = formatter.date(from: self.dates[section])
    formatter.dateFormat = "dd.MM.yyyy"
    if Calendar.current.isDateInToday(date!) {
      return "Heute (\(formatter.string(from: date!)))"
    } else {
      return formatter.string(from: date!)
    }
  }

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let date = dates[indexPath.section]
    let timersForSection = timers.filter({ (timer: Timer) -> Bool in
      return timer.date == date
    })
    let timer = timersForSection[indexPath.row]
    let index = self.timers.index(where: { (item) -> Bool in
      return item.id == timer.id
    })
    
    var action = UITableViewRowAction(
      style: .normal,
      title: "Start"
    ) { _, _ in
      timer.start(onFinish: { (startedTimer) in
        self.timers[index!] = startedTimer
        self.timerList.setEditing(false, animated: true)
        self.timerList.reloadRows(at: [indexPath], with: .none)
      })
    }
    action.backgroundColor = primaryColor
    if timer.startedAt != nil {
      action = UITableViewRowAction(
        style: .normal,
        title: "Stop"
      ) { _, _ in
        timer.stop(onFinish: { (stoppedTimer) in
          self.timers[index!] = stoppedTimer
          self.timerList.setEditing(false, animated: true)
          self.timerList.reloadRows(at: [indexPath], with: .none)
        })
      }
    }
    let delete = UITableViewRowAction(style: .default, title: "Löschen") { action, index in
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      appDelegate.confirmAlert(topic: "Timer löschen", onConfirm: {
        print("call api to delete the timer")
        self.timers.remove(at: indexPath.row)
        self.timerList.deleteRows(at: [indexPath], with: .automatic)
        self.timerList.setEditing(false, animated: true)
      }, onCancel: {
        self.timerList.setEditing(false, animated: true)
      })
    }
    return [action, delete]
  }

  //MARK: Actions

  func load() {
    Timer.all(onFinish: { (timers) in
      self.timers = timers
      self.setDates()
      self.timerList.reloadData()
      self.refreshControl.endRefreshing()
    }) { (_) in
      self.refreshControl.endRefreshing()
    }
  }

  func logout() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.confirmAlert(topic: "Abmelden", onConfirm: {
      appDelegate.logout(onFinish: {
        self.timers = []
        self.dates = []
        self.timerList.reloadData()
      })
    }, onCancel: nil)
  }
}
