//
//  ProfileVC+MainViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 18/05/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import SVProgressHUD

extension ProfileVC: MainViewDelegate, LoginViewDelegate{
    
    func didCompleteUpdateProfile() {
        SVProgressHUD.dismiss()
    }
    
    func didCompleteWithAddresses(_ data: [Address]?) {
        self.acitvityIndicator.stopAnimating()
        if let addresses = data{
            self.addresses = addresses
            self.selectedAddressTF.text = self.addresses?.filter({ return $0.selected == 1 }).first?.title
            showAllBtn.isHidden = addresses.count > 1 ? false : true
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
    
    func didCompleteAddToWallet(_ msg: String, _ status: Int) {
        showToast(msg)
        if status == 1{
            Shared.transaction = nil
        }
    }
    
    func didCompleteLogout(_ error: String?) {
        SVProgressHUD.dismiss()
        if let error = error {
            showToast(error)
        }else{
            APIServices.shared.isLogged = false
            APIServices.shared.skipFromLogin = true
            Shared.isChatting = false
            NotificationCenter.default.post(name: NSNotification.Name("is_chatting"), object: nil)
            UserDefaults.init().set("", forKey: "token")
            Shared.headers.removeAll()
            self.navigationController?.popViewController(animated: true)
            loginDelegate?.onLogout()
        }
    }
}
