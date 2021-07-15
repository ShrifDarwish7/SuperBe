//
//  FavouritesVC+TableViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 05/07/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit

extension FavouritesVC: UITableViewDelegate, UITableViewDataSource{
    
    func loadFromNib(){
        if isLoading{
            let nib = UINib(nibName: OrdinaryVendorsSkeletonTableViewCell.identifier, bundle: nil)
            favouritesTableView.register(nib, forCellReuseIdentifier: OrdinaryVendorsSkeletonTableViewCell.identifier)
        }else{
            switch query {
            case .product:
                let nib = UINib(nibName: ProductSearchResultTableViewCell.identifier, bundle: nil)
                favouritesTableView.register(nib, forCellReuseIdentifier: ProductSearchResultTableViewCell.identifier)
            case .branch:
                let nib = UINib(nibName: OrdinaryVendorTableViewCell.identifier, bundle: nil)
                favouritesTableView.register(nib, forCellReuseIdentifier: OrdinaryVendorTableViewCell.identifier)
            }
            
        }
        favouritesTableView.allowsSelection = true
        favouritesTableView.isUserInteractionEnabled = true
        favouritesTableView.isScrollEnabled = true
        favouritesTableView.isHidden = false
        favouritesTableView.delegate = self
        favouritesTableView.dataSource = self
        favouritesTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch query {
        case .branch:
            return branches?.count ?? 10
        case .product:
            return products?.count ?? 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: OrdinaryVendorsSkeletonTableViewCell.identifier, for: indexPath) as! OrdinaryVendorsSkeletonTableViewCell
            return cell
        }else{
            switch query {
            case .branch:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: OrdinaryVendorTableViewCell.identifier, for: indexPath) as! OrdinaryVendorTableViewCell
                cell.loadFrom(data: self.branches![indexPath.row])
                cell.favouriteBtn.setImage(UIImage(named: "heart-2"), for: .normal)
                cell.favouriteBtn.onTap {
                    self.isLoading = true
                    self.loadFromNib()
                    self.showSkeleton()
                    self.presenter?.removeFromFavourites(self.branches![indexPath.row].favouriteId!, nil, nil)
                }
                return cell
                
            case .product:
                
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
                        Router.toProduct(self.parent!, self.products![indexPath.row])
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
                                self.favouritesTableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch query {
        case .branch:
            Router.toBranch(self, self.branches![indexPath.row])
        case .product:
            Router.toProduct(self, self.products![indexPath.row])
        }
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let maxHeight: CGFloat = self.view.frame.height - UIApplication.shared.statusBarFrame.height - 80
        let minHeight: CGFloat = self.view.frame.height * 0.5
        let y: CGFloat = scrollView.contentOffset.y
        let newViewHeight = self.favouritesViewHeight.constant + y
        if newViewHeight > maxHeight{
            self.favouritesViewHeight.constant = maxHeight
        }else if newViewHeight < minHeight{
            self.favouritesViewHeight.constant = minHeight
        }else{
            self.favouritesViewHeight.constant = newViewHeight
        }
    }
    
}
