//
//  ConnectionManager.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 22/07/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import Reachability

class ConnectionManager {

    static let shared = ConnectionManager()
    private init () {}

    func hasConnectivity() -> Bool {
        do {
            let reachability: Reachability = try Reachability()
            let networkStatus = reachability.connection

            switch networkStatus {
            case .unavailable:
                return false
            case .wifi, .cellular:
                return true
            case .none:
                return false
            }
        }
        catch {
            return false
        }
    }
}
