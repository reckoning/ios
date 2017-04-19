//
//  ApiClient.swift
//  app
//
//  Created by Marten Klitzke on 19.04.2017.
//  Copyright © 2017 Marten Klitzke. All rights reserved.
//

import Foundation
import Alamofire

class ApiClient: NSObject {
  var baseURL: String!
  var headers: HTTPHeaders!
  
  public override init() {
    super.init()
    var configuration = Configuration()
    baseURL = configuration.environment.baseURL
    let authToken = UserDefaults.standard.value(forKey: "authToken") as! String
    headers = [
      "Authorization": "Bearer \"\(authToken)\"",
      "Accept": "application/json"
    ]
  }
  
  func get(path: String, params: Parameters?, onFinish: ((Any?) -> Void)?, onFail: ((Error) -> Void)?) {
    call(path: path, method: .get, params: params, onFinish: onFinish, onFail: onFail)
  }
  
  func post(path: String, params: Parameters?, onFinish: ((Any?) -> Void)?, onFail: ((Error) -> Void)?) {
    call(path: path, method: .post, params: params, onFinish: onFinish, onFail: onFail)
  }
  
  func put(path: String, params: Parameters?, onFinish: ((Any?) -> Void)?, onFail: ((Error) -> Void)?) {
    call(path: path, method: .put, params: params, onFinish: onFinish, onFail: onFail)
  }
  
  func delete(path: String, onFinish: ((Any?) -> Void)?, onFail: ((Error) -> Void)?) {
    call(path: path, method: .delete, params: nil, onFinish: onFinish, onFail: onFail)
  }
  
  func call(path: String, method: HTTPMethod, params: Parameters?, onFinish: ((Any?) -> Void)?, onFail: ((Error) -> Void)?) {
    Alamofire.request(
      "\(baseURL!)\(path)",
      method: method,
      parameters: params,
      headers: headers
    )
      .validate(statusCode: 200..<300)
      .responseJSON { response in
        switch response.result {
        case .success:
          let json: Any? = try? JSONSerialization.jsonObject(with: response.data!, options: [])
          if (onFinish != nil) {
            onFinish!(json)
          }
        case .failure(let error):
          let appDelegate = UIApplication.shared.delegate as! AppDelegate
          appDelegate.showAlert(title: "Anfrage fehlgeschlagen", message: error.localizedDescription)
          if (onFail != nil) {
            onFail!(error)
          }
        }
    }
  }
}
