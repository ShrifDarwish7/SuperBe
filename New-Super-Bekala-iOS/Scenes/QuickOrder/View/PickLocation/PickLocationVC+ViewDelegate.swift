//
//  PickLocationVC+ViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 30/06/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import SVProgressHUD

extension PickLocationVC: MainViewDelegate{
    func showProgress() {
        SVProgressHUD.show()
    }
    
    func dismissProgress() {
        SVProgressHUD.dismiss()
    }
    
    func didCompleteWithGoogleAddress(_ data: GoogleMapAddress?) {
        if let _ = data{
            self.locationLbl.text = data?.formattedAddress
        }
    }
}
