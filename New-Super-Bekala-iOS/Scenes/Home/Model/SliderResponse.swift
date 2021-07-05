//
//  SliderResponse.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 05/07/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

// MARK: - SliderResponse
struct SliderResponse: Codable {
    let status: Int
    let data: [Slider]
    let message: String
}

struct Slider: Codable {
    let id: Int
    let name, image: Localized
    let slidableType: SliderType
    let slidableID: Int
    let actionURL: String?
    let cityID, regionID: Int

    enum CodingKeys: String, CodingKey {
        case id, name, image
        case slidableType = "slidable_type"
        case slidableID = "slidable_id"
        case actionURL = "action_url"
        case cityID = "city_id"
        case regionID = "region_id"
    }
}

enum SliderType: String, Codable{
    case branch = "App\\Models\\Branch"
    case product = "App\\Models\\BranchProduct"
}
