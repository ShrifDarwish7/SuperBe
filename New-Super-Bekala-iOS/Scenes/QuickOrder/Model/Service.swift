//
//  Service.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 01/07/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit

class SuperService{
    
    var orderId: Int?
    var status: OrderStatus?
    // Pick up data
    var pickupCoords: String?
    var pickupLandmark: String?
    
    var pickupAddressId: Int?
    var dropoffAddressId: Int?
    
    // Drop off data
    var dropOffCoords: String?
    var dropOffLandmark: String?
    
    var phoneNumber: String?
    
    var images: [UIImage]?
    var voice: Data?
    var text: String?
}
