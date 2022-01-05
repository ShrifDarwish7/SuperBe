//
//  SearchVC+ViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 09/05/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

extension SearchVC: MainViewDelegate{
    func didCompleteWithTags(_ data: [Tag]?, _ error: String?) {
        if let error = error {
            showToast(error)
        }else{
            guard let data = data, !data.isEmpty else { return }
            Router.toTags(self, data)
        }
    }
    func didCompeleteBranchesSearch(_ data: [Branch]?, _ error: String?) {
        if var data = data, !data.isEmpty {
            for i in 0...data.count-1{
                if let favBranches = Shared.favBranches,
                   !favBranches.isEmpty,
                   !favBranches.filter({ return $0.id == data[i].id}).isEmpty{
                    data[i].isFavourite = 1
                }
            }
            self.branches = data
        }else{
            self.resultTableView.isHidden = true
            self.notFoundStack.isHidden = false
        }
    }
    func didCompeleteProductsSearch(_ data: [Product]?, _ error: String?) {
        if let data = data, !data.isEmpty{
            self.products = data
        }else{
            self.resultTableView.isHidden = true
            self.notFoundStack.isHidden = false
        }
    }
    func didCompleteWithBranches(_ data: [Branch]?,_ meta: Meta?) {
        if let branches = data,
           !branches.isEmpty{
            
            self.branches = data
        }else{
            self.resultTableView.isHidden = true
            self.notFoundStack.isHidden = false
        }
    }
    func didCompleteAddToFavourite(_ error: String?, _ index: Int?,_ isFeatured: Bool?) {
        if let error = error{
            showToast(error)
        }else{
            self.branches![index!].isFavourite = 1
            let contentOffset = resultTableView.contentOffset
            self.loadFromNib()
            resultTableView.setContentOffset(contentOffset, animated: true)
        }
    }
    
    func didCompleteRemoveFromFavourites(_ error: String?, _ index: Int?, _ isFeatured: Bool?) {
        if let error = error{
            showToast(error)
        }else{
            self.branches![index!].isFavourite = 0
            let contentOffset = resultTableView.contentOffset
            self.loadFromNib()
            resultTableView.setContentOffset(contentOffset, animated: true)
        }
    }
}
