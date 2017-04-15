//
//  Configuration.swift
//  app
//
//  Created by Marten Klitzke on 15.04.2017.
//  Copyright © 2017 Marten Klitzke. All rights reserved.
//

import Foundation

enum Environment: String {
    case Alpha = "alpha"
    case Production = "production"
    
    var baseURL: String {
        switch self {
        case .Alpha: return "http://api.reckoning.dev/v1"
        case .Production: return "https://api.reckoning.io/v1"
        }
    }
    
    var token: String {
        switch self {
        case .Alpha: return "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjA3M2JkMjNjLTM4NTEtNGFjOS04ZmI1LWY3MjVjYjIxOWEwNyIsImV4cCI6MTQ5MjMzNTE3OH0.lu12S7WdiURq8UuuwP305RauiPbFoL6BmRuq2GeFKw0"
        case .Production: return ""
        }
    }
}

struct Configuration {
    lazy var environment: Environment = {
        if let configuration = Bundle.main.object(forInfoDictionaryKey: "Environment") as? String {
            if configuration == "Production" {
                return Environment.Production
            }
        }
        
        return Environment.Alpha
    }()
}
