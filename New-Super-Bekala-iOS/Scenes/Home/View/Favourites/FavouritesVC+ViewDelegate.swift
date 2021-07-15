//
//  FavouritesVC+ViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 05/07/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

extension FavouritesVC: MainViewDelegate{
    func didCompleteWithFavourites() {
        self.branches = Shared.favBranches
        self.products = Shared.favProducts
        updataUI()
    }
    func didCompleteRemoveFromFavourites(_ error: String?, _ index: Int?, _ isFeatured: Bool?) {
        self.branches = Shared.favBranches
        self.products = Shared.favProducts
        updataUI()
    }
}
