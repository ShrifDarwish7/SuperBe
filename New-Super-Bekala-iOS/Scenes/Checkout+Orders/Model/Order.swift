//
//  Order.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 19/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

// MARK: - Order
struct Order: Codable {
    let deliveryMethod,paymentMethod, addressID: Int
    let customerNote: String
    let couponID: [String]
    let branchID: Int
    let lineItems: [LineItem]

    enum CodingKeys: String, CodingKey {
        case deliveryMethod = "delivery_method"
        case paymentMethod = "payment_method"
        case addressID = "address_id"
        case customerNote = "customer_note"
        case couponID = "coupon_id"
        case branchID = "branch_id"
        case lineItems = "line_items"
    }
}

// MARK: - LineItem
struct LineItem: Codable {
    let variations: [LineItemVariation]?
    let lineNotes: String?
    let quantity, branchProductID: Int?

    enum CodingKeys: String, CodingKey {
        case branchProductID = "branch_product_id"
        case quantity
        case lineNotes = "line_notes"
        case variations
    }
}

struct LineItemVariation: Codable{
    let id: Int?
    let options: [Int]?
    
    enum CodingKeys: String, CodingKey{
        case id = "variation_id"
        case options
    }
}
