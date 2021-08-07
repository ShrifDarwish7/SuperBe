//
//  ValidatableCoupon.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 01/08/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

struct ValidatableCoupon: Codable{
    
    var coupons: [String]
    var branchId: Int
    var lang = "lang".localized
    var lineItems: [LineItem]
    
    enum CodingKeys: String, CodingKey{
        case coupons
        case branchId = "branch_id"
        case lineItems = "line_items"
    }
    
}
