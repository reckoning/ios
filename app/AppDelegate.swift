//
//  AppDelegate.swift
//  timer
//
//  Created by Marten Klitzke on 13.04.2017.
//  Copyright © 2017 Marten Klitzke. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireNetworkActivityIndicator
import HockeySDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      window = UIWindow(frame: UIScreen.main.bounds)

      let mainViewController = MainViewController(nibName: "MainViewController", bundle: nil)
      let navController = UINavigationController(rootViewController: mainViewController)

      window?.makeKeyAndVisible()
      window?.rootViewController = navController

      if !isAuthenticated() {
        showLogin(animated: false)
      }

      NetworkActivityIndicatorManager.shared.isEnabled = true
      NetworkActivityIndicatorManager.shared.startDelay = 0.2
      NetworkActivityIndicatorManager.shared.completionDelay = 1.0

      BITHockeyManager.shared().configure(withIdentifier: "fe70b029361b4507bcaf43d56931657b")
      BITHockeyManager.shared().start()
      BITHockeyManager.shared().authenticator.authenticateInstallation() // This line is obsolete in the crash only builds

      return true
    }

    func isAuthenticated() -> Bool {
      return (UserDefaults.standard.value(forKey: "authToken") as? NSString) != nil
    }

    func showLogin(animated: Bool) {
      let loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
      window?.rootViewController?.present(loginViewController, animated: animated)
    }

    func logout() {
      var configuration = Configuration()
      let authToken = UserDefaults.standard.value(forKey: "authToken") as? NSString
      let headers: HTTPHeaders = [
        "Authorization": "Bearer \"\(authToken ?? "")\"",
        "Accept": "application/json"
      ]
      Alamofire.request(
        "\(configuration.environment.baseURL)/sessions",
        method: .delete,
        headers: headers
      )
        .validate(statusCode: 200..<500)
        .responseJSON { response in
          switch response.result {
            case .success:
              UserDefaults.standard.removeObject(forKey: "authToken")
              UserDefaults.standard.synchronize()
              self.showLogin(animated: true)
            case .failure(let error):
              self.showAlert(title: "Logout fehlgeschlagen", message: error.localizedDescription)
          }
        }
    }

    func showAlert(title: String, message: String) {
      let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
      alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
      self.window?.rootViewController?.presentedViewController?.present(alert, animated: true, completion: nil)
    }

    func applicationWillResignActive(_ application: UIApplication) {
      // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
      // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
      // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
      // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
      // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
      // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
      // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
