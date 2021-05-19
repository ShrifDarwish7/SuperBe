//
//  LastOrdersVC+ViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 21/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation

extension LastOrderVC: MainViewDelegate{
    func didCompleteWithMyOrders(_ data: [LastOrder]?) {
        self.lastOrdersTableView.hideSkeleton()
        if let data = data{
            if data.isEmpty{
                lastOrdersTableView.isHidden = true
                emptyView.isHidden = false
            }else{
                self.lastOrders = data
                self.isLoading = false
                self.loadFromNib()
            }
        }else{
            lastOrdersTableView.isHidden = true
            emptyView.isHidden = false
        }
    }
}
