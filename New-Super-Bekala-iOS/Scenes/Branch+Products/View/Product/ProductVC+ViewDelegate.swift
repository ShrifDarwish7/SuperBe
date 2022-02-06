//
//  ProductVC+ViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 14/07/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit

extension ProductVC: MainViewDelegate{
    func didCompleteAddToFavourite(_ error: String?, _ index: Int?, _ isFeatured: Bool?) {
        if let error = error{
            showToast(error)
        }else{
            favouriteBtn.tag = 1
        }
    }
    func didCompleteRemoveFromFavourites(_ error: String?, _ index: Int?, _ isFeatured: Bool?) {
        if let error = error{
            showToast(error)
        }else{
            favouriteBtn.tag = 0
        }
    }
}
