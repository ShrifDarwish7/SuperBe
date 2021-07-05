//
//  CardPayload.swift
//  Super Bekala iOS
//
//  Created by Sherif Darwish on 16/06/2021.
//  Copyright © 2021 mobidevlabs. All rights reserved.
//

import Foundation

// MARK: - PointsResponse
struct CardPayload: Codable {
    let sourceOfFunds: SourceOfFunds
}

// MARK: - SourceOfFunds
struct SourceOfFunds: Codable {
    let provided: Provided?
    let type: String
}

// MARK: - Provided
struct Provided: Codable {
    let card: Card
}

// MARK: - Card
struct Card: Codable {
    let expiry: Expiry
    let number: String
    let securityCode: String
    let storedOnFile: String
    let nameOnCard: String
}

// MARK: - Expiry
struct Expiry: Codable {
    let month, year: String
}
