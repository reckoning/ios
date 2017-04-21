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
import IHKeyboardAvoiding

class LoginViewController: UIViewController, UITextFieldDelegate {
  @IBOutlet var emailField: BigTextField!
  @IBOutlet var passwordField: BigTextField!
  @IBOutlet var otpField: BigTextField!
  @IBOutlet var submitButton: PrimaryButton!
  @IBOutlet var onePasswordButton: UIButton!
  @IBOutlet var formView: UIStackView!

  override func viewDidLoad() {
    super.viewDidLoad()

    KeyboardAvoiding.avoidingView = formView

    emailField.setPlaceholder(name: "E-Mail")
    emailField.keyboardType = .emailAddress
    emailField.delegate = self
    emailField.tag = 0

    passwordField.setPlaceholder(name: "Passwort")
    passwordField.delegate = self
    passwordField.tag = 1

    otpField.setPlaceholder(name: "Einmal-Token (Optional)")
    otpField.keyboardType = .numberPad
    otpField.returnKeyType = .done
    otpField.delegate = self
    otpField.tag = 2

    submitButton.setTitle("Anmelden", for: .normal)

    let onePasswordImage = UIImage(named: "onePassword")
    onePasswordButton.setBackgroundImage(onePasswordImage, for: .normal)
    onePasswordButton.isHidden = !OnePasswordExtension.shared().isAppExtensionAvailable()

    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
    view.addGestureRecognizer(tap)

    addDoneButtonOnKeyboard()
  }

  func addDoneButtonOnKeyboard() {
    let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: formView.frame.size.width, height: 50))
    doneToolbar.barStyle = .default

    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

    let items = NSMutableArray()
    items.add(flexSpace)
    items.add(done)

    doneToolbar.items = items as? [UIBarButtonItem]
    doneToolbar.sizeToFit()

    otpField.inputAccessoryView = doneToolbar
  }

  func doneButtonAction() {
    view.endEditing(true)
    submitButton.sendActions(for: .touchUpInside)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
      nextField.becomeFirstResponder()
    } else {
      textField.resignFirstResponder()
    }
    return false
  }

  func dismissKeyboard() {
    view.endEditing(true)
  }

  @IBAction func findLoginFrom1Password(_ sender: UIButton) {
    OnePasswordExtension.shared().findLogin(forURLString: "https://reckoning.io", for: self, sender: sender) { (loginDictionary, _) in
      if (loginDictionary?.count == 0) {
        print("no login found")
        return
      }
      self.emailField.text = loginDictionary?.values[(loginDictionary?.index(forKey: "username"))!] as? String
      self.passwordField.text = loginDictionary?.values[(loginDictionary?.index(forKey: "password"))!] as? String
      self.otpField.text = loginDictionary?.values[(loginDictionary?.index(forKey: "totp"))!] as? String
    }
  }

  @IBAction func submit(_ sender: UIButton) {
    submitButton.startLoading()
    var configuration = Configuration()
    let headers: HTTPHeaders = [
      "Accept": "application/json",
      "Content-Type": "application/json"
    ]
    let parameters: Parameters = ["email": emailField.text ?? "", "password": passwordField.text ?? "", "otp_token": otpField.text ?? ""]
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
            self.submitButton.stopLoading()
          case .failure(let error):
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.showAlert(title: "Login fehlgeschlagen", message: error.localizedDescription)
            self.submitButton.stopLoading()
        }
      }
  }
}
