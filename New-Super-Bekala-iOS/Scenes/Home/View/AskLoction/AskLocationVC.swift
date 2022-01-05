//
//  AskLocationVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 11/03/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import Lottie
import CoreLocation

class AskLocationVC: UIViewController {
    
    @IBOutlet weak var lottieContainier: UIView!
    
    var presenter: MainPresenter?
    var animationView: AnimationView?
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MainPresenter(self)
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        animationView?.removeFromSuperview()
        animationView = .init(name: "location-animation")
        animationView!.frame = lottieContainier.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .loop
        lottieContainier.addSubview(animationView!)
        animationView!.play()
    }
    
    @IBAction func toMap(_ sender: Any) {
        Router.toMaps(self)
    }
    
    @IBAction func toRegions(_ sender: Any) {
        let prms: [String: String] = [
            "country_id": "1",
            "with": "regions"
        ]
        self.presenter?.getCities(prms)
    }
    
}
