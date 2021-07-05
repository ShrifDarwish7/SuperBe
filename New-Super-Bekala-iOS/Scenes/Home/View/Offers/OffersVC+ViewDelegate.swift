//
//  OffersVC+ViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 24/05/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

extension OffersVC: MainViewDelegate{
    func updateBranches(){
        self.parameters.updateValue("\(self.selectedCategory?.id ?? 0)", forKey: "category_id")
        self.parameters.updateValue("branchProducts.variations.options", forKey: "with")
        self.parameters.updateValue("1", forKey: "offersOnly")
        self.presenter?.getBranches(parameters)
    }
    func didCompleteWithCategories(_ data: [Category]?) {
        if let _ = data{
            self.categories = data
            self.categories?[0].selected = true
            self.selectedCategory = self.categories?[0]
            self.loadFiltersCollection()
            self.view.stopSkeletonAnimation()
            updateBranches()
        }
    }
    func didCompleteWithBranches(_ data: [Branch]?) {
        offersTableView.hideSkeleton()
        if let data = data,
           !data.isEmpty{
            self.branches = data.filter({ return !$0.products!.isEmpty })
        }
    }
    func didCompleteWithSlider(_ data: [Slider]?, _ error: String?) {
        specialOffersCollection.hideSkeleton()
        if let data = data{
            self.slider = data
        }
    }
    func didCompleteWithBranchById(_ data: Branch?) {
        if let branch = data{
            Router.toBranch(self, branch)
        }
    }
}
