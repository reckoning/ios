//
//  ViewController.swift
//  app
//
//  Created by Marten Klitzke on 20.04.2017.
//  Copyright © 2017 Marten Klitzke. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
  var user: User!
  
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var emailLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    if appDelegate.isAuthenticated() {
      loadUser()
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  //MARK: Actions
  
  @IBAction func logout(_ sender: UIButton) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.confirmAlert(topic: "Abmelden", onConfirm: {
      self.closeLeft()  
      appDelegate.logout(onFinish: {
        self.user = nil
      })
    }, onCancel: nil)
  }
  
  //MARK: Network methods
  
  func loadUser() {
    User.current(onFinish: { (user) in
      self.user = user
      self.nameLabel.text = user.name
      self.emailLabel.text = user.email
    }, onFail: { (error) in
      print(error)
    })
  }
}
