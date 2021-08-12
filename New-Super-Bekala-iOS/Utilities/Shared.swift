//
//  Shared.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 23/01/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import CoreLocation
import PusherSwift

class Shared{
    
    static var GMS_KEY = "AIzaSyCyAPJ2M7dyEAyC33zqVCyXlWlWRszYH4U"
  //  static var userLat: CLLocationDegrees?
  //  static var userLng: CLLocationDegrees?
    static let errorMsg = "An error occuered, please try again later".localized
    static var isChatting: Bool{
        set { UserDefaults.init().setValue(newValue, forKey: "is_chatting") }
        get { UserDefaults.init().bool(forKey: "is_chatting") }
    }
    static let storageBase = "https://dev4.superbekala.com/storage/"
    static var headers = [
        "Authorization": "Bearer " + (APIServices.shared.user?.token ?? ""),
        "Accept": "application/json",
        //"lang": "lang".localized
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
    static var favBranches: [Branch]?
    static var favProducts: [Product]?
    static var currentConversationId: Int?{
        set { UserDefaults.init().setValue(newValue, forKey: "current_conversation_id") }
        get { return UserDefaults.init().integer(forKey: "current_conversation_id") }
    }
    static var deliveringToTitle: String?{
        set { UserDefaults.init().setValue(newValue, forKey: "delivering_to") }
        get { return UserDefaults.init().string(forKey: "delivering_to") }
    }
    static var currentConversationAdminName: String?{
        set { UserDefaults.init().setValue(newValue, forKey: "current_conversation_admin_name") }
        get { return UserDefaults.init().string(forKey: "current_conversation_admin_name") }
    }
    static var currentConversationAdminAvatar: String?{
        set { UserDefaults.init().setValue(newValue, forKey: "current_conversation_admin_avatar") }
        get { return UserDefaults.init().string(forKey: "current_conversation_admin_avatar") }
    }
    
    static func call(phoneNumber: String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
            
        }
    }
}

enum SelectedServices{
    case images
    case voice
    case text
}

