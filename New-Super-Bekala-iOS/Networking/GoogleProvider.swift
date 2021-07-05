//
//  GoogleProvider.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 23/01/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import Moya

public enum Google{
    case getGeocode(_ parameters: [String: String])
    case getDistance(_ parameters: [String: String])
}

extension Google: TargetType{
    public var baseURL: URL {
        return URL(string: "https://maps.google.com/maps/api")!
    }
    
    public var path: String {
        switch self {
        case .getGeocode(_): return "geocode/json"
        case .getDistance(_): return "distancematrix/json"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .getGeocode(let parms),
             .getDistance(let parms):
            return .requestParameters(parameters: parms, encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
    
}
