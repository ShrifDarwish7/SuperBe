//
//  CheckoutVC+ViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 08/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import SVProgressHUD
import UIKit

extension CheckoutVC: MainViewDelegate, LoginViewDelegate, PhoneVerifyDelegate{
    
    func didCompleteWithSetting(_ data: Setting?) {
        guard let setting = data else { return }
        self.setting = setting
    }
    
    func didCompleteUpdateProfile() {
        SVProgressHUD.dismiss()
        Router.toVerifyPhone(self, self.phoneNumber.text!)
    }
    
    func onVerify() {
        self.verifiedPhoneNumber = self.phoneNumber.text?.arToEnDigits
        self.placeOrderAction(self)
    }
    
    func onCancelVerify() {
        if let _ = APIServices.shared.user?.phoneVerifiedAt,
           let phone = APIServices.shared.user?.phone{
            self.verifiedPhoneNumber = phone
            self.phoneNumber.text = phone
        }else{
            self.verifiedPhoneNumber = nil
            self.phoneNumber.text = ""
        }
    }
    
    func didCompleteWithAddresses(_ data: [Address]?) {
        self.acitvityIndicator.stopAnimating()
        if let addresses = data{
            self.addresses = addresses
            self.selectedAddressLbl.text = self.addresses?.filter({ return $0.selected == 1 }).first?.title
            self.selectedAddressTF.text = self.addresses?.filter({ return $0.selected == 1 }).first?.title
            self.loadAddressesTable()
            self.shippingCostActivity.startAnimating()
            self.shippingLbl.isHidden = true
            self.showAllBtn.isHidden = addresses.count > 1 ? false : true

            self.presenter?.getShippingDetails(branch!.id)
        }
    }
    
    func didCompleteWithShippingDetails(_ data: ShippingDetails?) {
        shippingCostActivity.stopAnimating()
        if let data = data{
            shippingCost = data.shippingCost
            shippingLbl.isHidden = false
            shippingLbl.text = "\(data.shippingCost ?? 0.0)" + " " + "EGP".localized
            updateBill()
        }
    }
    
    func didCompleteUpdateAddress(_ error: String?) {
        activityIndicator.stopAnimating()
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
            showAlert(title: nil, message: error)
        }else{
            self.placedOrderId = id
            if cartItems!.filter({ return $0.is_media }).isEmpty{
//                let alert = UIAlertController(title: "Your order has been sent successfully".localized, message: "The order will be prepared and delivered to you as soon as possible .. Happy experience".localized, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "Done".localized, style: .default, handler: { [self] (action) in
//                    Router.toHome(self, false)
//                    CartServices.shared.removeBranchWithItems(branch!.id, nil)
//                }))
//                present(alert,animated : true , completion : nil)
                Shared.selectedOrders = true
                CartServices.shared.removeBranchWithItems(branch!.id, nil)
                Router.toOrderPlaced(UIApplication.getTopViewController()!, id)
            }else{
                presenter?.uploadFilesToOrder(id, cartItems!)
            }
        }
    }
    
    func didCompleteUploadOrderFiles(_ error: String?) {
        if let error = error{
            showAlert(title: nil, message: error)
        }else{
//            let alert = UIAlertController(title: "Your order has been sent successfully".localized, message: "The order will be prepared and delivered to you as soon as possible .. Happy experience".localized, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Done".localized, style: .default, handler: { [self] (action) in
//                Router.toHome(self, false)
//                CartServices.shared.removeBranchWithItems(branch!.id, nil)
//            }))
//            present(alert,animated : true , completion : nil)
            Shared.selectedOrders = true
            CartServices.shared.removeBranchWithItems(branch!.id, nil)
            Router.toOrderPlaced(UIApplication.getTopViewController()!, placedOrderId!)
        }
    }
    
    func didCompleteValidateCoupons(_ status: Int,_ message: String?,_ discountAmount: Double?) {
        
        activityIndicator.stopAnimating()
                
        if status == 0{
            showAlert(title: "", message: message!)
            validateBtn.isHidden = false
            coupons = nil
        }else{
            self.discountAmount = discountAmount
            verifiedCoupon.isHidden = false
            if let index = Shared.coupons.firstIndex(where: { $0.branch == branch?.id }){
                Shared.coupons.remove(at: index)
            }
            print(Shared.coupons)
            updateBill()
        }
    }
}
