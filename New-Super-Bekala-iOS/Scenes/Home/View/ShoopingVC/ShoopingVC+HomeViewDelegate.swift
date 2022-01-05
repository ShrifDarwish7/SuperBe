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
        self.parameters.updateValue("\(self.selectedCategory?.id ?? 0)", forKey: "category_id")
       // self.parameters.updateValue("coupons", forKey: "with")
        
        self.presenter?.getFeaturedBranches(parameters)
        self.presenter?.getOrdinaryBranches(parameters)
        
        print("here parameters",parameters)
    }
    
    func didCompleteWithFavourites() {
        
        print("cats prms",parameters)
        self.presenter?.getCategories(parameters)
        
    }
    
    func didCompleteWithCategories(_ data: [Category]?) {
        if let _ = data{
            self.categoriesBtn.isHidden = false
            self.categories = data
//            self.categories?[0].selected = true
//            self.selectedCategory = self.categories?[0]
//            if "lang".localized == "en"{
//                self.categories?[0].selected = true
//                self.selectedCategory = self.categories?[0]
//            }else{
//               // self.categories = self.categories?.reversed()
//                self.categories![self.categories!.count-1].selected = true
//                self.selectedCategory = self.categories?[self.categories!.count-1]
//            }
            if "lang".localized == "ar"{
                self.categories = self.categories?.reversed()
                selectCategory(index: categories!.count-1)
            }else{
                selectCategory(index: 0)
            }
            
            if Shared.shouldShowCategories{
                Router.toChooseCategory(self, self, "lang".localized == "ar" ? categories!.reversed() : categories!)
            }
//            self.loadFiltersCollection()
//            updateBranches()
        }
    }
    
    func didCompleteWithBranches(_ data: [Branch]?,_ meta: Meta?) {
        ordinaryVendorsTAbleView.hideSkeleton()
        if let data = data,
           !data.isEmpty{
            ordinaryVendorsTAbleView.isHidden = false
            self.branches = data
            self.ordinaryLoading = false
            self.loadOrdinaryTable(identifier: OrdinaryVendorTableViewCell.identifier)
            self.ordinaryVendorsTAbleView.stopSkeletonAnimation()
            self.tableViewHeight.constant = self.ordinaryVendorsTAbleView.contentSize.height + 20
            self.view.layoutIfNeeded()
        }else{
            ordinaryVendorsTAbleView.isHidden = true
        }
    }
    
    func didCompleteWithFeaturedBranches(_ data: [Branch]?) {
        featuredVendorsCollection.hideSkeleton()
        if let data = data,
           !data.isEmpty{
            self.featuredStackContainer.isHidden = false
            self.featuredLoading = false
            self.featuredVendorsCollection.isHidden = false
            self.featuredBranches = data
            self.loadFeaturedCollection(identifier: FeaturedCollectionViewCell.identifier)
        }else{
            self.featuredStackContainer.isHidden = true
        }
    }
    
    func didCompleteAddToFavourite(_ error: String?, _ index: Int?,_ isFeatured: Bool?) {
        if let error = error{
            showToast(error)
        }else{
//            if isFeatured!{
//                self.featuredBranches![index!].isFavourite = 1
//                self.loadFeaturedCollection(identifier: FeaturedCollectionViewCell.identifier)
//            }else{
//                self.branches![index!].isFavourite = 1
//                self.loadOrdinaryTable(identifier: OrdinaryVendorTableViewCell.identifier)
//            }
        }
    }
    
    func didCompleteRemoveFromFavourites(_ error: String?, _ index: Int?, _ isFeatured: Bool?) {
        if let error = error{
            showToast(error)
        }else{
//            if isFeatured!{
//                self.featuredBranches![index!].isFavourite = 0
//                let contentOffset = featuredVendorsCollection.contentOffset
//                self.loadFeaturedCollection(identifier: FeaturedCollectionViewCell.identifier)
//                featuredVendorsCollection.setContentOffset(contentOffset, animated: true)
//            }else{
//                self.branches![index!].isFavourite = 0
//                let contentOffset = scroller.contentOffset
//                self.loadOrdinaryTable(identifier: OrdinaryVendorTableViewCell.identifier)
//                scroller.setContentOffset(contentOffset, animated: true)
//            }
        }
    }
    
}
