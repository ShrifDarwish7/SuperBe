//
//  CustomAnnotation.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 31/08/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var phoneNumber: String?
    var annontationType: AnnontationType?
    
    init(title: String,
         coordinate: CLLocationCoordinate2D,
         subtitle: String,
         annontationType: AnnontationType,
         phoneNumber: String? = nil){
        
        self.title = title;
        self.coordinate = coordinate
        self.subtitle = subtitle
        self.annontationType = annontationType
        self.phoneNumber = phoneNumber
        
    }
    
}
enum AnnontationType{
    case user
    case captain
}
