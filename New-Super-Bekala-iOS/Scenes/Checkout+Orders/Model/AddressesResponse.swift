//
//  AddressesResponse.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 08/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

// MARK: - AddressesResponse
struct AddressesResponse: Codable {
    let status: Int
    let data: [Address]?
    let message: String?
}

struct Address: Codable {
    let id: Int
    let title, coordinates, city, dist: String?
    let street, building, floor, flat: String?
    let landmark, phone, notes: String?
    let selected, userID: Int?

    enum CodingKeys: String, CodingKey {
        case id, title, coordinates, city, dist, street, building, floor, flat, landmark, phone, notes, selected
        case userID = "user_id"
    }
}
