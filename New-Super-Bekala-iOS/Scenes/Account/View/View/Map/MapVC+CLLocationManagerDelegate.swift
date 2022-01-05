//
//  MapVC+CLLocationManagerDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 24/01/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps

extension MapVC: CLLocationManagerDelegate{
    
    func requestLocationPermission(){
        
        locationManager.requestAlwaysAuthorization()
            
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }else{
            Shared.userLat = 30.0444
            Shared.userLng = 31.2357
            camera = GMSCameraPosition.camera(withLatitude: Shared.userLat ?? 0 , longitude: Shared.userLng ?? 0, zoom: 10)
            mapView.camera = camera!
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        Shared.userLat = locValue.latitude
        Shared.userLng = locValue.longitude
        camera = GMSCameraPosition.camera(withLatitude: Shared.userLat ?? 0 , longitude: Shared.userLng ?? 0, zoom: 19)
        mapView.camera = camera!
        locationManager.stopUpdatingLocation()
        
    }
}
