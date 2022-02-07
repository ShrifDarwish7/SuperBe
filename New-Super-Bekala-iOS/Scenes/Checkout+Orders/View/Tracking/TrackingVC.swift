//
//  TrackingVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 30/08/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import MapKit
import PusherSwift
import SwiftyJSON

class TrackingVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var userAddress: Address?
    var captainCoords: String?
    var captainName: String?
    var captainPhone: String?
    var orderId: String?
    var captainAnnotation: CustomAnnotation!
    var userAnnotation: CustomAnnotation!
    var delegate: OrderUpdatedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        userAnnotation = CustomAnnotation(title: userAddress?.title ?? "", coordinate: CLLocationCoordinate2D(latitude: Double(userAddress!.coordinates!.split(separator: ",")[0])!,longitude: Double(userAddress!.coordinates!.split(separator: ",")[1])!), subtitle: "", annontationType: .user)


        captainAnnotation = CustomAnnotation(title: captainName ?? "", coordinate: CLLocationCoordinate2D(latitude: Double(captainCoords!.split(separator: ",")[0])!,longitude: Double(captainCoords!.split(separator: ",")[1])!), subtitle: captainPhone ?? "", annontationType: .captain, phoneNumber: captainPhone)
        mapView.addAnnotation(userAnnotation)
        mapView.addAnnotation(captainAnnotation)
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Double(captainCoords!.split(separator: ",")[0])!,longitude: Double(captainCoords!.split(separator: ",")[1])!), latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)
        
        let options = PusherClientOptions(
            authMethod: AuthMethod.authRequestBuilder(authRequestBuilder: AuthRequestBuilder()),
            host: .cluster("eu")
        )
        
        AppDelegate.pusher = Pusher(key: "3291250172ef81e382a7", options: options)
        AppDelegate.pusher.connection.delegate = self
        AppDelegate.pusher.delegate = self
        AppDelegate.pusher.connect()
        
        AppDelegate.channel = AppDelegate.pusher.subscribe("private-orders.\(orderId!)")
        
        let _ = AppDelegate.channel.bind(eventName: "App\\Events\\TrackCaptain") { [self] (data: Any?) -> Void in
            guard let data = data else { return }
            print("updating coords")
            mapView.removeAnnotation(captainAnnotation)
            captainAnnotation = CustomAnnotation(title: captainName ?? "", coordinate: CLLocationCoordinate2D(latitude: Double(JSON(data)["coordinates"].stringValue.split(separator: ",")[0])!,longitude: Double(JSON(data)["coordinates"].stringValue.split(separator: ",")[1])!), subtitle: captainPhone ?? "", annontationType: .captain, phoneNumber: captainPhone)
            mapView.addAnnotation(captainAnnotation)
        }
        
        let _ = AppDelegate.channel.bind(eventName: "App\\Events\\OrderUpdated") { [self] (data: Any?) -> Void in
            guard let data = data else { return }
            print("OrderUpdated", JSON(data))
            let json = JSON(data)
            let id = json["order"]["id"].intValue
            let status = json["order"]["status"]
            
            if status == "completed"{
                let alert = UIAlertController(title: "Captain Arrived".localized, message: "Have a nice order".localized, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Done".localized, style: .default, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                    self.delegate?.onUpdate(id)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
                  
    }
 
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension TrackingVC: PusherDelegate{
    func changedConnectionState(from old: ConnectionState, to new: ConnectionState) {
        print("old: \(old.stringValue()) -> new: \(new.stringValue())")
    }
    func debugLog(message: String) {
        print("debugLog",message)
    }
    func subscribedToChannel(name: String) {
        print("subscribedToChannel",name)
    }
    func failedToSubscribeToChannel(name: String, response: URLResponse?, data: String?, error: NSError?) {
        print("failedToSubscribeToChannel",name)
    }
    func receivedError(error: PusherError) {
        print("receivedError",error.message)
    }
}
