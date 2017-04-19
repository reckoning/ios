//
//  Timer.swift
//  app
//
//  Created by Marten Klitzke on 14.04.2017.
//  Copyright © 2017 Marten Klitzke. All rights reserved.
//

import Argo
import Curry
import Runes
import Alamofire

struct Timer {
  let id: String
  let value: String
  let date: String
  let startedAt: String?
  let projectName: String
  let projectCustomerName: String
  let taskName: String
  
  static func all(onFinish: @escaping (Array<Timer>) -> Void, onFail: @escaping (Error) -> Void) {
    let params: Parameters = ["limit": 20]
    ApiClient().get(path: "/timers", params: params, onFinish: { (data) in
      var timers: Array<Timer> = []
      for item in data as! Array<Any> {
        let decodedTimer = Timer.decode(JSON(item))
        let timer = decodedTimer.value
        timers.append(timer!)
      }
      onFinish(timers)
    }, onFail: onFail)
  }
  
  func start(onFinish: @escaping (Timer) -> Void) {
    ApiClient().put(path: "/timers/\(id)/start", params: nil, onFinish: { (data) in
      onFinish(Timer.decode(JSON(data!)).value!)
    }, onFail: nil)
  }
  
  func stop(onFinish: @escaping (Timer) -> Void) {
    ApiClient().put(path: "/timers/\(id)/stop", params: nil, onFinish: { (data) in
      onFinish(Timer.decode(JSON(data!)).value!)
    }, onFail: nil)
  }
}

extension Timer: Decodable {
  static func decode(_ j: JSON) -> Decoded<Timer> {
  return curry(Timer.init)
    <^> j <| "id"
    <*> j <| "value"
    <*> j <| "date"
    <*> j <|? "startedAt"
    <*> j <| "projectName"
    <*> j <| "projectCustomerName"
    <*> j <| "taskName"
  }
}
