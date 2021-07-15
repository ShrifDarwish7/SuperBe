//
//  BranchVC+BranchViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 31/03/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

extension BranchVC: MainViewDelegate{
    func didCompleteWithBranchCats(_ data: [BranchCategory]?) {
        self.filtersCollectionView.hideSkeleton()
        if let data = data{
            self.categories = data
            guard !self.categories!.isEmpty else { return }
            self.categories?[0].selected = true
            self.selectedCat = data.first
            self.loadFiltersCollection()
            prms.updateValue("branch_category_id=\(self.selectedCat?.id ?? 0)", forKey: "filter")
            prms.updateValue("variations.options", forKey: "with")
            presenter?.getBranchProduct(id: branch!.id, prms: prms)
        }
    }
    func didCompleteWithBranchProducts(_ data: [Product]?) {
        self.productsCollectionView.hideSkeleton()
        if let data = data{
            self.products = data
            isLoading = false
            loadProductsCollection()
        }
    }
}
