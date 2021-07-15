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
        let lineItem = order?.lineItems![indexPath.row]
        cell.name.text = "lang".localized == "en" ? lineItem?.branchProduct?.name?.en : lineItem?.branchProduct?.name?.ar
        var linePrice = lineItem?.linePrice ?? 0.0
        
        cell.productImage.kf.indicatorType = .activity
        if let images = lineItem?.branchProduct?.images{
            cell.productImage.kf.setImage(with: URL(string: Shared.storageBase + (images.first)!), placeholder: nil, options: [], completionHandler: nil)
        }else{
            cell.productImage.kf.setImage(with: URL(string: Shared.storageBase + (order?.branch?.logo)!), placeholder: nil, options: [], completionHandler: nil)
        }
        
        if let variations = lineItem?.variations, !variations.isEmpty{
            cell.desc.isHidden = false
            var desc = ""
            variations.forEach { (variation) in
                
                variations.forEach { variation in
                    variation.options?.forEach({ option in
                        linePrice += (option.price ?? 0.0)
                    })
                }
                
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
        
        cell.price.text = "\(linePrice) EGP"
        cell.quantity.text = "\(lineItem?.quantity ?? 0)"
        
        self.viewWillLayoutSubviews()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
