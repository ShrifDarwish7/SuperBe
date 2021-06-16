//
//  NBEProvider.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 02/06/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import Moya
import MPGSDK

public enum NBE{
    case createSession
    case updateSession(_ session: String, _ payload: GatewayMap)
    case updateTransaction(_ orderId: String, _ payload: GatewayMap,_ transactionNumber: String)
}

extension NBE: TargetType{
    public var baseURL: URL {
        return URL(string: "https://nbe.gateway.mastercard.com/api/rest/version/59/merchant/superbe/")!
    }
    
    public var path: String {
        switch self {
        case .createSession:
            return "session"
        case .updateSession(let session,_):
            return "session/\(session)"
        case .updateTransaction(let orderId,_, let transactionNumber):
            return "order/\(orderId)/transaction/txn\(transactionNumber)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .createSession:
            return .post
        default:
            return .put
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .createSession:
            return .requestPlain
        case .updateSession(_, let payload),
             .updateTransaction(_,let payload,_):
            return .requestCompositeData(bodyData: try! JSONEncoder().encode(payload), urlParameters: [:])
        }
    }
    
    public var headers: [String : String]? {

        let username = "merchant.SUPERBE"
        let password = "1bd9bdfb7aeed3bfc41472393c282778"
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        return [
            "Authorization": "Basic \(base64LoginString)"
        ]
    }
    
    
}
