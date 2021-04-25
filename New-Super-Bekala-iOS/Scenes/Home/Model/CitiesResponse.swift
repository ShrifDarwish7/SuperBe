//
//  CitiesResponse.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 11/03/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

struct CitiesResponse: Codable {
    let status: Int
    let data: [City]
    let message: String
}

struct City: Codable {
    let id, countryID: Int?
    let phoneCode: String?
    let regionsCount: Int?
    let cityLanguage: [Language]?
    let regions: [Region]?

    enum CodingKeys: String, CodingKey {
        case id
        case countryID = "country_id"
        case phoneCode = "phone_code"
        case regionsCount = "regions_count"
        case cityLanguage = "city_language"
        case regions
    }
}

