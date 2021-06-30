//
//  AskLocationVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 11/03/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class AskLocationVC: UIViewController {
    
    
    var presenter: MainPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MainPresenter(self)

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
