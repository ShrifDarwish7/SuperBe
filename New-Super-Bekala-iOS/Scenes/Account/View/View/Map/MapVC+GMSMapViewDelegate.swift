//
//  MapVC+GMSMapViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 24/01/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import GoogleMaps

extension MapVC: GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        markerImageView.alpha = 0.5
        addressContainer.isHidden = true
        dismissHintZoom()
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("Projection",mapView.projection.coordinate(for: mapView.center))
        dismissHintZoom()
        markerImageView.alpha = 1
        addressContainer.isHidden = false
      //  dismissHintZoom()
        
        let coordinates = mapView.projection.coordinate(for: mapView.center)
        Shared.userLat = coordinates.latitude
        Shared.userLng = coordinates.longitude
        
//        switch mapState {
//        case .AddAddressToOrder:
//            self.bounds = GMSCoordinateBounds(path: self.path)
//            guard bounds.contains(CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)) else{
//                markerImage.image = UIImage(named: "marker-black")
//                hintZoomLbl.text = "Sorry, this vendor doesn`t deliver to this area".localized
//                showHintZoom()
//                return
//            }
//        default:
//            break
//        }
        
        
//        hintZoomLbl.text = "Please zoom in more to find your exact delivery location".localized
        
        if mapView.camera.zoom <= 15{
            showHintZoom()
        }else{
            dismissHintZoom()
            
            let parameters: [String: String] = [
                "key": Shared.GMS_KEY,
                "language": "lang".localized,
                "latlng": "\(Shared.userLat ?? 0.0),\(Shared.userLng ?? 0.0)"
            ]
            presenter?.getGeocode(parameters)
            
        }
    }
    
}
