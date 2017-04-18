//
//  Configuration.swift
//  app
//
//  Created by Marten Klitzke on 15.04.2017.
//  Copyright © 2017 Marten Klitzke. All rights reserved.
//
import Foundation

enum Environment: String {
  case Local = "alpha"
  case Production = "production"

  var baseURL: String {
    switch self {
    case .Local: return "http://api.reckoning.dev/v1"
    case .Production: return "https://api.reckoning.io/v1"
    }
  }
}

struct Configuration {
  lazy var environment: Environment = {
    #if (arch(i386) || arch(x86_64)) && (os(iOS) || os(watchOS) || os(tvOS))
      return Environment.Local
    #else
      return Environment.Production
    #endif
  }()
}
