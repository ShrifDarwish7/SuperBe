//
//  PickLocationVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 30/06/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class PickLocationVC: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var askLocationView: AskLocationView!
    @IBOutlet weak var hintZoomView: UIView!
    @IBOutlet weak var markerImageView: UIImageView!
    @IBOutlet weak var locationLbl: UILabel!
    
    var camera: GMSCameraPosition?
    var presenter: MainPresenter?
    var autocompleteVC: GMSAutocompleteViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        hintZoomView.transform = CGAffineTransform(scaleX: 0, y: 0)
        showHintZoom()
        
        presenter = MainPresenter(self)
        
        switch CLLocationManager.authorizationStatus() {
        case .denied, .notDetermined, .restricted:
            camera = GMSCameraPosition.camera(withLatitude: 30.0444, longitude: 31.2357, zoom: 10)
            mapView.camera = camera!
        default:
            self.getUserLocation()
        }
    }
    
    
    func getUserLocation(){
        LocationManager.shared.getUserLocation { [weak self] location in
            guard let self = self else { return }
            self.camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude , longitude: location.coordinate.longitude, zoom: 19)
            self.mapView.camera = self.camera!
        }

    }
    
    @IBAction func search(_ sender: Any) {
        self.autocompleteVC = GMSAutocompleteViewController()
        self.autocompleteVC!.delegate = self
        self.autocompleteVC?.modalPresentationStyle = .formSheet
        self.autocompleteVC?.tintColor = UIColor.white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        self.present(self.autocompleteVC!, animated: true, completion: nil)
    }
    
    
    @IBAction func getMyLocation(_ sender: Any) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways , .authorizedWhenInUse:
            self.getUserLocation()
        default:
            askLocationView.isHidden = false
        }
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showHintZoom(){
        self.hintZoomView.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [], animations: {
            self.hintZoomView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.view.layoutIfNeeded()
        }) { (_) in
            
        }
    }
    
    func dismissHintZoom(){
        self.hintZoomView.isHidden = true
        self.hintZoomView.transform = CGAffineTransform(scaleX: 0, y: 0)
        self.view.layoutIfNeeded()
    }
    
}