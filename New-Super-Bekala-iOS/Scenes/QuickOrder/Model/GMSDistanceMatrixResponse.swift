
import Foundation

// MARK: - GMSDistanceMatrixResponse
struct GMSDistanceMatrixResponse: Codable {
    let destinationAddresses, originAddresses: [String]
    let rows: [Row]
    let status: String

    enum CodingKeys: String, CodingKey {
        case destinationAddresses = "destination_addresses"
        case originAddresses = "origin_addresses"
        case rows, status
    }
}

// MARK: - Row
struct Row: Codable {
    let elements: [Element]
}

// MARK: - Element
struct Element: Codable {
    let distance, duration: Distance
    let status: String
}

// MARK: - Distance
struct Distance: Codable {
    let text: String
    let value: Int
}

