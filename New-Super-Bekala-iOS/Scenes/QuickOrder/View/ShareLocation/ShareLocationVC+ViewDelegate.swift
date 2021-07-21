//
//  ShareLocationVC+ViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 30/06/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

extension ShareLocationVC: MainViewDelegate{
    
    func didCompleteWithAddresses(_ data: [Address]?) {
        self.activityIndicator.stopAnimating()
        if let addresses = data{
            self.addresses = addresses
        }
    }
}
