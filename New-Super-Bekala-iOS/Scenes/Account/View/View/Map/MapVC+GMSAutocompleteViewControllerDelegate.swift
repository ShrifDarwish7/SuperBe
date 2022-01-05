//
//  MapVC+GMSAutocompleteViewControllerDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 24/01/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import GooglePlaces
import GoogleMaps

extension MapVC: GMSAutocompleteViewControllerDelegate{
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        Shared.userLat = place.coordinate.latitude
        Shared.userLng = place.coordinate.longitude
        
        camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude , longitude: place.coordinate.longitude , zoom: 19)
        mapView.camera = camera!
        addressContainer.isHidden = false
        dismissHintZoom()
        locationLbl.text = place.formattedAddress ?? ""
        dismiss(animated: true, completion: nil)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    
    
}
