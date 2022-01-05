//
//  CouponResponse.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 11/10/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

struct Coupon: Codable {
    let id: Int
    let name: Localized?
    let couponResponseDescription: Localized?
    let code: String?
    
    var branch: Int?

    enum CodingKeys: String, CodingKey {
        case id, name
        case couponResponseDescription = "description"
        case code
    }
}
