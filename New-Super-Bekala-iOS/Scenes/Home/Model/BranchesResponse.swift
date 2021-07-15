//
//  BranchesResponse.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 16/03/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

// MARK: - BranchesResponse
struct BranchesResponse: Codable {
    let status: Int?
    let data: [Branch]
    let message: String?
}

struct Branch: Codable {
    let id: Int
    let bio: Localized?
    let name: Localized?
    let phones, emails, fax: [String?]?
    let website: String?
    let isNewBranch: Int?
    let postalCode, street: String?
    let landmark, buildingNumber, floorNumber, flatNumber: String?
    let logo: String?
    let images: [String]?
    let acceptWalletPayment, fastDelivery, vendorDelivery, receiveFromShop, supportDelivery, creditOnDelivery: Int?
    let coordinates: String?
    let quickOrder, quickVoice, receiveCalls, cashOnDelivery: Int?
    let onlinePayment, acceptCoupons, acceptChats, isFeatured: Int?
    let hasOnsaleProducts, hasFeaturedProducts, minOrder: Int?
    let deliveryFees, isOpen, isBusy, isOnhold: Int?
    let closedMessage, openingTime, closingTime, deliveryStartTime: String?
   // let rating: Double?
    let deliveryEndTime: String?
    let deliveryAreas: [String]?
    let deliveryDuration: Int?
    let deliveryDistance: Int?
    let priority, reviewCount, enableSelling: Int?
    let commissionType: String?
    let commissionValue, separateAccounting: Int?
    let facebook, twitter, youtube, instagram: String?
    let pinterest: String?
    let marketNote: String?
    let addedBy: Int?
    let updatedBy: Int?
    let beingEdited: Int?
    let customOpenCloseTimes: CustomOpenCloseTimes?
    let deliveryRegions: [DeliveryRegion]?
    let beingEditedBy: String?
    let vendorID, userID, regionID: Int?
   // let user: BranchUser?
    var isFavourite: Int?
    var products: [Product]?
    //let openCloseTimes: String?
    var favouriteId: Int?
    var useCustomTimes: Int?
    
    var selected: Bool?

    enum CodingKeys: String, CodingKey {
        case id, bio, phones, emails, fax, website, name
        case isNewBranch = "is_new_branch"
        case postalCode = "postal_code"
        case street, landmark
        case buildingNumber = "building_number"
        case floorNumber = "floor_number"
        case flatNumber = "flat_number"
        case logo, images
        case acceptWalletPayment = "accept_wallet_payment"
        case fastDelivery = "fast_delivery"
        case vendorDelivery = "vendor_delivery"
        case receiveFromShop = "receive_from_shop"
        case coordinates
        case quickOrder = "quick_order"
        case quickVoice = "quick_voice"
        case receiveCalls = "receive_calls"
        case cashOnDelivery = "cash_on_delivery"
        case onlinePayment = "online_payment"
        case acceptCoupons = "accept_coupons"
        case acceptChats = "accept_chats"
        case isFeatured = "is_featured"
        case hasOnsaleProducts = "has_onsale_products"
        case hasFeaturedProducts = "has_featured_products"
       // case rating
        case minOrder = "min_order"
        case deliveryFees = "delivery_fees"
        case isOpen = "is_open"
        case isBusy = "is_busy"
        case isOnhold = "is_onhold"
        case closedMessage = "closed_message"
        case openingTime = "opening_time"
        case closingTime = "closing_time"
        case deliveryStartTime = "delivery_start_time"
        case deliveryEndTime = "delivery_end_time"
        case deliveryAreas = "delivery_areas"
        case deliveryDuration = "delivery_duration"
        case deliveryDistance = "delivery_distance"
        case priority
        case reviewCount = "review_count"
        case enableSelling = "enable_selling"
        case commissionType = "commission_type"
        case commissionValue = "commission_value"
        case separateAccounting = "separate_accounting"
        case facebook, twitter, youtube, instagram, pinterest
        case marketNote = "market_note"
        case addedBy = "added_by"
        case updatedBy = "updated_by"
        case beingEdited = "being_edited"
        case beingEditedBy = "being_edited_by"
        case vendorID = "vendor_id"
        case userID = "user_id"
        case regionID = "region_id"
       // case user
      //  case openCloseTimes = "open_close_times"
        case supportDelivery = "support_delivery"
        case creditOnDelivery = "credit_on_delivery"
        case products = "branch_products"
        case isFavourite = "is_favourite"
        case customOpenCloseTimes = "custom_open_close_times"
        case deliveryRegions = "delivery_regions"
        case useCustomTimes = "use_custom_times"
    }
}

struct Localized: Codable {
    let en, ar: String?
}

struct DeliveryRegion: Codable {
    let id: Int
    let name: String
    let cityID: Int
    let coordinates: [String]

    enum CodingKeys: String, CodingKey {
        case id, name
        case cityID = "city_id"
        case coordinates
    }
}

struct CustomOpenCloseTimes: Codable {
    let openingTimeSaturday, openingTimeSunday, openingTimeMonday, openingTimeTuesday: String?
    let openingTimeWednesday, openingTimeThursday: String?
    let openingTimeFriday: String?
    let closingTimeSaturday, closingTimeSunday, closingTimeMonday, closingTimeTuesday: String?
    let closingTimeWednesday, closingTimeThursday: String?
    let closingTimeFriday: String?

    enum CodingKeys: String, CodingKey {
        case openingTimeSaturday = "opening_time_saturday"
        case openingTimeSunday = "opening_time_sunday"
        case openingTimeMonday = "opening_time_monday"
        case openingTimeTuesday = "opening_time_tuesday"
        case openingTimeWednesday = "opening_time_wednesday"
        case openingTimeThursday = "opening_time_thursday"
        case openingTimeFriday = "opening_time_friday"
        case closingTimeSaturday = "closing_time_saturday"
        case closingTimeSunday = "closing_time_sunday"
        case closingTimeMonday = "closing_time_monday"
        case closingTimeTuesday = "closing_time_tuesday"
        case closingTimeWednesday = "closing_time_wednesday"
        case closingTimeThursday = "closing_time_thursday"
        case closingTimeFriday = "closing_time_friday"
    }
}

struct BranchUser: Codable {
    let id: Int?
    let name, email: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email
    }
}
