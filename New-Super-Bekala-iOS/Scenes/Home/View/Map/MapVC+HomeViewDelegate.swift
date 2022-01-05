//
//  MapVC+MainViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 24/01/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import SVProgressHUD

extension MapVC: MainViewDelegate{
    func showProgress() {
        SVProgressHUD.show()
    }
    func dismissProgress() {
        SVProgressHUD.dismiss()
    }
    func didCompleteAddAddress(_ error: String?) {
        if let error = error{
            showToast(error.localized)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    func didCompleteWithCategories(_ data: [Category]?) {
        SVProgressHUD.dismiss()
        if let data = data, !data.isEmpty {
            Shared.selectedCoords = "\(mapKitView.centerCoordinate.latitude),\(mapKitView.centerCoordinate.longitude)"
            Shared.isCoords = true
            Shared.isRegion = false
            Shared.userSelectLocation = true
            Shared.deliveringToTitle = self.addressTitle
            Router.toHome(self, true)
        }else{
            showAlert(title: nil, message: "Sorry, we don`t deliver here".localized)
        }
    }
    func didCompleteUpdateAddress(_ error: String?) {
        SVProgressHUD.dismiss()
        if let error = error {
            showToast(error)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
}
