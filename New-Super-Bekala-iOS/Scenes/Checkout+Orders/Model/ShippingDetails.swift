//
//  ShippingDetails.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 04/08/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

class ShippingDetailsResponse: Codable {
    let status: Int
    let data: ShippingDetails?
    let message: String?
}

// MARK: - DataClass
class ShippingDetails: Codable {
    let originAddress, destinationAddress, distanceKM, duration: String?
    let shippingCost: String?

    enum CodingKeys: String, CodingKey {
        case originAddress = "origin_address"
        case destinationAddress = "destination_address"
        case distanceKM = "distance_km"
        case duration
        case shippingCost = "shipping_cost"
    }
}
