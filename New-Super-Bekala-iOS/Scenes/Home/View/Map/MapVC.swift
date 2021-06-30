//
//  MapVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 23/01/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Closures

class MapVC: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var addressContainer: ViewCorners!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var hintZoomView: UIView!
    @IBOutlet weak var markerImageView: UIImageView!
    @IBOutlet weak var askLocationView: AskLocationView!
    @IBOutlet weak var backBtn: LocalizedBtn!
    @IBOutlet weak var addressTitleStack: UIStackView!
    @IBOutlet weak var addAddressBlockView: UIView!
    @IBOutlet weak var detectBtn: RoundedButton!
    @IBOutlet weak var addressTitleTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var districtTF: UITextField!
    @IBOutlet weak var streetTF: UITextField!
    @IBOutlet weak var buildingTF: UITextField!
    @IBOutlet weak var floorTF: UITextField!
    @IBOutlet weak var flatTF: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var notesTF: UITextField!
    
    let locationManager = CLLocationManager()
    var camera: GMSCameraPosition?
    var autocompleteVC: GMSAutocompleteViewController?
    var presenter: MainPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressTitleStack.isHidden = Shared.mapState == .addAddress ? false : true
        
        mapView.delegate = self
        requestLocationPermission()
        hintZoomView.transform = CGAffineTransform(scaleX: 0, y: 0)
        showHintZoom()
        
        presenter = MainPresenter(self)
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways , .authorizedWhenInUse:
            print("")
        default:
            Shared.userLat = 30.0444
            Shared.userLng = 31.2357
            camera = GMSCameraPosition.camera(withLatitude: Shared.userLat ?? 0 , longitude: Shared.userLng ?? 0, zoom: 10)
            mapView.camera = camera!
        }
        
        locationLbl.addTapGesture { (_) in
            self.autocompleteVC = GMSAutocompleteViewController()
            self.autocompleteVC!.delegate = self
            self.autocompleteVC?.modalPresentationStyle = .formSheet
            self.autocompleteVC?.tintColor = UIColor.white
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            
            self.present(self.autocompleteVC!, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        switch Shared.mapState {
        case .fetchLocation:
            Shared.isCoords = true
            Shared.isRegion = false
            Shared.selectedCoords = "\(Shared.userLat ?? 0.0),\(Shared.userLng ?? 0.0)"
            Shared.userSelectLocation = true
            Router.toHome(self)
        case .addAddress:
            UIView.animate(withDuration: 0.25) {
                self.addAddressBlockView.isHidden = false
                self.detectBtn.isHidden = true
                self.addAddressBlockView.alpha = 1
            }
        default:
            break
        }
        
    }
    
    @IBAction func save(_ sender: Any) {
        guard !self.addressTitleTF.text!.isEmpty, !self.cityTF.text!.isEmpty, !self.districtTF.text!.isEmpty, !self.streetTF.text!.isEmpty, !self.buildingTF.text!.isEmpty, !self.floorTF.text!.isEmpty, !self.flatTF.text!.isEmpty else {
            showToast("Please fill out all required fields")
            return
        }
        let parameters: [String: String] = [
            "title": addressTitleTF.text!,
            "coordinates": "\(Shared.userLat ?? 0.0),\(Shared.userLng ?? 0.0)",
            "city": cityTF.text!,
            "dist": districtTF.text!,
            "landmark": streetTF.text!,
            "building": buildingTF.text!,
            "floor": floorTF.text!,
            "flat": flatTF.text!,
            "phone": phoneNumber.text!,
            "notes": notesTF.text!,
            "selected": "1"
        ]
        presenter?.addAddress(parameters)
    }
    
    
    @IBAction func refine(_ sender: Any) {
        UIView.animate(withDuration: 0.25) {
            self.addAddressBlockView.alpha = 0
            self.detectBtn.isHidden = false
        } completion: { (_) in
            self.addAddressBlockView.isHidden = true
        }

    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func getMyLocation(_ sender: Any) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways , .authorizedWhenInUse:
            requestLocationPermission()
        default:
            askLocationView.isHidden = false
        }
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

enum MapState{
    case addAddress
    case fetchLocation
}
