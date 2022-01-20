//
//  Transaction.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 06/06/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

struct Transaction: Codable {
    
    var session: String?
    
    // basic transaction properties
    var amount: Double?
    var amountString: String?
    var currency: String?
    
    // card information
    var nameOnCard: String?
    var cardNumber: String?
    var expiryMM: String?
    var expiryYY: String?
    var cvv: String?
    
    var orderId: String = Transaction.randomID()
    
    static func randomID() -> String {
        return String(UUID().uuidString.split(separator: "-").first!)
    }
}
