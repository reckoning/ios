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

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var timerList: UITableView!
    var interval: Foundation.Timer!
    var runningTimer: IndexPath!
    var timers: Array<Timer> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        
        let addTimerButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(MainViewController.add)
        )
        self.navigationItem.rightBarButtonItem  = addTimerButton
        
        let reloadButton = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(MainViewController.load)
        )
        self.navigationItem.leftBarButtonItem  = reloadButton
        
        timerList.dataSource = self
        timerList.delegate = self
        
        title = "Timers"
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
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
        
        let timer = timers[indexPath.row]
        
        if timer.startedAt != nil {
            self.runningTimer = indexPath
            if (self.interval != nil) {
                self.interval.invalidate()
            }
            self.interval = Foundation.Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MainViewController.update), userInfo: nil, repeats: true)
        }
        
        if self.runningTimer == nil {
            if (self.interval != nil) {
                self.interval.invalidate()
            }
            self.interval = nil
        }
        
        cell.textLabel?.text = timer.projectName
        cell.detailTextLabel!.text = timeText(timer: timer)
        
        return cell
    }

    //MARK: Actions
    
    func add() {
        let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func load() {
        var configuration = Configuration()
        
        let headers: HTTPHeaders = [
            "Authorization": "Token token=\"\(configuration.environment.token)\"",
            "Accept": "application/json"
        ]
        let parameters: Parameters = ["limit": 20]
        Alamofire.request("\(configuration.environment.baseURL)/timers", parameters: parameters, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    let json: Any? = try? JSONSerialization.jsonObject(with: response.data!, options: [])
                    for j in json as! Array<Any> {
                        let decodedTimer = Timer.decode(JSON(j))
                        let timer = decodedTimer.value
                        if !self.timers.contains(where: {$0.id == timer?.id}) {
                            self.timers.append(timer!)
                        }
                    }
                    self.timerList.reloadData()
                case .failure(let error):
                    print(error)
                }
        }
    }

    func hoursToTime(hours : Double) -> String {
        let numberOfPlaces:Double = 2.0
        let powerOfTen:Double = pow(10.0, numberOfPlaces)
        let minutes = (hours.truncatingRemainder(dividingBy: 1) * powerOfTen) / powerOfTen
        return "\(Int(hours)):\(timeText(from: Int(minutes * 60)))"
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
