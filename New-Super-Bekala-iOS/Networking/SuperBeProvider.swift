//
//  SuperBeProvider.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 23/01/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import Moya

public enum SuperBe{
    case login(_ prms: [String: String])
    case logout
    case getCities(_ prms: [String: String])
    case getCategories(_ prms: [String: String])
    case getBranches(_ prms: [String: String])
    case getBranchCats(_ id: Int,_ prms: [String: String])
    case getBranchProducts(_ prms: [String: String],_ id: Int)
    case getBranchBy(_ id: Int)
    case getAddresses
    case postAddress(_ prms: [String: String])
    case updateAddress(_ id: Int,_ prms: [String: String])
    case deleteAddress(_ id: Int)
    case getProductByID(_ branchId: Int,_ productId: Int,_ prms: [String: String])
    case placeOrder(_ bodyData: Data)
    case getMyOrders(_ prms: [String: String])
    case search(_ prms: [String: String])
}

extension SuperBe: TargetType{
    public var baseURL: URL{
        return URL(string: "https://new.superbekala.com/public/dashboardApi/")!
    }
    
    public var path: String{
        switch self {
        case .login:
            return "login"
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
        }
    }
    
    public var method: Moya.Method{
        switch self {
        case .login,
             .postAddress(_),
             .placeOrder(_):
            return .post
        case .updateAddress(_, _):
            return .put
        case .deleteAddress(_):
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
             .search(let prms):
            return .requestParameters(parameters: prms, encoding: URLEncoding.default)
        case .postAddress(let prms):
            var multipartFormData = [MultipartFormData]()
            for (key,value) in prms{
                let formData = MultipartFormData(provider: .data("\(value)".data(using: .utf8)!), name: key)
                multipartFormData.append(formData)
            }
            return .uploadMultipart(multipartFormData)
        case .placeOrder(let bodyData):
            return .requestCompositeData(bodyData: bodyData, urlParameters: [:])
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
