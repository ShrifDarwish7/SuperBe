//
//  ShoopingVC+MainViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 16/03/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import SkeletonView

extension ShoopingVC: MainViewDelegate{
    
    func updateBranches(){
        self.filtersCollectionView.hideSkeleton()
        self.parameters.updateValue("\(self.selectedCategory?.id ?? 0)", forKey: "category_id")
        
        self.presenter?.getFeaturedBranches(parameters)
        self.presenter?.getBranches(parameters)
        
        print("here parameters",parameters)
    }
    
    func didCompleteWithCategories(_ data: [Category]?) {
        if let _ = data{
            self.categories = data
            self.categories?[0].selected = true
            self.selectedCategory = self.categories?[0]
            self.loadFiltersCollection()
            self.filtersCollectionView.hideSkeleton()
            self.view.stopSkeletonAnimation()
            updateBranches()
        }
    }
    
    func didCompleteWithBranches(_ data: [Branch]?) {
        ordinaryVendorsTAbleView.hideSkeleton()
        if let data = data,
           !data.isEmpty{
            self.branches = data.reversed()
            self.ordinaryLoading = false
            self.loadOrdinaryTable(identifier: OrdinaryVendorTableViewCell.identifier)
            self.ordinaryVendorsTAbleView.stopSkeletonAnimation()
            self.tableViewHeight.constant = self.ordinaryVendorsTAbleView.contentSize.height + 20
            self.view.layoutIfNeeded()
        }
    }
    
    func didCompleteWithFeaturedBranches(_ data: [Branch]?) {
        featuredVendorsCollection.hideSkeleton()
        if let data = data,
           !data.isEmpty{
            //self.showSkeletonView()
            self.featuredLoading = false
            self.featuredVendorsCollection.isHidden = false
            self.featuredBranches = data.reversed()
            self.loadFeaturedCollection(identifier: FeaturedCollectionViewCell.identifier)
            
        }
    }
}
