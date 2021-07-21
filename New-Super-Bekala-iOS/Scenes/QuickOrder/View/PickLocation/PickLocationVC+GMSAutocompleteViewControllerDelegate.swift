//
//  PickLocationVC+GMSAutocompleteViewControllerDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 30/06/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import GooglePlaces
import GoogleMaps

extension PickLocationVC: GMSAutocompleteViewControllerDelegate{
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude , longitude: place.coordinate.longitude , zoom: 19)
        mapView.camera = camera!
        dismissHintZoom()
        locationLbl.text = place.formattedAddress ?? ""
        self.pickedCoords = "\(place.coordinate.latitude),\(place.coordinate.longitude)"
        dismiss(animated: true, completion: nil)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    
    
}
