//
//  PickLocationVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 30/06/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import MapKit

class PickLocationVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var askLocationView: AskLocationView!
    @IBOutlet weak var hintZoomView: UIView!
    @IBOutlet weak var markerImageView: UIImageView!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var titleTop: UILabel!
    @IBOutlet weak var confirmBtn: RoundedButton!
    @IBOutlet weak var landmarkTF: UITextField!
    
    var previousLocation: CLLocation?
    var presenter: MainPresenter?
    var locationState: LocationState?
    var pickedCoords: String?{
        didSet{
            confirmBtn.isEnabled = true
            confirmBtn.alpha = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch locationState {
        case .pickup:
            titleTop.text = "Pick up location".localized
            confirmBtn.setTitle("Confirm Pick Up".localized, for: .normal)
        case .dropOff:
            titleTop.text = "Drop off location".localized
            confirmBtn.setTitle("Confirm Drop Off".localized, for: .normal)
        default:
            break
        }
        
        mapView.delegate = self
        
        presenter = MainPresenter(self)
        
        switch CLLocationManager.authorizationStatus() {
        case .denied, .notDetermined, .restricted:
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.0444, longitude: 31.2357), latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        default:
            self.getUserLocation()
        }
        
        previousLocation = self.getCenterLocation(for: mapView)
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation{
        let lat = mapView.centerCoordinate.latitude
        let lng = mapView.centerCoordinate.longitude
        return CLLocation(latitude: lat, longitude: lng)
    }
    
    func getUserLocation(){
        LocationManager.shared.getUserLocation { [weak self] location in
            guard let self = self else { return }
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), latitudinalMeters: 200, longitudinalMeters: 200)
            self.mapView.setRegion(region, animated: true)
        }

    }
    
    @IBAction func search(_ sender: Any) {
        
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
    
    @IBAction func confirmPin(_ sender: Any) {
        guard let pickedCoords = pickedCoords else { return }
        self.dismiss(animated: true, completion: nil)
        let userInfo = [
            "formatted_address": locationLbl.text!,
            "coordinates": pickedCoords,
            "landmark": landmarkTF.text!
        ]
        NotificationCenter.default.post(name: NSNotification.Name("DID_RECEIVE_PICKED_COORDS"), object: nil, userInfo: userInfo)
    }
    
    
}

enum LocationState{
    case pickup
    case dropOff
}
