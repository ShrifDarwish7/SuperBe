//
//  AskLocationVC+MainViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 13/03/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import SVProgressHUD

extension AskLocationVC: MainViewDelegate{
    func didCompleteWithCities(_ cities: [City]?) {
        if let _ = cities{
            Router.toCities(self, cities!)
        }
    }
}
