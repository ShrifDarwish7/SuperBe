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
        if self.ordinaryLoading{
            let cell = tableView.dequeueReusableCell(withIdentifier: OrdinaryVendorsSkeletonTableViewCell.identifier) as! OrdinaryVendorsSkeletonTableViewCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: OrdinaryVendorTableViewCell.identifier) as! OrdinaryVendorTableViewCell
            cell.favouriteBtn.tag = indexPath.row
            cell.favouriteBtn.addTarget(self, action: #selector(addOrdinaryToFavourite(sender:)), for: .touchUpInside)
//            if let favBranches = Shared.favBranches,
//               !favBranches.isEmpty,
//               !favBranches.filter({ return $0.id == self.branches![indexPath.row].id}).isEmpty{
//                self.branches![indexPath.row].isFavourite = 1
//            }
            cell.loadFrom(data: self.branches![indexPath.row])
            self.viewWillLayoutSubviews()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.branches![indexPath.row].isOpen == 1{
            Router.toBranch(self, self.branches![indexPath.row])
        }else if self.branches![indexPath.row].isOnhold == 1{
            let msg = "lang".localized == "en" ? "\(self.branches![indexPath.row].name?.en ?? "") is on hold at the moment" : "\(self.branches![indexPath.row].name?.ar ?? "") معلق حاليا"
            showAlert(title: "", message: msg)
        }else if self.branches![indexPath.row].isOpen == 0{
            let msg = "lang".localized == "en" ? "\(self.branches![indexPath.row].name?.en ?? "") is closed now" : "\(self.branches![indexPath.row].name?.ar ?? "") مغلق حاليا "
            let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
            let continueAction = UIAlertAction(title: "Contiue".localized, style: .default) { _ in
                Router.toBranch(self, self.branches![indexPath.row])
            }
            let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
            alert.addAction(continueAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.view.layoutIfNeeded()
        self.viewWillLayoutSubviews()
    }
    
    @objc func addOrdinaryToFavourite(sender: UIButton){
        if let favBranches = Shared.favBranches,
           !favBranches.isEmpty,
           !favBranches.filter({ return $0.id == self.branches![sender.tag].id}).isEmpty{
            let fav = favBranches.filter({ return $0.id == self.branches![sender.tag].id}).first
            presenter?.removeFromFavourites((fav?.favouriteId)!, sender.tag, false)
        }else{
            let prms = [
                "model_id": "\(self.branches![sender.tag].id)",
                "model": "Branch"
            ]
            self.presenter?.addToFavourite(prms, sender.tag, false)
        }
    }
}
