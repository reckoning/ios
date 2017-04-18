//
//  LoginViewController.swift
//  app
//
//  Created by Marten Klitzke on 16.04.2017.
//  Copyright © 2017 Marten Klitzke. All rights reserved.
//

import UIKit
import Alamofire
import OnePasswordExtension

class LoginViewController: UIViewController {

    @IBOutlet var EmailField: BigTextField!
    @IBOutlet var PasswordField: BigTextField!
    @IBOutlet var OTPField: BigTextField!
    @IBOutlet var SubmitButton: PrimaryButton!
    @IBOutlet var OnePasswordButton: UIButton!
    
    override func viewDidLoad() {
      super.viewDidLoad()

      EmailField.setPlaceholder(name: "E-Mail")
      EmailField.keyboardType = .emailAddress
      PasswordField.setPlaceholder(name: "Passwort")
      OTPField.setPlaceholder(name: "Einmal-Token (Optional)")
      OTPField.keyboardType = .numberPad
      SubmitButton.setTitle("Anmelden", for: .normal)
      
      let onePasswordImage = UIImage(named: "onePassword")
      OnePasswordButton.setBackgroundImage(onePasswordImage, for: .normal)
      OnePasswordButton.isHidden = !OnePasswordExtension.shared().isAppExtensionAvailable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    @IBAction func findLoginFrom1Password(_ sender: UIButton) {
      OnePasswordExtension.shared().findLogin(forURLString: "https://reckoning.io", for: self, sender: sender) { (loginDictionary, _) in
        if (loginDictionary?.count == 0) {
          print("no login found")
          return
        }
        self.EmailField.text = loginDictionary?.values[(loginDictionary?.index(forKey: "username"))!] as? String
        self.PasswordField.text = loginDictionary?.values[(loginDictionary?.index(forKey: "password"))!] as? String
        self.OTPField.text = loginDictionary?.values[(loginDictionary?.index(forKey: "totp"))!] as? String
      }
    }

    @IBAction func submit(_ sender: UIButton) {
        SubmitButton.startLoading()
        var configuration = Configuration()

        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        let parameters: Parameters = ["email": EmailField.text ?? "", "password": PasswordField.text ?? "", "otp_token": OTPField.text ?? ""]
        Alamofire.request(
            "\(configuration.environment.baseURL)/sessions",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        )
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    let json = response.result.value as? [String: Any]
                    let authToken = json?["auth_token"] as? String
                    UserDefaults.standard.setValue(authToken, forKey: "authToken")
                    UserDefaults.standard.synchronize()
                    self.dismiss(animated: true)
                    self.SubmitButton.stopLoading()
                case .failure(let error):
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.showAlert(title: "Login fehlgeschlagen", message: error.localizedDescription)
                    self.SubmitButton.stopLoading()
                }
        }
    }
}
