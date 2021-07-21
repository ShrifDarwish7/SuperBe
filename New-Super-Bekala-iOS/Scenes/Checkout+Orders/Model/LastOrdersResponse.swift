//
//  LastOrdersResponse.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 21/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

// MARK: - LastOrdersResponse
struct LastOrdersResponse: Codable {
    let status: Int?
    let data: [LastOrder]?
    let message: String?
}

// MARK: - Datum
struct LastOrder: Codable {
    let id: Int?
    let status: String?
    let linesTotal, shippingTotal, taxesTotal, discountTotal: Double?
    let orderTotal: Double?
    let customerNote: String?
    let paymentMethod: Int?
    let userID, addressID, branchID, beingEdited: Int?
    let createdAt, updatedAt: String?
    let branch: LastOrderBranch?
    let lineItems: [LastOrderLineItem]?
    let address: Address?
    let files: [String]?
    let coupons: [String]?
    let paidFromWallet: Double?
    let originCoords, destinationCoords, originAddress, destinationAddress: String?

    enum CodingKeys: String, CodingKey {
        case id, status
        case linesTotal = "lines_total"
        case shippingTotal = "shipping_total"
        case taxesTotal = "taxes_total"
        case discountTotal = "discount_total"
        case orderTotal = "order_total"
        case customerNote = "customer_note"
        case paymentMethod = "payment_method"
        case userID = "user_id"
        case addressID = "address_id"
        case branchID = "branch_id"
        case beingEdited = "being_edited"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case branch, coupons
        case lineItems = "line_items"
        case address, files
        case paidFromWallet = "paid_from_wallet"
        case originCoords = "origin_coordinates"
        case destinationCoords = "destination_coordinates"
        case originAddress = "origin_address"
        case destinationAddress = "destination_address"
    }
}

// MARK: - Branch
struct LastOrderBranch: Codable {
    let id: Int?
    let nameEn, nameAr, logo: String?
    let vendorID: Int?
    let rating: String?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case id
        case nameEn = "name_en"
        case nameAr = "name_ar"
        case logo, rating
        case vendorID = "vendor_id"
        case name
    }
}

// MARK: - LineItem
struct LastOrderLineItem: Codable {
    let id, quantity: Int
    let linePrice: Double?
    let lineNotes: String?
    let orderID: Int
    let variations: [Variation]?
    let branchProduct: Product?

    enum CodingKeys: String, CodingKey {
        case id
        case linePrice = "line_price"
        case quantity
        case lineNotes = "line_notes"
        case orderID = "order_id"
        case variations
        case branchProduct = "branch_product"
    }
}


