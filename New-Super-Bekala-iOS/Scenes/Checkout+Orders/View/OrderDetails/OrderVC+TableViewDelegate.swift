//
//  OrderVC+TableViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 22/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit

extension OrderVC: UITableViewDelegate, UITableViewDataSource{
    
    func loadProductsTable(){
        let nib = UINib(nibName: CartProductTableViewCell.identifier, bundle: nil)
        productsTableView.register(nib, forCellReuseIdentifier: CartProductTableViewCell.identifier)
        productsTableView.delegate = self
        productsTableView.dataSource = self
        productsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (order?.lineItems!.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartProductTableViewCell.identifier, for: indexPath) as! CartProductTableViewCell
        cell.decreaseBtn.isHidden = true
        cell.increaseBtn.isHidden = true
        let product = order?.lineItems![indexPath.row]
        cell.name.text = "lang".localized == "en" ? product?.branchProduct.name?.en : product?.branchProduct.name?.ar
        cell.price.text = "\(product?.linePrice ?? 0) " + "EGP"
        cell.quantity.text = "\(product?.quantity ?? 0)"
        
        if let images = product?.branchProduct.images{
            cell.productImage.sd_setImage(with: URL(string: Shared.storageBase + (images.first)!))
        }else{
            cell.productImage.sd_setImage(with: URL(string: Shared.storageBase + (order?.branch?.logo)!))
        }
        
        if let variations = product?.variations, !variations.isEmpty{
            cell.desc.isHidden = false
            var desc = ""
            variations.forEach { (variation) in
                var opts = ""
                variation.options?.forEach({ (option) in
                    opts += (("lang".localized == "en" ? "\(option.name?.en ?? ""), " : "\(option.name?.ar ?? ""), "))
                })
                desc += (( "lang".localized == "en" ? "\(variation.name?.en ?? ""): " : "\(variation.name?.ar ?? ""): " ) + opts + "\n")
            }
            cell.desc.text = desc
        }else{
            cell.desc.isHidden = true
        }
        self.viewWillLayoutSubviews()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
