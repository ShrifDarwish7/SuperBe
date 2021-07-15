//
//  LastOrderVC+TableViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 21/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit

extension LastOrderVC: UITableViewDelegate, UITableViewDataSource{
    
    func loadFromNib(){
        if isLoading{
            let nib = UINib(nibName: OrdinaryVendorsSkeletonTableViewCell.identifier, bundle: nil)
            lastOrdersTableView.register(nib, forCellReuseIdentifier: OrdinaryVendorsSkeletonTableViewCell.identifier)
        }else{
            let nib = UINib(nibName: LastOrdersTableViewCell.identifier, bundle: nil)
            lastOrdersTableView.register(nib, forCellReuseIdentifier: LastOrdersTableViewCell.identifier)
        }
        lastOrdersTableView.isHidden = false
        lastOrdersTableView.delegate = self
        lastOrdersTableView.dataSource = self
        lastOrdersTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lastOrders?.count ?? 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: OrdinaryVendorsSkeletonTableViewCell.identifier, for: indexPath) as! OrdinaryVendorsSkeletonTableViewCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: LastOrdersTableViewCell.identifier, for: indexPath) as! LastOrdersTableViewCell
            cell.loadFrom(self.lastOrders![indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Router.toOrder(self, self.lastOrders![indexPath.row])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let maxHeight: CGFloat = self.view.frame.height - UIApplication.shared.statusBarFrame.height - 80
        let minHeight: CGFloat = self.view.frame.height * 0.5
        let y: CGFloat = scrollView.contentOffset.y
        let newViewHeight = self.ordersViewHeight.constant + y
        if newViewHeight > maxHeight{
            self.ordersViewHeight.constant = maxHeight
        }else if newViewHeight < minHeight{
            self.ordersViewHeight.constant = minHeight
        }else{
            self.ordersViewHeight.constant = newViewHeight
           // scrollView.contentOffset.y = 0
        }
    }
    
}
