//
//  OffersVC+TableViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 24/05/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit

extension OffersVC: UITableViewDelegate, UITableViewDataSource{
    
    func loadTbl(){
        if isLoading{
            let nib = UINib(nibName: OnSaleSkeletonTableViewCell.identifier, bundle: nil)
            offersTableView.register(nib, forCellReuseIdentifier: OnSaleSkeletonTableViewCell.identifier)
        }else{
            let nib = UINib(nibName: OffersTableViewCell.identifier, bundle: nil)
            offersTableView.register(nib, forCellReuseIdentifier: OffersTableViewCell.identifier)
        }
        offersTableView.delegate = self
        offersTableView.dataSource = self
        offersTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return branches?.count ?? 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading{
            let cell = tableView.dequeueReusableCell(withIdentifier: OnSaleSkeletonTableViewCell.identifier, for: indexPath) as! OnSaleSkeletonTableViewCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: OffersTableViewCell.identifier, for: indexPath) as! OffersTableViewCell
            //cell.branchName.text = "lang".localized == "en" ? self.branches![indexPath.row].branchLanguage?.first?.name : self.branches![indexPath.row].branchLanguage?[1].name
            cell.branchName.text = "\(self.branches![indexPath.row].id)"
            
//            cell.branchRate.rating = self.branches![indexPath.row].rating ?? 2.0
            cell.vendorImage.kf.indicatorType = .activity
            cell.vendorImage.kf.setImage(with: URL(string: Shared.storageBase + self.branches![indexPath.row].logo!), placeholder: nil, options: [], completionHandler: nil)
            
            cell.onsaleCollectionView.numberOfItemsInSection { (_) -> Int in
                return self.branches![indexPath.row].products!.count
            }.cellForItemAt { (productIndexRow) -> UICollectionViewCell in
                let nib = UINib(nibName: OnSaleCollectionViewCell.identifier, bundle: nil)
                cell.onsaleCollectionView.register(nib, forCellWithReuseIdentifier: OnSaleCollectionViewCell.identifier)
                let cell = cell.onsaleCollectionView.dequeueReusableCell(withReuseIdentifier: OnSaleCollectionViewCell.identifier, for: indexPath) as! OnSaleCollectionViewCell
                cell.loadUI(data: self.branches![indexPath.row].products![productIndexRow.row])
                
                let inCartItems = self.cartItems?.filter({ return $0.cart_id == String(self.branches![indexPath.row].products![productIndexRow.row].id!) })
                if inCartItems!.isEmpty{
                    cell.inCartView.isHidden = true
                    cell.addToCartBtn.isHidden = false
                }else{
                    cell.inCartView.isHidden = false
                    cell.addToCartBtn.isHidden = true
                    cell.quantity.text = "\(inCartItems?.first?.quantity ?? 1)"
                }
                
                cell.addToCartBtn.onTap {
                    let contentOffset = self.offersTableView.contentOffset
                    guard self.branches![indexPath.row].products![indexPath.row].variations == nil || (self.branches![indexPath.row].products![indexPath.row].variations?.isEmpty == true) else {
                        Router.toProduct(self, self.branches![indexPath.row].products![productIndexRow.row])
                        return
                    }
                    
                    cell.inCartView.isHidden = false
                    cell.addToCartBtn.isHidden = true
                    
                    self.branches![indexPath.row].products![productIndexRow.row].quantity = 1
                    self.branches![indexPath.row].products![productIndexRow.row].notes = ""
                    self.branches![indexPath.row].products![productIndexRow.row].branch = self.branches![indexPath.row]
                    
                    CartServices.shared.addToCart(self.branches![indexPath.row].products![productIndexRow.row]) { (completed) in
                        if completed{
                            CartServices.shared.getCartItems(itemId: "-1", branch: -1) { [self] (items) in
                                self.cartItems = items
                               // self.offersTableView.reloadData()
                            }
                        }
                    }
                    self.offersTableView.setContentOffset(contentOffset, animated: false)

                }
                
                
                cell.increaseBtn.onTap {
                    guard Int(cell.quantity.text!)! > 0 else{
                        return
                    }
                    var newQty: Int = Int(cell.quantity.text!)!
                    newQty += 1
                    cell.quantity.text = "\(newQty)"
                    CartServices.shared.updateQuantity(newValue: newQty, id: (inCartItems!.first!.cart_id)!, nil)
                }
                
                cell.decreaseBtn.onTap {
                    guard Int(cell.quantity.text!)! > 1 else{
                        return
                    }
                    var newQty: Int = Int(cell.quantity.text!)!
                    newQty -= 1
                    cell.quantity.text = "\(newQty)"
                    CartServices.shared.updateQuantity(newValue: newQty, id: (inCartItems!.first!.cart_id)!, nil)
                }
                self.viewWillLayoutSubviews()
                return cell
            }.sizeForItemAt { (_) -> CGSize in
                return CGSize(width: 180, height: 220)
            }.didSelectItemAt { (productIndex) in
                Router.toProduct(self, self.branches![indexPath.row].products![productIndex.row])
            }
            self.viewWillLayoutSubviews()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if (scrollView.contentOffset.y == 0) {
//            UIView.animate(withDuration: 0.3) {
//                self.pageControl.isHidden = false
//                self.stackHeightCnst.constant = 245
//                self.view.layoutIfNeeded()
//            }
//        }else{
//            UIView.animate(withDuration: 0.3) {
//                self.pageControl.isHidden = true
//                self.stackHeightCnst.constant = 0
//                self.view.layoutIfNeeded()
//            }
//        }
//    }
    
}
