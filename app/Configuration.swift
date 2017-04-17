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
    
    var token: String {
        switch self {
        case .Local: return "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjA3M2JkMjNjLTM4NTEtNGFjOS04ZmI1LWY3MjVjYjIxOWEwNyIsImV4cCI6MTQ5MjMzNTE3OH0.lu12S7WdiURq8UuuwP305RauiPbFoL6BmRuq2GeFKw0"
        case .Production: return "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjA3M2JkMjNjLTM4NTEtNGFjOS04ZmI1LWY3MjVjYjIxOWEwNyIsImV4cCI6MTQ5MjM0NzA1N30.v4W1VpzqfPP6Dd-dAYJOj23JbWPWOpINQ4hkzqm4vrA"
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
