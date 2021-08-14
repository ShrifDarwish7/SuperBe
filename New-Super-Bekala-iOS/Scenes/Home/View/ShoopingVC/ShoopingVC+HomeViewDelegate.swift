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
        
        self.presenter?.getFeaturedBranches(parameters)
        self.presenter?.getBranches(parameters)
        
        print("here parameters",parameters)
    }
    
    func didCompleteWithFavourites() {
        
//        if Shared.isRegion{
//            parameters.updateValue("\(Shared.selectedArea.regionsID ?? 0)", forKey: "region_id")
//            if Shared.selectedArea.subregionID != 0{
//                parameters.updateValue("\(Shared.selectedArea.subregionID ?? 0)", forKey: "subregion_id")
//            }
//        }else if Shared.isCoords{
//            parameters.updateValue(Shared.selectedCoords, forKey: "coordinates")
//        }
        parameters.updateValue("all", forKey: "lang")
        print("cats prms",parameters)
        self.presenter?.getCategories(parameters)
        
    }
    
    func didCompleteWithCategories(_ data: [Category]?) {
        if let _ = data{
            self.categoriesBtn.isHidden = false
            self.categories = data
            if "lang".localized == "en"{
                self.categories?[0].selected = true
                self.selectedCategory = self.categories?[0]
            }else{
                self.categories![self.categories!.count-1].selected = true
                self.selectedCategory = self.categories?[self.categories!.count-1]
            }
            self.loadFiltersCollection()
            updateBranches()
        }
    }
    
    func didCompleteWithBranches(_ data: [Branch]?,_ meta: Meta?) {
        ordinaryVendorsTAbleView.hideSkeleton()
        if let data = data,
           !data.isEmpty{
            print("here last branch",data.reversed().last)
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
            self.featuredLoading = false
            self.featuredVendorsCollection.isHidden = false
            self.featuredBranches = data.reversed()
            self.loadFeaturedCollection(identifier: FeaturedCollectionViewCell.identifier)
        }
    }
    
    func didCompleteAddToFavourite(_ error: String?, _ index: Int?,_ isFeatured: Bool?) {
        if let error = error{
            showToast(error)
        }else{
            if isFeatured!{
                self.featuredBranches![index!].isFavourite = 1
                let contentOffset = featuredVendorsCollection.contentOffset
                self.loadFeaturedCollection(identifier: FeaturedCollectionViewCell.identifier)
                featuredVendorsCollection.setContentOffset(contentOffset, animated: true)
            }else{
                self.branches![index!].isFavourite = 1
                let contentOffset = scroller.contentOffset
                self.loadOrdinaryTable(identifier: OrdinaryVendorTableViewCell.identifier)
                scroller.setContentOffset(contentOffset, animated: true)
            }
        }
    }
    
    func didCompleteRemoveFromFavourites(_ error: String?, _ index: Int?, _ isFeatured: Bool?) {
        if let error = error{
            showToast(error)
        }else{
            if isFeatured!{
                self.featuredBranches![index!].isFavourite = 0
                let contentOffset = featuredVendorsCollection.contentOffset
                self.loadFeaturedCollection(identifier: FeaturedCollectionViewCell.identifier)
                featuredVendorsCollection.setContentOffset(contentOffset, animated: true)
            }else{
                self.branches![index!].isFavourite = 0
                let contentOffset = scroller.contentOffset
                self.loadOrdinaryTable(identifier: OrdinaryVendorTableViewCell.identifier)
                scroller.setContentOffset(contentOffset, animated: true)
            }
        }
    }
    
}
