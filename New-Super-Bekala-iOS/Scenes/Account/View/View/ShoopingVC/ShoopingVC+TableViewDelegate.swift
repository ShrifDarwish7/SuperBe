//
//  ShoopingVC+TableViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 20/03/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit
import SkeletonView

extension ShoopingVC: SkeletonTableViewDelegate, UITableViewDataSource{
    
    func loadOrdinaryTable(identifier: String){
        let nib = UINib(nibName: identifier, bundle: nil)
        ordinaryVendorsTAbleView.register(nib, forCellReuseIdentifier: identifier)
        ordinaryVendorsTAbleView.delegate = self
        ordinaryVendorsTAbleView.dataSource = self
        ordinaryVendorsTAbleView.reloadData()
        ordinaryVendorsTAbleView.isScrollEnabled = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.branches?.count ?? 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading == true{
            let cell = tableView.dequeueReusableCell(withIdentifier: OrdinaryVendorsSkeletonTableViewCell.identifier) as! OrdinaryVendorsSkeletonTableViewCell
            self.view.layoutSubviews()
            self.viewWillLayoutSubviews()
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: OrdinaryVendorTableViewCell.identifier) as! OrdinaryVendorTableViewCell
            cell.loadFrom(data: self.branches![indexPath.row])
            self.viewWillLayoutSubviews()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Router.toBranch(self, self.branches![indexPath.row])
    }
}
