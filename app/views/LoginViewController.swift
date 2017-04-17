//
//  LoginViewController.swift
//  app
//
//  Created by Marten Klitzke on 16.04.2017.
//  Copyright © 2017 Marten Klitzke. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet var EmailField: UITextField!
    @IBOutlet var PasswordField: UITextField!
    @IBOutlet var OTPField: UITextField!
    @IBOutlet var SubmitButton: PrimaryButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        EmailField.placeholder = "E-Mail"
        EmailField.keyboardType = .emailAddress
        PasswordField.placeholder = "Passwort"
        OTPField.placeholder = "Einmal Token (Optional)"
        OTPField.keyboardType = .numberPad
        SubmitButton.setTitle("Anmelden", for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    print(error)
                    self.SubmitButton.stopLoading()
                }
        }
    }
    
    func finished() {
        SubmitButton.stopLoading()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
