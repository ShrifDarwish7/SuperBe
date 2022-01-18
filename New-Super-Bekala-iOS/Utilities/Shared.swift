//
//  Shared.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 23/01/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import CoreLocation
import AVFoundation
import UIKit

class Shared{
    
    static var GMS_KEY = "AIzaSyCyAPJ2M7dyEAyC33zqVCyXlWlWRszYH4U"
  //  static var userLat: CLLocationDegrees?
  //  static var userLng: CLLocationDegrees?
    static let errorMsg = "An error occuered, please try again later".localized
    static let defaultLat = 31.264307
    static let defaultLng = 32.282316
    static var isChatting: Bool{
        set { UserDefaults.init().setValue(newValue, forKey: "is_chatting") }
        get { UserDefaults.init().bool(forKey: "is_chatting") }
    }
    static let storageBase = "https://new.superbekala.com/storage/"
    static var headers = [
        "Authorization": "Bearer " + (UserDefaults.init().string(forKey: "token") ?? ""),
        "Accept": "application/json",
        //"lang": "lang".localized
    ]
    static var isRegion: Bool{
        set { UserDefaults.init().setValue(newValue, forKey: "is_region") }
        get { UserDefaults.init().bool(forKey: "is_region") }
    }
//    static var coupons: [Coupon]?{
//        set{
//            UserDefaults.init().setValue(try! JSONEncoder.init().encode(newValue), forKey: "coupons")
//        }
//        get{
//            let data = UserDefaults.init().data(forKey: "coupons")
//            return (data?.getDecodedObject(from: [Coupon].self)) ?? nil
//        }
//    }
    static var coupons: [Coupon] = []
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
    static var didGetProfileHint: Bool{
        set { UserDefaults.init().setValue(newValue, forKey: "profile_hint") }
        get { return UserDefaults.init().bool(forKey: "profile_hint") }
    }
    static var didGetProfileInsideHint: Bool{
        set { UserDefaults.init().setValue(newValue, forKey: "inside_profile_hint") }
        get { return UserDefaults.init().bool(forKey: "inside_profile_hint") }
    }
    static var didGetServiceHint: Bool{
        set { UserDefaults.init().setValue(newValue, forKey: "service_hint") }
        get { return UserDefaults.init().bool(forKey: "service_hint") }
    }
    static var unseenMessages: Int{
        set { UserDefaults.init().setValue(newValue, forKey: "unseen_messages") }
        get { return UserDefaults.init().integer(forKey: "unseen_messages") }
    }
    static var selectedOrders = true
    static var mapState: MapState?
    static var transaction: Transaction?
    static var selectedServices: SelectedServices?
    static var superService: SuperService?
    static var favBranches: [Branch]?
    static var shouldShowCategories = false
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
    static var orderChatting: Bool?{
        set { UserDefaults.init().setValue(newValue, forKey: "order_chatting") }
        get { return UserDefaults.init().bool(forKey: "order_chatting") }
    }
    static var orderChattingId: Int?{
        set { UserDefaults.init().setValue(newValue, forKey: "order_chatting_id") }
        get { return UserDefaults.init().integer(forKey: "order_chatting_id") }
    }
    static func call(phoneNumber: String) {
       if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    static func play(_ sound: String,_ player: inout AVAudioPlayer?){
        let msgNotifyURL = URL(fileURLWithPath: Bundle.main.path(forResource: sound, ofType: "mp3")!)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: msgNotifyURL)
            guard let player = player else { return }
            player.play()
        } catch { }
    }
}

enum SelectedServices{
    case images
    case voice
    case text
}

