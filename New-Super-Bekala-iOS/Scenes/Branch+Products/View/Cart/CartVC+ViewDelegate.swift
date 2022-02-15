//
//  CartVC+ViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 08/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import SVProgressHUD

extension CartVC: MainViewDelegate, LoginViewDelegate{
    func didCompleteWithProfile(_ error: String?) {
        SVProgressHUD.dismiss()
        if let error = error{
            showToast(error)
        }else{
            presenter?.getBranchBy(Int(selectedBranch!.id))
        }
    }
    func didCompleteWithBranchById(_ data: Branch?) {
        if let branch = data{
            
            if fetchingSelectedBranch{
                
                fetchingSelectedBranch = true
                Router.toBranch(self, branch)
                
            }else{
                
                guard self.linesTotal >= (branch.minOrder ?? 0.0) else{
                    if items!.filter({ return $0.is_media }).isEmpty{
                        if "lang".localized == "en"{
                            showAlert(title: "", message: "Order from \(branch.name!.en!) must be at least \(branch.minOrder ?? 0.0) EGP")
                        }else{
                            let msg = "الطلب من خلال" + " \((branch.name?.ar)!)" + " يجب ان يكون علي الاقل " + String(branch.minOrder ?? 0.0) + " جنيه"
                            showAlert(title: "", message: msg)
                        }
                    }else{
                        let alert = UIAlertController(title: "Your voices, images or text in cart must be exceeds minimum order if they are not, your order won`t be proceed".localized, message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Continue".localized, style: .default, handler: { _ in
                            Router.toCheckout(self, branch, self.linesTotal)
                        }))
                        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .destructive, handler: nil))
                        self.present(alert, animated: true)
                    }
                    return
                }
                
                Router.toCheckout(self, branch, self.linesTotal)
            }
            
        }else{
            showToast(Shared.errorMsg)
        }
    }
    
    func didCompleteWithSetting(_ data: Setting?) {
        guard let setting = data else { return }
        self.setting = setting
    }
}
