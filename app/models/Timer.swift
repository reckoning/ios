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

struct Timer {
    let id: String
    let value: String
    let startedAt: String?
    let projectName: String
}

extension Timer: Decodable {
    static func decode(_ j: JSON) -> Decoded<Timer> {
    return curry(Timer.init)
        <^> j <| "id"
        <*> j <| "value"
        <*> j <|? "startedAt"
        <*> j <| "projectName"
    }
}
