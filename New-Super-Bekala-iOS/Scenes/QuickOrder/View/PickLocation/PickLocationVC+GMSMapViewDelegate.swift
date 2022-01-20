//
//  PickLocationVC+GMSMapViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 30/06/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
//import GoogleMaps

//extension PickLocationVC: GMSMapViewDelegate{
//
//    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
//        markerImageView.alpha = 0.5
//        dismissHintZoom()
//    }
//
//    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
//
//    }
//
//    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
//
//        dismissHintZoom()
//        markerImageView.alpha = 1
//
//        let coordinates = mapView.projection.coordinate(for: mapView.center)
//
//        if mapView.camera.zoom <= 15{
//            showHintZoom()
//            confirmBtn.isEnabled = false
//            confirmBtn.alpha = 0.5
//        }else{
//            dismissHintZoom()
//            self.pickedCoords = "\(coordinates.latitude),\(coordinates.longitude)"
//            let parameters: [String: String] = [
//                "key": Shared.GMS_KEY,
//                "language": "lang".localized,
//                "latlng": "\(coordinates.latitude),\(coordinates.longitude)"
//            ]
//          //  presenter?.getGeocode(parameters)
//        }
//    }
//
//}
