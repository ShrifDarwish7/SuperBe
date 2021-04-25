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
            Router.toCheckout(self, branch)
        }else{
            showToast(Shared.errorMsg)
        }
    }
}
