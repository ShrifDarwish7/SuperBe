//
//  SuperBeProvider.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 23/01/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import Moya
import UIKit

// testing base url: http://dev4.superbekala.com
// production base url: https://new.superbekala.com

enum SuperBe{
    case login(_ prms: [String: String])
    case logout
    case getCities(_ prms: [String: String])
    case getCategories(_ prms: [String: String])
    case getBranches(_ prms: [String: String])
    case getBranchCats(_ id: Int,_ prms: [String: String])
    case getBranchProducts(_ prms: [String: String],_ id: Int)
    case getBranchBy(_ id: Int)
    case getAddresses
    case postAddress(_ prms: [String: Any])
    case updateAddress(_ id: Int,_ prms: [String: String])
    case deleteAddress(_ id: Int)
    case getProductByID(_ branchId: Int,_ productId: Int,_ prms: [String: String])
    case placeOrder(_ encodable: Order)
    case getMyOrders(_ prms: [String: String])
    case search(_ prms: [String: String])
    case points
    case slider(_ prms: [String: String])
    case favourite
    case addToFavourite(_ prms: [String: Any])
    case removeFromFavourtie(_ id: Int)
    case updateOrder(_ id: Int,_ bodyData: [String: String])
    case getOrderBy(_ id: Int,_ prms: [String: String])
    case placeSuperService(_ prms: [String: Any],_ images: [String: UIImage]?,_ voice: Data?)
    case wallet
    case addToWallet(_ prms: [String: Any])
    case getBranchRating(_ id: Int)
    case rate(_ prms: [String: Any])
    case validateCoupons(_ encodable: ValidatableCoupon)
    case getShippingCost(_ prms: [String: String])
    case startConversation
    case startOrderIssueConveration(_ prms: [String: Any])
    case sendMessage(_ id: Int,_ prms: [String: String])
    case getConversation(_ id: Int)
    case reopenConversation(_ id: Int)
    case lockConversation(_ id: Int)
    case updateWallet(_ prms: [String: String])
    case getCaptain(_ id: Int)
    case updateProfile(_ prms: [String: String])
    case verifyOTP(_ prms: [String: String])
    case getProfile
    case requestOtp(_ prms: [String: String])
    case getServices(_ prms: [String: String])
    case setting
    case uploadFilesToOrder(_ orderId: Int,_ images: [UIImage],_ voices: [Data],_ notes: [String])
    case tags
    case productOffers(_ prms: [String: String])
    case couponsOffers(_ prms: [String: String])
    case userCoupons(_ prms: [String: String])
    case getSupportMessages(_ prms: [String: String])
    case getOrderConversation(_ prms: [String: String])
    case getRegion(_ prms: [String: String])
}

extension SuperBe: TargetType{
    public var baseURL: URL{
        return URL(string: "https://new.superbekala.com/api/v1/")!
    }
    
    public var path: String{
        switch self {
        case .login:
            return "firebase/login"
        case .logout:
            return "logout"
        case .getCities:
            return "cities"
        case .getCategories(_):
            return "categories"
        case .getBranches:
            return "branches"
        case .getBranchCats(let id,_):
            return "branches/\(id)/branch_categories"
        case .getBranchProducts(_,let id):
            return "branches/\(id)/products"
        case .getBranchBy(let id):
            return "branches/\(id)"
        case .getAddresses, .postAddress(_):
            return "addresses"
        case .updateAddress(let id, _), .deleteAddress(let id):
            return "addresses/\(id)"
        case .getProductByID(let branchId, let id, _):
            return "branches/\(branchId)/products/\(id)"
        case .placeOrder(_), .getMyOrders(_):
            return "orders"
        case .search(_):
            return "search"
        case .points:
            return "loyalty"
        case .slider(_):
            return "sliders"
        case .favourite, .addToFavourite(_):
            return "favourites"
        case .removeFromFavourtie(let id):
            return "favourites/\(id)"
        case .updateOrder(let id, _):
            return "orders/\(id)"
        case .placeSuperService(_,_,_):
            return "orders/super_services"
        case .wallet, .addToWallet(_),.updateWallet(_):
            return "wallet"
        case .getBranchRating(let id):
            return "branches/\(id)?with=ratings.user"
        case .rate:
            return "rating"
        case .validateCoupons(_):
            return "coupons/validate_coupons"
        case .getShippingCost(_):
            return "orders/shipping_details"
        case .startConversation, .startOrderIssueConveration(_):
            return "chats/conversations"
        case .sendMessage(let id,_):
            return "chats/conversations/\(id)/messages"
        case .getConversation(let id):
            return "chats/conversations/\(id)"
        case .reopenConversation(let id):
            return "chats/conversations/\(id)/reopen"
        case .lockConversation(let id):
            return "chats/conversations/\(id)/lock"
        case .getCaptain(let id):
            return "delivery/\(id)"
        case .updateProfile(_): return "update_profile"
        case .getOrderBy(let id, _):
            return "orders/\(id)"
        case .verifyOTP(_):
            return "sms/verify_otp"
        case .getProfile:
            return "profile"
        case .requestOtp(_):
            return "sms/request_otp"
        case .getServices(_):
            return "orders/super_services"
        case .setting:
            return "settings"
        case .uploadFilesToOrder(_, _, _, _):
            return "orders/quick_order"
        case .tags:
            return "tags"
        case .productOffers(_):
            return "product_offers"
        case .couponsOffers(_):
            return "coupon_offers"
        case .userCoupons(_):
            return "user_coupons"
        case .getSupportMessages(_):
            return "chats/get_support_conversation"
        case .getOrderConversation(_):
            return "chats/conversations"
        case .getRegion(_):
            return "get_region_by_coordinates"
        }
    }
    
    public var method: Moya.Method{
        switch self {
        case .login,
             .postAddress(_),
             .placeOrder(_),
             .addToFavourite(_),
             .placeSuperService(_,_,_),
             .addToWallet(_),
             .rate(_),
             .validateCoupons(_),
             .startConversation,
             .sendMessage(_, _),
             .reopenConversation(_),
             .lockConversation(_),
             .updateWallet(_),
             .startOrderIssueConveration(_),
             .verifyOTP(_),
             .uploadFilesToOrder(_,_,_,_),
             .logout:
            return .post
        case .updateAddress(_, _),
             .updateOrder(_, _),
             .updateProfile(_):
            return .put
        case .deleteAddress(_), .removeFromFavourtie(_):
            return .delete
        default:
            return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task{
        switch self {
        case .login(let prms),
             .getCities(let prms),
             .getCategories(let prms),
             .getBranches(let prms),
             .getBranchCats(_, let prms),
             .getBranchProducts(let prms, _),
             .updateAddress(_, let prms),
             .getProductByID(_, _, let prms),
             .getMyOrders(let prms),
             .search(let prms),
             .slider(let prms),
             .getShippingCost(let prms),
             .updateWallet(let prms),
             .getOrderBy(_, let prms),
             .verifyOTP(let prms),
             .requestOtp(let prms),
             .getServices(let prms),
             .productOffers(let prms),
             .couponsOffers(let prms),
             .userCoupons(let prms),
             .getSupportMessages(let prms),
             .getOrderConversation(let prms),
             .getRegion(let prms):
            return .requestParameters(parameters: prms, encoding: URLEncoding.default)
        case .postAddress(let prms),
             .addToFavourite(let prms),
             .addToWallet(let prms),
             .rate(let prms),
             .startOrderIssueConveration(let prms):
            var multipartFormData = [MultipartFormData]()
            for (key,value) in prms{
                let formData = MultipartFormData(provider: .data("\(value)".data(using: .utf8)!), name: key)
                multipartFormData.append(formData)
            }
            return .uploadMultipart(multipartFormData)
        case .placeSuperService(let prms, let images, let voice):
            var multipartFormData = [MultipartFormData]()
            if let images = images{
                for (key,value) in images{
                    let imageData = value.jpegData(compressionQuality: 0.2)
                    let formData: Moya.MultipartFormData = Moya.MultipartFormData(provider: .data(imageData!), name: key, fileName: "\(key).jpg", mimeType: "image/jpeg")
                    multipartFormData.append(formData)
                }
            }else if let voice = voice{
                let formData: Moya.MultipartFormData = Moya.MultipartFormData(provider: .data(voice), name: "files[0]", fileName: "file.m4a", mimeType: "audio/m4a")
                multipartFormData.append(formData)
            }
            for (key,value) in prms{
                let formData = MultipartFormData(provider: .data("\(value)".data(using: .utf8)!), name: key)
                multipartFormData.append(formData)
            }
            return .uploadMultipart(multipartFormData)
        case .updateOrder(_, let prms),
             .sendMessage(_, let prms),
             .updateProfile(let prms):
            return .requestParameters(parameters: prms, encoding: JSONEncoding.default)
        case .placeOrder(let encodable):
            return .requestJSONEncodable(encodable)
        case .validateCoupons(let encodable):
            return .requestJSONEncodable(encodable)
        case .uploadFilesToOrder(let id, let images, let voices, let notes):
            var multipartFormData = [MultipartFormData]()
            if !images.isEmpty{
                for image in images{
                    let imageData = image.jpegData(compressionQuality: 0.2)
                    let formData: Moya.MultipartFormData = Moya.MultipartFormData(provider: .data(imageData!), name: "files[]", fileName: "file.jpg", mimeType: "image/jpeg")
                    multipartFormData.append(formData)
                }
            }
            if !voices.isEmpty{
                for voice in voices{
                    let formData: Moya.MultipartFormData = Moya.MultipartFormData(provider: .data(voice), name: "files[]", fileName: "file.m4a", mimeType: "audio/m4a")
                    multipartFormData.append(formData)
                }
            }
            if !notes.isEmpty{
                multipartFormData.append(MultipartFormData(provider: .data("\(notes)".data(using: .utf8)!), name: "notes[]"))
            }
            multipartFormData.append(MultipartFormData(provider: .data("\(id)".data(using: .utf8)!), name: "order_id"))
            return .uploadMultipart(multipartFormData)
        default:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .login(_):
            return ["Accept": "application/json"]
        default:
            return Shared.headers
        }
    }
}
