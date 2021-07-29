//
//  CartVC+ViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 08/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

extension CartVC: MainViewDelegate{
    func didCompleteWithBranchById(_ data: Branch?) {
        if let branch = data{
            guard self.linesTotal >= (branch.minOrder ?? 0.0) else{
                if "lang".localized == "en"{
                    showAlert(title: "", message: "Order from \(branch.name!.en!) must be at least \(branch.minOrder ?? 0.0) EGP")
                }else{
                    let msg = "الطلب من خلال" + " \((branch.name?.ar)!)" + " يجب ان يكون علي الاقل " + String(branch.minOrder ?? 0.0) + " جنيه"
                    showAlert(title: "", message: msg
                    )
                }
                return
            }
            Router.toCheckout(self, branch)
        }else{
            showToast(Shared.errorMsg)
        }
    }
}
