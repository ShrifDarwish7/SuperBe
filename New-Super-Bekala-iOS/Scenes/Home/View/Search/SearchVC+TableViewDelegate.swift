//
//  SearchVC+TableViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 09/05/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit

extension SearchVC: UITableViewDelegate, UITableViewDataSource{
    
    func loadFromNib(){
        if isLoading{
            let nib = UINib(nibName: OrdinaryVendorsSkeletonTableViewCell.identifier, bundle: nil)
            resultTableView.register(nib, forCellReuseIdentifier: OrdinaryVendorsSkeletonTableViewCell.identifier)
        }else{
            switch context {
            case .vendors:
                let nib = UINib(nibName: OrdinaryVendorTableViewCell.identifier, bundle: nil)
                resultTableView.register(nib, forCellReuseIdentifier: OrdinaryVendorTableViewCell.identifier)
            case .products:
                let nib = UINib(nibName: ProductSearchResultTableViewCell.identifier, bundle: nil)
                resultTableView.register(nib, forCellReuseIdentifier: ProductSearchResultTableViewCell.identifier)
            }
        }
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch context {
        case .vendors:
            return self.branches?.count ?? 10
        case .products:
            return self.products?.count ?? 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: OrdinaryVendorsSkeletonTableViewCell.identifier) as! OrdinaryVendorsSkeletonTableViewCell
            return cell
            
        }else{
            
            switch context {
            case .vendors:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: OrdinaryVendorTableViewCell.identifier, for: indexPath) as! OrdinaryVendorTableViewCell

                cell.favouriteBtn.tag = indexPath.row
                cell.favouriteBtn.addTarget(self, action: #selector(addOrdinaryToFavourite(sender:)), for: .touchUpInside)
                cell.loadFrom(data: self.branches![indexPath.row])
                
                return cell
                
            case .products:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: ProductSearchResultTableViewCell.identifier, for: indexPath) as! ProductSearchResultTableViewCell
                
                let inCartItems = self.cartItems?.filter({ return $0.cart_id == String(self.products![indexPath.row].id!) })
                if inCartItems!.isEmpty{
                    cell.inCartView.isHidden = true
                    cell.addToCart.isHidden = false
                }else{
                    cell.inCartView.isHidden = false
                    cell.addToCart.isHidden = true
                    cell.quantity.text = "\(inCartItems?.first?.quantity ?? 1)"
                }
                
                cell.addToCart.onTap {
                    
                    guard self.products![indexPath.row].variations == nil || (self.products![indexPath.row].variations?.isEmpty == true) else {
                        Router.toProduct(self, self.products![indexPath.row])
                        return
                    }
                    
                    cell.inCartView.isHidden = false
                    cell.addToCart.isHidden = true
                    
                    self.products![indexPath.row].quantity = 1
                    self.products![indexPath.row].notes = ""
                    
                    CartServices.shared.addToCart(self.products![indexPath.row]) { (completed) in
                        if completed{
                            CartServices.shared.getCartItems(itemId: "-1", branch: -1) { [self] (items) in
                                self.cartItems = items
                                self.resultTableView.reloadData()
                            }
                        }
                    }
                    
                }
                
                cell.increaseBtn.onTap {
                    guard Int(cell.quantity.text!)! > 0 else{
                        return
                    }
                    var newQty: Int = Int(cell.quantity.text!)!
                    newQty += 1
                    cell.quantity.text = "\(newQty)"
                    CartServices.shared.updateQuantity(newValue: newQty, id: inCartItems!.first!.cart_id!, nil)
                }
                
                cell.decreaseBtn.onTap { 
                    guard Int(cell.quantity.text!)! > 1 else{
                        return
                    }
                    var newQty: Int = Int(cell.quantity.text!)!
                    newQty -= 1
                    cell.quantity.text = "\(newQty)"
                    CartServices.shared.updateQuantity(newValue: newQty, id: inCartItems!.first!.cart_id!, nil)
                }
                
                cell.loadFrom(self.products![indexPath.row])
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLoading{
            return 80
        }else{
            return 125
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch context {
        case .vendors:
            if self.branches![indexPath.row].isOpen == 1{
                Router.toBranch(self, self.branches![indexPath.row])
            }else if self.branches![indexPath.row].isOnhold == 1{
                let msg = "lang".localized == "en" ? "\(self.branches![indexPath.row].name?.en ?? "") is on hold at the moment" : "\(self.branches![indexPath.row].name?.ar ?? "") معلق حاليا"
                showAlert(title: "", message: msg)
            }else if self.branches![indexPath.row].isOpen == 0 || self.branches![indexPath.row].isBusy == 1 {
                let msg = "lang".localized == "en" ? "\(self.branches![indexPath.row].name?.en ?? "") is currently busy, and is not accepting orders at this time, you can continue exploring and adding items to your cart and order when vendor is available" : "\(self.branches![indexPath.row].name?.ar ?? "") مشغول حاليًا ، ولا يقبل الطلبات في الوقت الحالي ، يمكنك متابعة استكشاف المنتجات وإضافتها إلى سلة التسوق وطلبها عند توفر المتجر"
                let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
                let continueAction = UIAlertAction(title: "Contiue".localized, style: .default) { _ in
                    Router.toBranch(self, self.branches![indexPath.row])
                }
                let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
                alert.addAction(continueAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
        case .products:
            guard self.products![indexPath.row].inStock == 1 else { return }
            Router.toProduct(self, self.products![indexPath.row])
        }
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
