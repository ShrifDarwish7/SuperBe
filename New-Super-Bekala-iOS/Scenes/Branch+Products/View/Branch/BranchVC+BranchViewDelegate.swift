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
            self.categoriesBtn.isHidden = false
            guard !self.categories!.isEmpty else { return }
//            if "lang".localized == "en"{
//                self.categories?[0].selected = true
//                self.selectedCat = self.categories?[0]
//            }else{
//                self.categories![self.categories!.count-1].selected = true
//                self.selectedCat = self.categories?[self.categories!.count-1]
//            }
//            self.categories?[0].selected = true
//            self.selectedCat = self.categories?[0]
//            self.loadFiltersCollection()
//            prms.updateValue("branch_category_id=\(self.selectedCat?.id ?? 0)", forKey: "filter")
//            prms.updateValue("variations.options", forKey: "with")
//            presenter?.getBranchProduct(id: branch!.id, prms: prms)
            if "lang".localized == "ar"{
                self.categories = self.categories?.reversed()
                selectCategory(index: categories!.count-1)
            }else{
                selectCategory(index: 0)
            }
            
        }
    }
    func didCompleteWithBranchProducts(_ data: [Product]?) {
        self.productsCollectionView.hideSkeleton()
        if let data = data{
            self.products = data
            guard let products = products, !self.products!.isEmpty else{
                notFoundStack.isHidden = false
                return
            }
            for i in 0...products.count-1{
                if let vars = products[i].variations, !vars.isEmpty, vars.filter({ return $0.inStock == 1 }).isEmpty, products[i].price == 0.0{
                 self.products![i].inStock = 0
                }
            }
            isLoading = false
            loadProductsCollection()
        }
    }
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
