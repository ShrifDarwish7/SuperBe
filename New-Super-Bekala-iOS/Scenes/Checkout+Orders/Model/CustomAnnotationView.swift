//
//  CustomAnnotationView.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 31/08/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import MapKit

class CustomAnnotationView: MKMarkerAnnotationView{
    override var annotation: MKAnnotation?{
        willSet{
            guard let annotation = newValue as? CustomAnnotation else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
    
            switch annotation.annontationType {
            case .user:
                self.markerTintColor = .darkGray
            case .captain:
                self.markerTintColor = .red
                guard let phoneNumber = annotation.phoneNumber else { return }
                let phoneBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                phoneBtn.onTap {
                    Shared.call(phoneNumber: phoneNumber)
                }
                phoneBtn.setImage(UIImage(systemName: "phone.circle.fill"), for: .normal)
                phoneBtn.tintColor = .green
                rightCalloutAccessoryView = phoneBtn
            default: break
            }
        }
    }
}
