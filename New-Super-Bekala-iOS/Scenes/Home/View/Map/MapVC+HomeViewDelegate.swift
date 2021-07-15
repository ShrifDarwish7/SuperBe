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
    
    func didCompleteWithGoogleAddress(_ data: GoogleMapAddress?) {
        if let _ = data{
            self.locationLbl.text = data?.formattedAddress
            self.cityTF.text = data?.city
            self.districtTF.text = (data?.area2 ?? "") + " " + (data?.area3 ?? "")
            self.streetTF.text = data?.streetNumber
        }
    }
    
    func didCompleteAddAddress(_ error: String?) {
        if let error = error{
            showToast(error.localized)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
}
