//
//  ChangeLocationVC+ViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 27/06/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

extension ChangeLocationVC: MainViewDelegate{
    func didCompleteWithAddresses(_ data: [Address]?) {
        self.activityIndicator.stopAnimating()
        if let addresses = data{
            guard !addresses.isEmpty else{
                self.addressesTableView.isHidden = true
                self.emptyView.isHidden = false
                return
            }
            self.addresses = addresses
        }
    }
    func didCompleteUpdateAddress(_ error: String?) {
        if error == nil{
            NotificationCenter.default.post(name: NSNotification.Name("DID_CHOOSE_ADDRESS"), object: nil, userInfo: nil)
            self.view.backgroundColor = .clear
            self.dismiss(animated: true, completion: nil)
        }
    }
    func didCompleteWithCities(_ cities: [City]?) {
        if let _ = cities{
            Router.toCities(self, cities!)
        }
    }
}
