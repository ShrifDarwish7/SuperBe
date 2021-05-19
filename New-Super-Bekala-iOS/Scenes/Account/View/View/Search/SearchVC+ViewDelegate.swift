//
//  SearchVC+ViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 09/05/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

extension SearchVC: MainViewDelegate{
    func didCompeleteBranchesSearch(_ data: [Branch]?, _ error: String?) {
        if let data = data, !data.isEmpty {
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
    func didCompleteWithBranches(_ data: [Branch]?) {
        if let branches = data,
           !branches.isEmpty{
            self.branches = data
        }else{
            self.resultTableView.isHidden = true
            self.notFoundStack.isHidden = false
        }
    }
}
