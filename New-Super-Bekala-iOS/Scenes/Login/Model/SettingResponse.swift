//
//  SettingResponse.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 24/10/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

// MARK: - SettingResponse
struct SettingResponse: Codable {
    let status: Int
    let data: Setting
    let message: String?
}

struct Setting: Codable {
    let id, appClosed: Int
    let appCloseMessage, appCloseImage: String?
    let skipOtpVerification, allowCaptainsToHaveMultipleOrders, maxNumberOfOrdersPerCaptain: Int?
    let androidUserLastAllowedVersion, iosUserLastAllowedVersion, deliveryLastAllowedVersion, vendorLastAllowedVersion: String?
    let androidUserLatestVersion, iosUserLatestVersion, deliveryLatestVersion, vendorLatestVersion: String?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case appClosed = "app_closed"
        case appCloseMessage = "app_close_message"
        case appCloseImage = "app_close_image"
        case skipOtpVerification = "skip_otp_verification"
        case allowCaptainsToHaveMultipleOrders = "allow_captains_to_have_multiple_orders"
        case maxNumberOfOrdersPerCaptain = "max_number_of_orders_per_captain"
        case androidUserLastAllowedVersion = "android_user_last_allowed_version"
        case iosUserLastAllowedVersion = "ios_user_last_allowed_version"
        case deliveryLastAllowedVersion = "delivery_last_allowed_version"
        case vendorLastAllowedVersion = "vendor_last_allowed_version"
        case androidUserLatestVersion = "android_user_latest_version"
        case iosUserLatestVersion = "ios_user_latest_version"
        case deliveryLatestVersion = "delivery_latest_version"
        case vendorLatestVersion = "vendor_latest_version"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
