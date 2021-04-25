//
//  CartVC+TableViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 03/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit

extension CartVC: UITableViewDelegate, UITableViewDataSource{
    func loadProductsTableView(){
        let nib = UINib(nibName: CartProductTableViewCell.identifier, bundle: nil)
        productsTableView.register(nib, forCellReuseIdentifier: CartProductTableViewCell.identifier)
        productsTableView.delegate = self
        productsTableView.dataSource = self
        productsTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartProductTableViewCell.identifier, for: indexPath) as! CartProductTableViewCell
        cell.name.text = "\(items![indexPath.row].cart_id)"//"lang".localized == "en" ? items![indexPath.row].nameEn : items![indexPath.row].nameAr
        cell.quantity.text = "\(items![indexPath.row].quantity)"
        cell.desc.text = items![indexPath.row].desc
        cell.desc.isHidden = items![indexPath.row].desc == "" ? true : false
        cell.increaseBtn.onTap { [self] in
            guard Int(cell.quantity.text!)! > 0 else{
                return
            }
            var newQty: Int = Int(cell.quantity.text!)!
            newQty += 1
            cell.quantity.text = "\(newQty)"
            CartServices.shared.updateQuantity(newValue: newQty, id: Int(self.items![indexPath.row].cart_id), nil)
            productsTableView.reloadData()
        }
        cell.decreaseBtn.onTap { [self] in
            guard Int(cell.quantity.text!)! > 1 else{
                return
            }
            var newQty: Int = Int(cell.quantity.text!)!
            newQty -= 1
            cell.quantity.text = "\(newQty)"
            CartServices.shared.updateQuantity(newValue: newQty, id: Int(self.items![indexPath.row].cart_id), nil)
            productsTableView.reloadData()
        }
        cell.price.text = "\(items![indexPath.row].price * Double(cell.quantity.text!)!) EGP"
        cell.productImage.sd_setImage(with: URL(string: Shared.storageBase + (items![indexPath.row].logo ?? "")))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextualAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            CartServices.shared.removeItemAt(self.items![indexPath.row]) { (completed) in
                self.fetchCartBranches()
                self.fetchCartItems()
            }
        }
        return UISwipeActionsConfiguration(actions: [contextualAction])
    }
}
