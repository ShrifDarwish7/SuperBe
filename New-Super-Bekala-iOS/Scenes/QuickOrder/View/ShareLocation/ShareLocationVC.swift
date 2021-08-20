//
//  ShareLocationVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 30/06/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import MapKit
import SVProgressHUD
import SwiftyJSON

class ShareLocationVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var blockView: UIView!
    @IBOutlet weak var addressesTableView: UITableView!
    @IBOutlet weak var addressesCnst: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pickupTF: UITextField!
    @IBOutlet weak var dropOffTF: UITextField!
    @IBOutlet weak var continueBtnView: ViewCorners!
    @IBOutlet weak var distance: UILabel!
    
    var locationState: LocationState?
    var selectedPickupAddressId: Int?
    var selectedDropoffAddressId: Int?
    var addresses: [Address]?{
        didSet{
            self.loadAddressesTable()
        }
    }
    var pickupLocation: String?{
        didSet{
            self.updateMapView()
        }
    }
    var dropOffLocation: String?{
        didSet{
            self.updateMapView()
        }
    }
    var pickupLandmark: String?
    var dropOffLandmark: String?
    var presenter: MainPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceivePickedLocation(_:)), name: NSNotification.Name("DID_RECEIVE_PICKED_COORDS"), object: nil)

        presenter = MainPresenter(self)
        self.dismissAdddressesAlert()
        
    }
    
    @objc func didReceivePickedLocation(_ sender: NSNotification){
        guard let userInfo = sender.userInfo as? [String: String] else { return }
        let formattedAddress = userInfo["formatted_address"]!
        let coords = userInfo["coordinates"]!
        let landmark = userInfo["landmark"]!
        switch locationState {
        case .pickup:
            pickupLandmark = landmark
            pickupTF.text = formattedAddress
            pickupLocation = coords
        case .dropOff:
            dropOffLandmark = landmark
            dropOffTF.text = formattedAddress
            dropOffLocation = coords
        default:
            break
        }
    }
    
    func updateMapView(){
//        mapView.clear()
//        self.dismissAdddressesAlert()
//        guard let pickupLocation = pickupLocation else { return }
//
//
//
//        let pickupMarker = GMSMarker(position:
//                                        CLLocationCoordinate2D(
//                                            latitude: Double(pickupLocation.split(separator: ",").first!)!,
//                                            longitude: Double(pickupLocation.split(separator: ",")[1])!))
//        pickupMarker.icon = Images.imageWithImage(image: UIImage(named: "delivery-bike")!, scaledToSize: CGSize(width: 30, height: 30))
//        let pickupCamera = GMSCameraPosition(latitude: Double(pickupLocation.split(separator: ",").first!)!, longitude: Double(pickupLocation.split(separator: ",")[1])!, zoom: 15)
//        self.mapView.camera = pickupCamera
//        pickupMarker.map = mapView
//        
//        guard let dropOffLocation = dropOffLocation else { return }
//        let dropOffMarker = GMSMarker(position:
//                                        CLLocationCoordinate2D(
//                                            latitude: Double(dropOffLocation.split(separator: ",").first!)!,
//                                            longitude: Double(dropOffLocation.split(separator: ",")[1])!))
//        dropOffMarker.icon = Images.imageWithImage(image: UIImage(named: "flag-2")!, scaledToSize: CGSize(width: 30, height: 30))
//
//        let dropOffCamera = GMSCameraPosition(latitude: Double(dropOffLocation.split(separator: ",").first!)!, longitude: Double(dropOffLocation.split(separator: ",")[1])!, zoom: 15)
//        self.mapView.camera = dropOffCamera
//        dropOffMarker.map = mapView
        
        continueBtnView.isHidden = false
        
    }
    
    @IBAction func continueAction(_ sender: Any) {
        
        let superService = SuperService()
        superService.pickupCoords = pickupLocation
        superService.pickupLandmark = pickupLandmark
        superService.dropOffCoords = dropOffLocation
        superService.dropOffLandmark = dropOffLandmark
        superService.pickupAddressId = selectedPickupAddressId
        superService.dropoffAddressId = selectedDropoffAddressId
        Shared.superService = superService
        
        switch Shared.selectedServices {
        case .voice:
            Router.toVoiceOrder(self, nil)
        case .images:
            Router.toImagesOrder(self, nil)
        case .text:
            Router.toTextOrder(self, nil)
        default:
            break
        }
    }
    
//    func getDistance(){
//
//        SVProgressHUD.show()
//
//        let parameters: [String:String] = [
//            "origins": pickupLocation!,
//            "destinations": dropOffLocation!,
//            "key": Shared.GMS_KEY,
//            "mode": "driving"
//        ]
//
//        APIServices.shared.call(.getDistance(parameters)) { data in
//            SVProgressHUD.dismiss()
//            if let data = data,
//               let dataModel = data.getDecodedObject(from: GMSDistanceMatrixResponse.self){
//                DispatchQueue.main.async {
//                    self.distance.text = "\((Double((dataModel.rows.first?.elements.first?.distance.value)!) / 1000).roundToDecimal(2)) Km"
//                }
//            }
//        }
//
//    }
    
    
    func showAddressesAlert(){
        activityIndicator.startAnimating()
        presenter?.getAddresses()
        self.blockView.isHidden = false
        self.addressesCnst.constant = 0
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: []) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            
        }
    }
    
    func dismissAdddressesAlert(){
        self.blockView.isHidden = true
        self.addressesCnst.constant = self.view.frame.height
        self.view.layoutIfNeeded()
    }
    
    @IBAction func dismissAlert(_ sender: Any) {
        self.dismissAdddressesAlert()
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectLocation(_ sender: UIButton) {
        self.locationState = sender.tag == 0 ? .pickup : .dropOff
        self.showAddressesAlert()
    }
    
    @IBAction func selectFromMap(_ sender: UIButton) {
        Router.toPickLocation(self, self.locationState!)
    }
    
}
