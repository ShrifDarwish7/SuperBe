//
//  ChangeLocationVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 27/06/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class ChangeLocationVC: UIViewController {

    @IBOutlet weak var addressesTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var presenter: MainPresenter?
    var addresses: [Address]?{
        didSet{
            self.loadAddressesTable()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        presenter = MainPresenter(self)
        presenter?.getAddresses()

    }
    
    @IBAction func toMap(_ sender: Any) {
        Router.toMaps(self.parent!)
    }
    
    
    @IBAction func toAllLocations(_ sender: Any) {
        let prms: [String: String] = [
            "country_id": "1",
            "with": "regions"
        ]
        self.presenter?.getCities(prms)
    }
}
