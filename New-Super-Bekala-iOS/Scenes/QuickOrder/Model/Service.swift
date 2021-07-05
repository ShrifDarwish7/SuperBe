//
//  Service.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 01/07/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

class SuperService{
    
    // Pick up data
    var pickupCoords: String?
    var pickupLandmark: String?
    
    // Drop off data
    var dropOffCoords: String?
    var dropOffLandmark: String?
    
    var phoneNumber: String?
    
    var images: [Data]?
    var voice: Data?
    var text: String?
}
