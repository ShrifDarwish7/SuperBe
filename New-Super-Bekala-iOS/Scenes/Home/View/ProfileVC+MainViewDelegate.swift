//
//  ProfileVC+MainViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 18/05/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

extension ProfileVC: MainViewDelegate{
    func didCompleteWithAddresses(_ data: [Address]?) {
        self.acitvityIndicator.stopAnimating()
        if let addresses = data{
            self.addresses = addresses
            self.selectedAddressLbl.text = self.addresses?.filter({ return $0.selected == 1 }).first?.title
            self.loadAddressesTable()
        }
    }
    
    func didCompleteUpdateAddress(_ error: String?) {
        if let error = error{
            showToast(error.localized)
        }else{
            self.acitvityIndicator.startAnimating()
            self.presenter?.getAddresses()
        }
    }
    
    func didCompleteDeleteAddress(_ error: String?) {
        if let error = error{
            showToast(error.localized)
        }else{
            self.acitvityIndicator.startAnimating()
            self.presenter?.getAddresses()
        }
    }
}
