//
//  MapVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 23/01/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
//import GooglePlaces
import Closures
import MapKit
import SVProgressHUD

class MapVC: UIViewController {
    
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
    @IBOutlet weak var hintZoom: UILabel!
    @IBOutlet weak var mapKitView: MKMapView!
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var workView: ViewCorners!
    @IBOutlet weak var homeView: ViewCorners!
    @IBOutlet weak var otherView: ViewCorners!
    
    let locationManager = CLLocationManager()
    var presenter: MainPresenter?
    var path: [MKPolyline]?
    var polygone: [MKPolygon]?
    var inRegion = true
    var previousLocation: CLLocation?
    var addressTitle: String?
    var editableAddress: Address?
    var presentingAddressDetails = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissHintZoom()
        
        mapKitView.delegate = self
        
        mapKitView.layoutMargins.bottom = 60
        
        addressTitleStack.isHidden = Shared.mapState == .addAddress ? false : true
        
        hintZoomView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        presenter = MainPresenter(self)
        
        if let path = path{
            path.forEach { path in
                mapKitView.addOverlay(path, level: MKOverlayLevel.aboveRoads)
            }
        }
                
        switch Shared.mapState {
        case .editAddress:
            guard let address = self.editableAddress else { return }
            addressTitleStack.isHidden = false
            let lat = Double(address.coordinates?.split(separator: ",")[0].replacingOccurrences(of: " ", with: "") ?? "0.0")!
            let lng = Double(address.coordinates?.split(separator: ",")[1].replacingOccurrences(of: " ", with: "") ?? "0.0")!
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lng), latitudinalMeters: 200, longitudinalMeters: 200)
            mapKitView.setRegion(region, animated: true)
            addressTitleTF.text = address.title
            cityTF.text = address.city
            districtTF.text = address.dist
            streetTF.text = address.landmark
            buildingTF.text = address.building
            floorTF.text = address.floor
            flatTF.text = address.flat
            phoneNumber.text = address.phone
            notesTF.text = address.notes
            UIView.animate(withDuration: 0.25) { [self] in
                addAddressBlockView.isHidden = false
                detectBtn.isHidden = true
                addAddressBlockView.alpha = 1
                addressTitleTF.becomeFirstResponder()
            }
        default:
            switch CLLocationManager.authorizationStatus() {
            case .denied, .notDetermined, .restricted:
                self.showHintZoom()
                let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Shared.defaultLat, longitude: Shared.defaultLng), latitudinalMeters: 5000, longitudinalMeters: 5000)
                mapKitView.setRegion(region, animated: true)
            default:
                self.getUserLocation()
            }
        }
        
        previousLocation = self.getCenterLocation(for: mapKitView)
        
        streetTF.rightView?.isHidden = true
        buildingTF.rightView?.isHidden = true
        floorTF.rightView?.isHidden = true
        flatTF.rightView?.isHidden = true
        
    }
    
    func getUserLocation(){
        LocationManager.shared.getUserLocation { [weak self] location in
            guard let self = self else { return }
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), latitudinalMeters: 200, longitudinalMeters: 200)
            self.mapKitView.setRegion(region, animated: true)
        }

    }
    
    @IBAction func confirmAction(_ sender: Any) {
        switch Shared.mapState {
        case .fetchLocation:
            SVProgressHUD.show()
            presenter?.getCategories(["coordinates": "\(mapKitView.centerCoordinate.latitude),\(mapKitView.centerCoordinate.longitude)"])
        case .addAddress, .editAddress:
            guard self.inRegion else { return }
            presentingAddressDetails = true
            let zoomWidth = self.mapKitView.visibleMapRect.size.width
            let zoomFactor = Int(log2(zoomWidth)) - 9
            guard zoomFactor <= 1 else {
                hintZoomView.shake(.error)
                return
            }
            UIView.animate(withDuration: 0.25) {
                self.addAddressBlockView.isHidden = false
                self.detectBtn.isHidden = true
                self.addAddressBlockView.alpha = 1
                //self.addressTitleTF.becomeFirstResponder()
            }
        default:
            break
        }
        
    }
    
    @IBAction func selectAddressName(_ sender: UIButton) {
        
        workView.alpha = 0.2
        homeView.alpha = 0.2
        otherView.alpha = 0.2
        addressTitleTF.isHidden = true
        addressTitleTF.text = ""
        
        switch sender.tag {
        case 0:
            workView.alpha = 1
            addressTitleTF.text = "Work"
        case 1:
            homeView.alpha = 1
            addressTitleTF.text = "Home"
        case 2:
            otherView.alpha = 1
            addressTitleTF.isHidden = false
        default: break
        }
        
    }
    
    @IBAction func save(_ sender: Any) {
        
        streetTF.rightView?.isHidden = true
        buildingTF.rightView?.isHidden = true
        floorTF.rightView?.isHidden = true
        flatTF.rightView?.isHidden = true
        
        guard !self.addressTitleTF.text!.isEmpty else {
            self.addressTitleStack.shake(.error)
            return
        }
        guard !self.cityTF.text!.isEmpty else {
            cityTF.shake(.error)
            scroller.setContentOffset(cityTF.frame.origin, animated: true)
            return
        }
        guard !self.districtTF.text!.isEmpty else {
            districtTF.shake(.error)
            scroller.setContentOffset(districtTF.frame.origin, animated: true)
            return
        }
        guard !self.streetTF.text!.isEmpty else {
            streetTF.shake(.error)
            streetTF.rightView?.isHidden = false
            scroller.setContentOffset(streetTF.frame.origin, animated: true)
            return
        }
        guard !self.buildingTF.text!.isEmpty else {
            buildingTF.shake(.error)
            buildingTF.rightView?.isHidden = false
            scroller.setContentOffset(buildingTF.frame.origin, animated: true)
            return
        }
        guard !self.floorTF.text!.isEmpty else {
            floorTF.shake(.error)
            floorTF.rightView?.isHidden = false
            scroller.setContentOffset(floorTF.frame.origin, animated: true)
            return
        }
        guard !self.flatTF.text!.isEmpty else {
            flatTF.shake(.error)
            flatTF.rightView?.isHidden = false
            scroller.setContentOffset(flatTF.frame.origin, animated: true)
            return
        }
        let parameters: [String: String] = [
            "title": addressTitleTF.text!,
            "coordinates": "\(mapKitView.centerCoordinate.latitude),\(mapKitView.centerCoordinate.longitude)",
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
        switch Shared.mapState{
        case .addAddress:
            presenter?.addAddress(parameters)
        case .editAddress:
            guard let address = self.editableAddress else { return }
            SVProgressHUD.show()
            presenter?.updateAddress(address.id, parameters)
        default: break
        }
        
    }
    
    @IBAction func searchAction(_ sender: Any) {
//        self.autocompleteVC = GMSAutocompleteViewController()
//        self.autocompleteVC!.delegate = self
//        self.autocompleteVC?.modalPresentationStyle = .formSheet
//        self.autocompleteVC?.tintColor = UIColor.white
//        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//
//        self.present(self.autocompleteVC!, animated: true, completion: nil)
    }
    
    @IBAction func refine(_ sender: Any) {
        presentingAddressDetails = false
        UIView.animate(withDuration: 0.25) {
            self.addAddressBlockView.alpha = 0
            self.detectBtn.isHidden = false
        } completion: { (_) in
            self.addAddressBlockView.isHidden = true
        }

    }
    
    
    @IBAction func backAction(_ sender: Any) {
        if presentingAddressDetails{
            refine(self)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func getMyLocation(_ sender: Any) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways , .authorizedWhenInUse:
            self.getUserLocation()
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
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation{
        let lat = mapView.centerCoordinate.latitude
        let lng = mapView.centerCoordinate.longitude
        return CLLocation(latitude: lat, longitude: lng)
    }
    
}

enum MapState{
    case addAddress
    case editAddress
    case fetchLocation
}
