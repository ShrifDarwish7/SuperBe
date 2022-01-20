//
//  PickLocationVC+MKMapViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 21/08/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import MapKit

extension PickLocationVC: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = self.getCenterLocation(for: mapView)
                
        let zoomWidth = mapView.visibleMapRect.size.width
        let zoomFactor = Int(log2(zoomWidth)) - 9
        
        if zoomFactor > 1{
            self.showHintZoom()
            confirmBtn.isEnabled = false
            confirmBtn.alpha = 0.5
        }else{
            self.dismissHintZoom()
            confirmBtn.isEnabled = true
            confirmBtn.alpha = 1
            guard let previousLocation = self.previousLocation else { return }
            guard center.distance(from: previousLocation) > 50 else { return }
            self.previousLocation = center
            
            CLGeocoder().reverseGeocodeLocation(center) { [weak self] placemarks, error in
                guard let self = self else { return }
                if let error = error{
                    print(error)
                    return
                }
                guard let placemark = placemarks?.first else { return }
                self.pickedCoords = "\(placemark.location?.coordinate.latitude ?? 0),\(placemark.location?.coordinate.longitude ?? 0)"
                self.locationLbl.text = (placemark.administrativeArea ?? "") + " (\((placemark.subAdministrativeArea ?? placemark.name) ?? placemark.thoroughfare ?? ""))"
            }
        }
    }
}
