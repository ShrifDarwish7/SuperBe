//
//  OffersVC+ViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 24/05/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit

extension OffersVC: MainViewDelegate{
//    func updateBranches(){
//        self.parameters.updateValue("branchProducts.variations.options", forKey: "with")
//        self.parameters.updateValue("\(page)", forKey: "page")
//        self.parameters.updateValue("5", forKey: "per_page")
//        self.parameters.updateValue("1", forKey: "offers_only")
//        print("offers prms",parameters)
//        self.presenter?.getBranches(parameters)
//    }
//    func didCompleteWithCategories(_ data: [Category]?) {
//        if let _ = data{
//            self.categories = data
//            self.categoriesBtn.isHidden = false
//            if "lang".localized == "ar"{
//                self.categories = self.categories?.reversed()
//                selectCategory(index: categories!.count-1)
//            }else{
//                selectCategory(index: 0)
//            }
////            if "lang".localized == "en"{
////                self.categories?[0].selected = true
////                self.selectedCategory = self.categories?[0]
////            }else{
////                self.categories![self.categories!.count-1].selected = true
////                self.selectedCategory = self.categories?[self.categories!.count-1]
////            }
////            self.loadFiltersCollection()
////            self.view.stopSkeletonAnimation()
////            updateBranches()
//        }
//    }
//    func didCompleteWithCoupons(_ data: [Branch]?, _ meta: Meta?) {
//        offersTableView.hideSkeleton()
//        if let data = data,
//           !data.isEmpty,
//           let meta = meta{
//            DispatchQueue.main.async { [self] in
//                self.meta = meta
//                data.filter({ return !$0.coupons!.isEmpty }).forEach { branch in
//                    self.branches.append(branch)
//                }
//                page += 1
//                self.isLoading = false
//                let contentOffset = scrollView.contentOffset
//                self.loadTbl()
//                offersTableView.setContentOffset(contentOffset, animated: false)
//                let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
//                activityIndicator.startAnimating()
//                offersTableView.tableFooterView = activityIndicator
//                offersTableView.tableFooterView?.isHidden = false
//                isPaginting = false
//            }
//        }
//    }
    
    func didCompleteWithBranches(_ data: [Branch]?,_ meta: Meta?) {
        offersTableView.hideSkeleton()
        if let data = data,
           !data.isEmpty,
           let meta = meta{
            DispatchQueue.main.async { [self] in
                self.meta = meta
                data.forEach { branch in
                    self.branches.append(branch)
                }
                page += 1
                self.isLoading = false
                self.offersTableView.hideSkeleton()
                let contentOffset = scrollView.contentOffset
                self.loadTbl()
                offersTableView.setContentOffset(contentOffset, animated: false)
                let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
                activityIndicator.startAnimating()
                offersTableView.tableFooterView = activityIndicator
                offersTableView.tableFooterView?.isHidden = false
                isPaginting = false
            }
        }
    }
    func didCompleteWithSlider(_ data: [Slider]?, _ error: String?) {
        specialOffersCollection.hideSkeleton()
        if let data = data, !data.isEmpty{
            self.slider = data
        }else{
            specialOffersStack.isHidden = true
        }
    }
    func didCompleteWithBranchById(_ data: Branch?) {
        if let branch = data{
            Router.toBranch(self, branch)
        }
    }
}
