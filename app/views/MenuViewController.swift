//
//  ViewController.swift
//  app
//
//  Created by Marten Klitzke on 20.04.2017.
//  Copyright © 2017 Marten Klitzke. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class MenuViewController: UIViewController {
  var user: User!

  @IBOutlet var profileCell: UIView!
  @IBOutlet var profileImage: ProfileImage!
  @IBOutlet var emailLabel: UILabel!
  @IBOutlet var logoutButton: MenuButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    let bottomBorder = UIView(frame: CGRect(x:0, y:89, width:profileCell.frame.size.width, height:1))
    bottomBorder.backgroundColor = Colors.buttonBorder
    profileCell.addSubview(bottomBorder)
    
    logoutButton.setTitle("Abmelden", for: .normal)
    
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
        self.profileImage.image = nil
      })
    }, onCancel: nil)
  }
  
  //MARK: Network methods
  
  func loadUser() {
    User.current(onFinish: { (user) in
      self.user = user
      self.emailLabel.text = user.email
      if (user.avatar != nil) {
        self.profileImage.setImage(image: user.avatar)
      }
    }, onFail: { (error) in
      print(error)
    })
  }
}
