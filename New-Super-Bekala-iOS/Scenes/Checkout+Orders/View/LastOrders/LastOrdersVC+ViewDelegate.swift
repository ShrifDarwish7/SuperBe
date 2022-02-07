//
//  LastOrdersVC+ViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 21/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit

extension LastOrderVC: MainViewDelegate{
    func didCompleteWithMyOrders(_ data: [LastOrder]?,_ meta: Meta?) {
        refreshControl.endRefreshing()
        self.lastOrdersTableView.hideSkeleton()
        if let data = data{
            if data.isEmpty{
                lastOrdersTableView.isHidden = true
                emptyView.isHidden = false
            }else{
                data.forEach { order in self.lastOrders.append(order) }
                self.meta = meta
                self.isLoading = false
                self.loadFromNib()
                let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
                activityIndicator.startAnimating()
                lastOrdersTableView.tableFooterView = activityIndicator
                lastOrdersTableView.tableFooterView?.isHidden = false
            }
        }else{
            lastOrdersTableView.isHidden = true
            emptyView.isHidden = false
        }
    }
    func didCompleteWithMyServices(_ data: [LastOrder]?,_ meta: Meta?) {
        refreshControl.endRefreshing()
        self.lastOrdersTableView.hideSkeleton()
        if let data = data{
            if data.isEmpty{
                lastOrdersTableView.isHidden = true
                emptyView.isHidden = false
            }else{
                data.forEach { order in self.lastServices.append(order) }
                self.meta = meta
                self.isLoading = false
                self.loadFromNib()
                let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
                activityIndicator.startAnimating()
                lastOrdersTableView.tableFooterView = activityIndicator
                lastOrdersTableView.tableFooterView?.isHidden = false
            }
        }else{
            lastOrdersTableView.isHidden = true
            emptyView.isHidden = false
        }
    }
}
