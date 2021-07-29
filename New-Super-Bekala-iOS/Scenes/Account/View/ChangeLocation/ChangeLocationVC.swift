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
    @IBOutlet weak var emptyView: UIView!
    
    var presenter: MainPresenter?
    var addresses: [Address]?{
        didSet{
            self.loadAddressesTable()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {
            self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        }
        activityIndicator.startAnimating()
        presenter = MainPresenter(self)
        presenter?.getAddresses()

    }
    
    @IBAction func toAddAddress(_ sender: Any) {
        Router.toAddAddress(self, nil)
    }
    
    @IBAction func toMap(_ sender: Any) {
        Router.toMaps(self)
    }
    
    @IBAction func dismiiss(_ sender: Any) {
        self.view.backgroundColor = .clear
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toAllLocations(_ sender: Any) {
        let prms: [String: String] = [
            "country_id": "1",
            "with": "regions"
        ]
        self.presenter?.getCities(prms)
    }
}
