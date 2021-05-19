//
//  Shared.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 23/01/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class Shared{
    
    static var GMS_KEY = "AIzaSyCyAPJ2M7dyEAyC33zqVCyXlWlWRszYH4U"
    static var userLat: CLLocationDegrees?
    static var userLng: CLLocationDegrees?
    static let errorMsg = "An error occuered, please try again later".localized
    static let storageBase = "https://new.superbekala.com/storage/app/public/"
    static var headers = [
//        "Authorization": "Bearer " + (APIServices.shared.user?.token ?? ""),
        "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiOWEzMWZiMmYyMzkzZjAzZGM3MDZkNmRkYzNjOGExM2VjOTgyNDdkNGI1NmQ2MTM0ZGQ4MTQ4YWMxNzIzMmM0MTYwOTRjYmI5ZWIxYzg0NmYiLCJpYXQiOiIxNjE4MjQxNTc2Ljg2NjUwNCIsIm5iZiI6IjE2MTgyNDE1NzYuODY2NTA4IiwiZXhwIjoiMTY0OTc3NzU3Ni44NTk2NzAiLCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.M9DVakhcLoOqWIe7-xxV-6hNmsz8Q7jzz1bvh9BRf9hXUvsJlQVb0dzE1E7KbHkn6eZu2ipa-lqtbS0-a9VKow6wdWXYfi4femqKoAGutzF-oELzs0e97GJg93yHh-dfcPVeTTVglIZp2l_VDA2kzHuCmsAE4-eswhMzqe0jpEtbS2rIuTQX4aH1U0KRkxH7zM6uw7Of1oJzFeHi70P_9PxZfrBkF89tIkh7GBZFnif1bP2uQsIzQ-e2yIrbZJkIsdfCXDxeO1uQuiD3iwLYGExKfg8APrPMpAJZGb-4pHJyUVtMbtNMvBpxyLNjIvDM4elpuuZ6JYkQi2I0uObEBa5-mYWDtPCQ9QvbiaoyfyA1nc_SJWHMXNwzQ3ClpnWKwlSIycBJr7IYxv_pK3SDrgN_uZPXoW2A08JXklYpH6ZDKTSdv8RWvQbsFAgdmWURiz7iaYCMCE7YOTLz_IsZ-qZHmuLUYTZE4yEfpZgNoQ3DJEVM6zxD6JrcyjZLTvp4CavN-yM2kR7vmxJ3MDe_rh5k-1GIMQDeFHyKuSD_GCl19uwNqdGsXmEdNce8Axf_gTjK9WUbBvxcx-BkGJI6ba72Jl7NeEADKIhwpqkn7TcirjolC_up-o3_ApTqilsdcgmSf5d3ZgWO8xmvG-ujD0Gl6S4NoVRTtJ92GXGxp7I",
        "Accept": "application/json",
       // "lang": "lang".localized
    ]
    static var isRegion: Bool{
        set { UserDefaults.init().setValue(newValue, forKey: "is_region") }
        get { UserDefaults.init().bool(forKey: "is_region") }
    }
    static var isCoords: Bool{
        set { UserDefaults.init().setValue(newValue, forKey: "is_coords") }
        get { UserDefaults.init().bool(forKey: "is_coords") }
    }
    static var selectedArea: SelectedArea{
        set { UserDefaults.init().setValue(try! JSONEncoder().encode(newValue), forKey: "selected_area") }
        get { return try! JSONDecoder().decode(SelectedArea.self, from: UserDefaults.init().data(forKey: "selected_area")!) }
    }
    static var selectedCoords: String{
        set { UserDefaults.init().setValue(newValue, forKey: "selected_coords") }
        get { return UserDefaults.init().string(forKey: "selected_coords") ?? "" }
    }
    static var userSelectLocation: Bool{
        set { UserDefaults.init().setValue(newValue, forKey: "user_select_location") }
        get { return UserDefaults.init().bool(forKey: "user_select_location") }
    }
//    static var cartIncrementalID: Int{
//        set { UserDefaults.init().setValue(newValue, forKey: "cart_quick_orders_incremental_id") }
//        get { return UserDefaults.init().integer(forKey: "cart_quick_orders_incremental_id") }
//    }
    static var mapState: MapState?
}

extension String{
    var localized: String{
        return NSLocalizedString(self, comment: "")
    }
    public var arToEnDigits : String? {
        var str = self
        let map = ["٠": "0",
                   "١": "1",
                   "٢": "2",
                   "٣": "3",
                   "٤": "4",
                   "٥": "5",
                   "٦": "6",
                   "٧": "7",
                   "٨": "8",
                   "٩": "9"]
        map.forEach { str = str.replacingOccurrences(of: $0, with: $1) }
        return str
    }
    public func firstIndex(char: Character) -> Int? {
        if let idx = self.firstIndex(of: char) {
            return self.distance(from: self.startIndex, to: idx)
        }
        return nil
    }
}

