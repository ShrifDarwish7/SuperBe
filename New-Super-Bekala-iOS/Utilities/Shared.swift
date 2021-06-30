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
        "Authorization": "Bearer " + (APIServices.shared.user?.token ?? ""),
//        "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiYjM5YjE2YjU5MTE4MmJjZDUyNTM1ZDUxZTgxYzI1MTg3NDk1Zjk3MmU0YTkzN2IyNDdhMzNkOTRjMmRkZWI2NWUzN2Q2OGI0MDE2Y2FhN2MiLCJpYXQiOjE2MjI5NzM4NzcuMTE1NjYzMDUxNjA1MjI0NjA5Mzc1LCJuYmYiOjE2MjI5NzM4NzcuMTE1NjY4MDU4Mzk1Mzg1NzQyMTg3NSwiZXhwIjoxNjU0NTA5ODc3LjExMTE2NDA5MzAxNzU3ODEyNSwic3ViIjoiMSIsInNjb3BlcyI6W119.lqoJnNbIbmWIakd8d75qqJj97IyOijYZk5orlmSGhxYZaVLhEi49vlV7sjbQnxv9H5BFl1deWtSBbdtV2kbyz5MXS9E2aRSMt3BoByyt1VIjzX_SiOIuuVrPmNkGMyFEO3iIlK0fJeJG4syg5-UNvuyyl85-xXa1XKgl_f3rcTzsYjZqeZRDsUgi97IMM2Jn-14s65G6ry0BtRhLLnTLXdzpjOkbk_srloH5vPmCca6XHqjsgpUrvonCXAOv3UWLdEStBcwpa2GYNT549Pox_J3_i72IAsEPoCp_R8a1qE5OsUsnoQ0D23FPyelV18rARNH9BWlPrQLrD7njWPxVhIqivHm70brvduZE23NeTUuKsX_K68UJGFZdOEt3D3UbwQ9ak5uT-NVCy104mkFF4YW0dVQpquM37JZ3idmGm7oUQOAWYbgYES3gRfNRqi7__Ub26dJko2LSCFnlUPS8rKdFww3vl2TnuEOW5gazl8jHW2DD5e6gCQYxwkUonv5oZl5RueVBxI4xPpiULl6l3jbi9OBtT-69-ufvWLUy_KLVTQlJ3tKPjuw6_-otqXHrc-cWeK7ueXQ-uSUGeRYwYOodrauh9bUHppx_Yjd-tmggtY25AqhCJhRKmMeHkmIcAQNIumdDfd0pBz6Xs0B4pYfW62LQc9fmIsoGZsrsPiY",
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
//    static var transaction: Transaction?{
//        set{
//            UserDefaults.init().setValue(try! JSONEncoder.init().encode(newValue), forKey: "transaction")
//        }
//        get{
//            let data = UserDefaults.init().data(forKey: "transaction")
//            return (data?.getDecodedObject(from: Transaction.self)) ?? nil
//        }
//    }
//    static var cartIncrementalID: Int{
//        set { UserDefaults.init().setValue(newValue, forKey: "cart_quick_orders_incremental_id") }
//        get { return UserDefaults.init().integer(forKey: "cart_quick_orders_incremental_id") }
//    }
    static var mapState: MapState?
    static var transaction: Transaction?
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


extension UIViewController{
    func replaceView(containerView: UIView, identifier: String, storyboard: AppStoryboard) {
        containerView.subviews.forEach({ $0.removeFromSuperview() })
        let vc =
       // self.storyboard!.instantiateViewController(withIdentifier: identifier)
        Router.instantiate(appStoryboard: storyboard, identifier: identifier)
        vc.view.frame = containerView.bounds;
        containerView.addSubview(vc.view)
        self.addChild(vc)
        vc.didMove(toParent: self)
    }
}
