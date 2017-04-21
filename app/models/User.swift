//
//  User.swift
//  app
//
//  Created by Marten Klitzke on 20.04.2017.
//  Copyright © 2017 Marten Klitzke. All rights reserved.
//

import Argo
import Curry
import Runes
import Alamofire

struct User {
  let id: String
  let email: String
  let name: String
  let createdAt: String
  let updatedAt: String
  
  static func current(onFinish: @escaping (User) -> Void, onFail: @escaping (Error) -> Void) {
    ApiClient().get(path: "/users/current", params: nil, onFinish: { (data) in
      onFinish(User.decode(JSON(data!)).value!)
    }, onFail: onFail)
  }
}

extension User: Decodable {
  static func decode(_ j: JSON) -> Decoded<User> {
    return curry(User.init)
      <^> j <| "id"
      <*> j <| "email"
      <*> j <| "name"
      <*> j <| "createdAt"
      <*> j <| "updatedAt"
  }
}
