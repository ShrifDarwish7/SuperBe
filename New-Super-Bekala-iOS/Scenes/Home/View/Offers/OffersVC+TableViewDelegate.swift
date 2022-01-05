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
        let contentOffset = offersTableView.contentOffset
        if isLoading{
            let nib = UINib(nibName: OnSaleSkeletonTableViewCell.identifier, bundle: nil)
            offersTableView.register(nib, forCellReuseIdentifier: OnSaleSkeletonTableViewCell.identifier)
            offersTableView.isScrollEnabled = false
        }else{
            switch offersTabs.filter({ return $0.selected }).first?.name{
            case "Offers".localized, "Special".localized:
                let nib = UINib(nibName: OffersTableViewCell.identifier, bundle: nil)
                offersTableView.register(nib, forCellReuseIdentifier: OffersTableViewCell.identifier)
            case "Coupons".localized:
                offersTableView.register(CouponsTableViewCell.nib(), forCellReuseIdentifier: CouponsTableViewCell.identifier)
            default: break
            }
        }
        offersTableView.isScrollEnabled = true
        offersTableView.delegate = self
        offersTableView.dataSource = self
        offersTableView.reloadData()
        offersTableView.setContentOffset(contentOffset, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading{
            return 3
        }else{
            return branches.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !branches.isEmpty else { return }
        if self.branches[indexPath.row].isOnhold == 1{
            
            let msg = "lang".localized == "en" ? "\(self.branches[indexPath.row].name?.en ?? "") is on hold at the moment" : "\(self.branches[indexPath.row].name?.ar ?? "") معلق حاليا"
            showAlert(title: "", message: msg)
            
        }else if self.branches[indexPath.row].isBusy == 1 {
            
            let msg = "lang".localized == "en" ? "\(self.branches[indexPath.row].name?.en ?? "") is currently busy, and your order may take longer than expected" : "\(self.branches[indexPath.row].name?.en ?? "") مشغول حاليًا ، وقد يستغرق طلبك وقتًا أطول من المتوقع"
            let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
            let continueAction = UIAlertAction(title: "Contiue".localized, style: .default) { _ in
                Router.toBranch(UIApplication.getTopViewController()!, self.branches[indexPath.row])
            }
            let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
            alert.addAction(continueAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
        }else if self.branches[indexPath.row].isOpen == 1{
            
            Router.toBranch(UIApplication.getTopViewController()!, self.branches[indexPath.row])
            
        }else if self.branches[indexPath.row].isOpen == 0 {
            
           // let msg = "lang".localized == "en" ? "\(self.branches![indexPath.row].name?.en ?? "") is currently closed, and is not accepting orders at this time, you can continue exploring and adding items to your cart and order when vendor is available" : "\(self.branches![indexPath.row].name?.ar ?? "") مغلق حاليًا ، ولا يقبل الطلبات في الوقت الحالي ، يمكنك متابعة استكشاف المنتجات وإضافتها إلى سلة التسوق وطلبها عند توفر المتجر"
            let msg = "lang".localized == "en" ? "\(self.branches[indexPath.row].name?.en ?? "") is currently closed, and will open in \(self.branches[indexPath.row].openingTime ?? "")" : "\(self.branches[indexPath.row].name?.ar ?? "") " +  "مغلق حاليا، وسيكون متاح الساعة" + " \(self.branches[indexPath.row].openingTime ?? "")"
            
            let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
            let continueAction = UIAlertAction(title: "Contiue".localized, style: .default) { _ in
                Router.toBranch(UIApplication.getTopViewController()!, self.branches[indexPath.row])
            }
            let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
            alert.addAction(continueAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
        }
       // Router.toBranch(self, branches[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading{
            let cell = tableView.dequeueReusableCell(withIdentifier: OnSaleSkeletonTableViewCell.identifier, for: indexPath) as! OnSaleSkeletonTableViewCell
            return cell
        }else{
            
            switch offersTabs.filter({ return $0.selected }).first?.name{
            case "Offers".localized, "Special".localized:
                let cell = tableView.dequeueReusableCell(withIdentifier: OffersTableViewCell.identifier, for: indexPath) as! OffersTableViewCell
                cell.branchName.text = "lang".localized == "en" ? self.branches[indexPath.row].name?.en : self.branches[indexPath.row].name?.ar
                
                cell.branchRate.rating = Double(self.branches[indexPath.row].rating ?? "0.0")!
                cell.vendorImage.kf.indicatorType = .activity
                cell.vendorImage.kf.setImage(with: URL(string: Shared.storageBase + self.branches[indexPath.row].logo!), placeholder: nil, options: [], completionHandler: nil)
                
                cell.onsaleCollectionView.numberOfItemsInSection { (_) -> Int in
                    return self.branches[indexPath.row].products!.count
                }.cellForItemAt { (productIndexRow) -> UICollectionViewCell in
                    
                    let nib = UINib(nibName: OnSaleCollectionViewCell.identifier, bundle: nil)
                    cell.onsaleCollectionView.register(nib, forCellWithReuseIdentifier: OnSaleCollectionViewCell.identifier)
                    let cell = cell.onsaleCollectionView.dequeueReusableCell(withReuseIdentifier: OnSaleCollectionViewCell.identifier, for: indexPath) as! OnSaleCollectionViewCell
                    cell.loadUI(data: self.branches[indexPath.row].products![productIndexRow.row])
                    
                    let inCartItems = self.cartItems?.filter({ return $0.cart_id == String(self.branches[indexPath.row].products![productIndexRow.row].id!) })
                    if inCartItems!.isEmpty{
                        cell.inCartView.isHidden = true
                        cell.addToCartBtn.isHidden = false
                    }else{
                        cell.inCartView.isHidden = false
                        cell.addToCartBtn.isHidden = true
                        cell.quantity.text = "\(inCartItems?.first?.quantity ?? 1)"
                    }
                    
                    cell.addToCartBtn.onTap {
                        let contentOffset = self.scroller.contentOffset
                        guard self.branches[indexPath.row].products![productIndexRow.row].variations == nil || (self.branches[indexPath.row].products![productIndexRow.row].variations?.isEmpty == true) else {
                            Router.toProduct(self, self.branches[indexPath.row].products![productIndexRow.row])
                            return
                        }

                        cell.inCartView.isHidden = false
                        cell.addToCartBtn.isHidden = true

                        self.branches[indexPath.row].products![productIndexRow.row].quantity = 1
                        self.branches[indexPath.row].products![productIndexRow.row].notes = ""
                        self.branches[indexPath.row].products![productIndexRow.row].branch = self.branches[indexPath.row]

                        CartServices.shared.addToCart(self.branches[indexPath.row].products![productIndexRow.row]) { (completed) in
                            if completed{
                                CartServices.shared.getCartItems(itemId: "-1", branch: -1) { [self] (items) in
                                    self.cartItems = items
                                }
                            }
                        }
                        self.offersTableView.reloadData()
                        self.scroller.setContentOffset(contentOffset, animated: false)

                    }
                    
                    cell.increaseBtn.onTap {
                        guard Int(cell.quantity.text!)! > 0 else{ return }
                        var newQty: Int = Int(cell.quantity.text!)!
                        newQty += 1
                        cell.quantity.text = "\(newQty)"
                        CartServices.shared.updateQuantity(newValue: newQty, id: (inCartItems!.first!.cart_id)!, nil)
                        CartServices.shared.getCartItems(itemId: "-1", branch: -1) { [self] (items) in
                            self.cartItems = items
                        }
                    }

                    cell.decreaseBtn.onTap {
                        guard Int(cell.quantity.text!)! > 1 else{ return }
                        var newQty: Int = Int(cell.quantity.text!)!
                        newQty -= 1
                        cell.quantity.text = "\(newQty)"
                        CartServices.shared.updateQuantity(newValue: newQty, id: (inCartItems!.first!.cart_id)!, nil)
                        CartServices.shared.getCartItems(itemId: "-1", branch: -1) { [self] (items) in
                            self.cartItems = items
                        }
                    }
                    self.viewWillLayoutSubviews()
                    return cell
                }.sizeForItemAt { (_) -> CGSize in
                    return CGSize(width: 180, height: 220)
                }.didSelectItemAt { [self] (productIndex) in
                    print(self.branches[indexPath.row].products![productIndex.row])
                    branches[indexPath.row].products![productIndex.row].branch = branches[indexPath.row]
                    Router.toProduct(self, branches[indexPath.row].products![productIndex.row])
                }
                self.viewWillLayoutSubviews()
                return cell
                
            case "Coupons".localized:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: CouponsTableViewCell.identifier, for: indexPath) as! CouponsTableViewCell
                cell.loadFrom(branches[indexPath.row])
                cell.copyBtn.onTap {
                    UIPasteboard.general.string = self.slider![indexPath.row].name
                    self.showAlert(title: "", message: "Coupon copied to clipboard".localized)
                }
                return cell
                
            default: return UITableViewCell()
            }
            
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLoading{
            return 350
        }else{
            switch offersTabs.filter({ return $0.selected }).first?.name{
            case "Offers".localized, "Special".localized:
                return 350
            case "Coupons".localized:
                return UITableView.automaticDimension
            default: return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.view.layoutIfNeeded()
        self.viewWillLayoutSubviews()
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
