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
    static let storageBase = "https://dev4.superbekala.com/storage/"
    static var headers = [
        "Authorization": "Bearer " + (APIServices.shared.user?.token ?? ""),
        "Accept": "application/json",
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
    static var mapState: MapState?
    static var transaction: Transaction?
    static var selectedServices: SelectedServices?
    static var superService: SuperService?
}

enum SelectedServices{
    case images
    case voice
    case text
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

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
