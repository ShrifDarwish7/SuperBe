//
//  TagsResponse.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 28/10/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation


// MARK: - Welcome
struct TagsResponse: Codable {
    let status: Int
    let data: [Tag]?
    let message: String?
}

struct Tag: Codable {
    let id: Int
    let name: Localized?
    let logo: String?
    let isFilter: Int

    var selected: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id, name, logo
        case isFilter = "is_filter"
    }
}
