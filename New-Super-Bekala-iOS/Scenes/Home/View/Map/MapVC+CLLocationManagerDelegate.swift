//
//  MapVC+CLLocationManagerDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 24/01/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

extension MapVC: CLLocationManagerDelegate{
    
    func requestLocationPermission(){
        
        locationManager.requestAlwaysAuthorization()
            
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }else{
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.0444, longitude: 31.2357), latitudinalMeters: 500, longitudinalMeters: 500)
            mapKitView.setRegion(region, animated: true)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        Shared.userLat = locValue.latitude
        Shared.userLng = locValue.longitude
        let region = MKCoordinateRegion(center: locValue, latitudinalMeters: 500, longitudinalMeters: 500)
        mapKitView.setRegion(region, animated: true)
//        camera = GMSCameraPosition.camera(withLatitude: Shared.userLat ?? 0 , longitude: Shared.userLng ?? 0, zoom: 19)
//        mapView.camera = camera!
        locationManager.stopUpdatingLocation()
        
    }
}
