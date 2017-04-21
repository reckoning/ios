//
//  appUITests.swift
//  appUITests
//
//  Created by Marten Klitzke on 21.04.2017.
//  Copyright © 2017 Marten Klitzke. All rights reserved.
//

import XCTest

class appUITests: XCTestCase {
  var userDefaults: UserDefaults?
  let userDefaultsSuiteName = "TestDefaults"
  
    override func setUp() {
      super.setUp()
      
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = true
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
  
  func testLogin() {
    UserDefaults.standard.removeObject(forKey: "authToken")
    UserDefaults.standard.synchronize()
    
    let app = XCUIApplication()
    
    let eMailTextField = app.textFields["E-Mail"]
    eMailTextField.tap()
    eMailTextField.typeText("jl@picard.ent")
    
    let passwortSecureTextField = app.secureTextFields["Passwort"]
    passwortSecureTextField.tap()
    passwortSecureTextField.typeText("klingon")
    
    app.buttons["Anmelden"].tap()
  }
  
    func testLogout() {
      UserDefaults.standard.setValue("federation", forKey: "authToken")
      UserDefaults.standard.synchronize()
      
      let app = XCUIApplication()
      app.navigationBars["Timers"].buttons.element(boundBy: 0).tap()
      app.buttons["Abmelden"].tap()
      app.alerts["Abmelden"].buttons["OK"].tap()
    }
  

  
}
