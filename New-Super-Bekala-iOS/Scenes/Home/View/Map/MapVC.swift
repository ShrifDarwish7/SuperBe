//
//  MapVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 23/01/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import GooglePlaces
import Closures
import MapKit

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
    
    let locationManager = CLLocationManager()
    var presenter: MainPresenter?
    var path: MKPolyline?
    var polygone: MKPolygon?
    var inRegion = true
    var previousLocation: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapKitView.delegate = self
        
        mapKitView.layoutMargins.bottom = 60
        
        addressTitleStack.isHidden = Shared.mapState == .addAddress ? false : true
        
        hintZoomView.transform = CGAffineTransform(scaleX: 0, y: 0)
        showHintZoom()
        
        presenter = MainPresenter(self)
        
        if let path = path{
            mapKitView.addOverlay(path, level: MKOverlayLevel.aboveRoads)
        }
        
        switch CLLocationManager.authorizationStatus() {
        case .denied, .notDetermined, .restricted:
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30.0444, longitude: 31.2357), latitudinalMeters: 200, longitudinalMeters: 200)
            mapKitView.setRegion(region, animated: true)
        default:
            self.getUserLocation()
        }
        
        previousLocation = self.getCenterLocation(for: mapKitView)
        
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
            Shared.isCoords = true
            Shared.isRegion = false
            Shared.selectedCoords = "\(Shared.userLat ?? 0.0),\(Shared.userLng ?? 0.0)"
            Shared.userSelectLocation = true
            Router.toHome(self)
        case .addAddress:
            guard self.inRegion else { return }
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
            self.addressTitleTF.shake()
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
    case fetchLocation
}

extension MapVC: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = self.getCenterLocation(for: mapView)
                
        let zoomWidth = mapView.visibleMapRect.size.width
            let zoomFactor = Int(log2(zoomWidth)) - 9
        
        if zoomFactor > 1{
            self.showHintZoom()
        }else{
            self.dismissHintZoom()
            
            if let polygon = self.polygone{
                let polygonRenderer = MKPolygonRenderer(polygon: polygon)
                let mapPoint: MKMapPoint = MKMapPoint(CLLocationCoordinate2D(latitude: center.coordinate.latitude, longitude: center.coordinate.longitude))
                let polygonViewPoint: CGPoint = polygonRenderer.point(for: mapPoint)
                if !polygonRenderer.path.contains(polygonViewPoint){
                    markerImageView.alpha = 0.5
                    self.inRegion = false
                    return
                }else{
                    self.inRegion = true
                    markerImageView.alpha = 1
                }
            }
            
            guard let previousLocation = self.previousLocation else { return }
            guard center.distance(from: previousLocation) > 100 else { return }
            self.previousLocation = center
            
            CLGeocoder().reverseGeocodeLocation(center) { [weak self] placemarks, error in
                guard let self = self else { return }
                if let error = error{
                    print(error)
                    return
                }
                guard let placemark = placemarks?.first else { return }
                DispatchQueue.main.async {
                    self.locationLbl.text = "\(placemark.administrativeArea ?? "") \(placemark.subAdministrativeArea ?? "") \(placemark.name ?? "")"
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor(named: "Main")
            renderer.lineWidth = 3
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}
