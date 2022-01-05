//
//  GMSGeocodeResponse.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 23/01/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import SwiftyJSON

struct GoogleMapAddress {
    var streetNumber: String?
    var route: String?
    var pinCode: String?
    var city: String?
    var area2: String?
    var area3: String?
    var country: String?
    var countryCode: String?
    var formattedAddress: String?
    
    init(_ results: JSON) {
        self.formattedAddress = results.arrayValue.first?["formatted_address"].stringValue
        for addressComponent in (results.arrayValue.first?["address_components"].arrayValue)!{
            if let type = addressComponent["types"].array{
                if (type.first?.stringValue == "street_number") {
                    self.streetNumber = addressComponent["long_name"].stringValue.replacingOccurrences(of: "Unnamed Road", with: "")
                }
                if (type.first?.stringValue == "route") {
                    self.route = addressComponent["long_name"].stringValue
                }
                if (type.first?.stringValue == "postal_code") {
                    self.pinCode = addressComponent["long_name"].stringValue
                }
                if (type.first?.stringValue == "locality" || type.first?.stringValue == "administrative_area_level_1") {
                    self.city = addressComponent["long_name"].stringValue.replacingOccurrences(of: "Governorate", with: "")
                }
                if (type.first?.stringValue == "administrative_area_level_2") {
                    self.area2 = addressComponent["long_name"].stringValue
                }
                if (type.first?.stringValue == "administrative_area_level_3") {
                    self.area3 = addressComponent["long_name"].stringValue
                }
                if (type.first?.stringValue == "country") {
                    self.country = addressComponent["long_name"].stringValue
                    self.countryCode = addressComponent["short_name"].stringValue
                }
            }
        }
    }
    
}
