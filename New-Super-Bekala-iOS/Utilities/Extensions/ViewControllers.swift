//
//  ViewControllers.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 28/07/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Toast_Swift

extension UIViewController{
    
    func replaceView(containerView: UIView, identifier: String, storyboard: AppStoryboard) {
        containerView.subviews.forEach({ $0.removeFromSuperview() })
        let vc = Router.instantiate(appStoryboard: storyboard, identifier: identifier)
        vc.view.frame = containerView.bounds;
        containerView.addSubview(vc.view)
        self.addChild(vc)
        vc.didMove(toParent: self)
    }
    
    func openInMaps(coordinates: String){
        let latitude: CLLocationDegrees = Double((coordinates.split(separator: ",")[0]))!
        let longitude: CLLocationDegrees = Double((coordinates.split(separator: ",")[1]))!
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.openInMaps(launchOptions: options)
    }
    
    func showAlert(title : String , message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok".localized, style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showToast(_ msg: String){
        self.view.makeToast(msg, duration: 2, position: .bottom)
    }
    
}
