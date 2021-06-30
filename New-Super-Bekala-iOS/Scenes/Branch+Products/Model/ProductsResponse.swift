//
//  ProductsResponse.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 31/03/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ProductsResponse
struct ProductsResponse: Codable {
    let status: Int
    let data: [Product]
    let message: String
}

struct Product: Codable {
    var name: Localized?
    var description: Localized?
    var id: Int?
    var sku: String?
    var inStock: Int?
    var images: [String]?
    var price, salePrice: Int?
    var startTime, endTime, productionDate, expDate: String?
    var saleStartDate, saleEndDate: String?
    var branchID, productID, branchCategoryID: Int?
    var branchImage: String?
    var branch: Branch?
    var variations: [Variation]?
    
    var quantity: Int = 1
    var notes: String = ""
    var desc: String = ""
    var voice: Data?
    var photos: [UIImage]?
    var text: String?

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case sku = "SKU"
        case inStock = "in_stock"
        case images, price
        case salePrice = "sale_price"
        case startTime = "start_time"
        case endTime = "end_time"
        case productionDate = "production_date"
        case expDate = "exp_date"
        case saleStartDate = "sale_start_date"
        case saleEndDate = "sale_end_date"
        case branchID = "branch_id"
        case productID = "product_id"
        case branchCategoryID = "branch_category_id"
        case variations, branch
        case branchImage = "branch_image"
    }
}

// MARK: - Variation
struct Variation: Codable {
    
    var id: Int?
    var name: Localized?
    var isAddition, variationID, branchProductID: Int?
    var isRequired: Int?
    var max, min: Int?
    var options: [Option]?
    
    var expanded = true

    enum CodingKeys: String, CodingKey {
        case id, name
        case isAddition = "is_addition"
        case variationID = "variation_id"
        case branchProductID = "branch_product_id"
        case options
        case isRequired = "is_required"
        case max = "max_options"
        case min = "min_options"
    }
}

// MARK: - Option
struct Option: Codable{
    
    var id: Int?
    var name: Localized?
    var price, branchVariationID, inStock, salePrice: Int?
    
    var selected: Bool = false
    //var checked: Bool = false

    enum CodingKeys: String, CodingKey {
        case id, name
        case price
        case branchVariationID = "branch_variation_id"
        case inStock = "in_stock"
        case salePrice = "sale_price"
        
    }
    
}
