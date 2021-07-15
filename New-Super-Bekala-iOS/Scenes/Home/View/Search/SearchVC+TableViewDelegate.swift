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
            Router.toBranch(self, self.branches![indexPath.row])
        case .products:
            Router.toProduct(self, self.products![indexPath.row])
        }
    }
}
