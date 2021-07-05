// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let pointsResponse = try? newJSONDecoder().decode(PointsResponse.self, from: jsonData)

import Foundation

struct TransactionPayload: Codable {
    let apiOperation: String?
    let order: TransactionOrder?
    let session: Session?
    let authentication: Authentication?
    let customer: Customer?
    let device: Device?
    let sourceOfFunds: SourceOfFunds?
}

// MARK: - Authentication
struct Authentication: Codable {
    let redirectResponseURL, acceptVersions, channel, purpose: String?
    let the3Ds: The3Ds?
    let the3Ds1: The3Ds1?
    
    enum CodingKeys: String, CodingKey {
        case redirectResponseURL = "redirectResponseUrl"
        case acceptVersions, channel, purpose
        case the3Ds = "3ds"
        case the3Ds1 = "3ds1"
    }
}

// MARK: - Customer
struct Customer: Codable {
    let firstName, email, lastName: String
}

// MARK: - Device
struct Device: Codable {
    let browserDetails: BrowserDetails
    let browser, ipAddress: String
}

// MARK: - BrowserDetails
struct BrowserDetails: Codable {
    let javaEnabled, language, screenHeight, screenWidth: String
    let timeZone, colorDepth, acceptHeaders, the3DSecureChallengeWindowSize: String

    enum CodingKeys: String, CodingKey {
        case javaEnabled, language, screenHeight, screenWidth, timeZone, colorDepth, acceptHeaders
        case the3DSecureChallengeWindowSize = "3DSecureChallengeWindowSize"
    }
}

// MARK: - Order
struct TransactionOrder: Codable {
    let id,amount, currency: String?
}

// MARK: - Session
struct Session: Codable {
    let id: String
}

// MARK: - The3Ds
struct The3Ds: Codable {
    let acsEci, authenticationToken, transactionID: String

    enum CodingKeys: String, CodingKey {
        case acsEci, authenticationToken
        case transactionID = "transactionId"
    }
}

// MARK: - The3Ds1
struct The3Ds1: Codable {
    let paResStatus, veResEnrolled: String
}
