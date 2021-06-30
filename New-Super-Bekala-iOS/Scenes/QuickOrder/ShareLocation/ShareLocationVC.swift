//
//  ShareLocationVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 30/06/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import GoogleMaps

class ShareLocationVC: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var blockView: UIView!
    @IBOutlet weak var addressesTableView: UITableView!
    @IBOutlet weak var addressesCnst: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var addresses: [Address]?{
        didSet{
            self.loadAddressesTable()
        }
    }
    var presenter: MainPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter = MainPresenter(self)
        self.dismissAdddressesAlert()
        
    }
    
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
        self.showAddressesAlert()
    }
    
    @IBAction func selectFromMap(_ sender: Any) {
        Router.toPickLocation(self)
    }
    
}
