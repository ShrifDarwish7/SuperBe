//
//  CheckoutVC+ViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 08/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

extension CheckoutVC: MainViewDelegate{
    
    func didCompleteWithAddresses(_ data: [Address]?) {
        self.acitvityIndicator.stopAnimating()
        if let addresses = data{
            self.addresses = addresses
            self.selectedAddressLbl.text = self.addresses?.filter({ return $0.selected == 1 }).first?.title
            self.selectedAddressTF.text = self.addresses?.filter({ return $0.selected == 1 }).first?.title
            self.loadAddressesTable()
            self.shippingCostActivity.startAnimating()
            self.shippingLbl.isHidden = true
            self.presenter?.getShippingDetails(branch!.id)
        }
    }
    
    func didCompleteWithShippingDetails(_ data: ShippingDetails?) {
        shippingCostActivity.stopAnimating()
        if let data = data{
            shippingLbl.isHidden = false
            shippingLbl.text = (data.shippingCost ?? "0.0") + " " + "EGP".localized
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
    
    func didCompletePlaceOrder(_ error: String?,_ id: Int) {
        if let error = error{
            showToast(error)
        }else{
            Router.toOrderPlaced(self, id)
        }
    }
    
    func didCompleteValidateCoupons(_ status: Int, _ message: String?) {
        
        activityIndicator.stopAnimating()
        
        if status == 0{
            showAlert(title: "", message: message!)
            validateBtn.isHidden = false
            coupons = nil
        }else{
            verifiedCoupon.isHidden = false
        }
    }
}
