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
//        let nib = UINib(nibName: CartProductTableViewCell.identifier, bundle: nil)
//        productsTableView.register(nib, forCellReuseIdentifier: CartProductTableViewCell.identifier)
        productsTableView.delegate = self
        productsTableView.dataSource = self
        productsTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let photos = items![indexPath.row].photos{
            
            let photosData = try! JSONDecoder.init().decode([Data].self, from: photos)
            let photos = photosData.map({ UIImage(data: $0) })
            let nib = UINib(nibName: CartPhotosTableViewCell.identifier, bundle: nil)
            productsTableView.register(nib, forCellReuseIdentifier: CartPhotosTableViewCell.identifier)
            let cell = tableView.dequeueReusableCell(withIdentifier: CartPhotosTableViewCell.identifier, for: indexPath) as! CartPhotosTableViewCell
            cell.photosCollectionView.numberOfItemsInSection { (_) -> Int in
                return photos.count
            }.cellForItemAt { (indexPath) -> UICollectionViewCell in
                let nib = UINib(nibName: ImagesCollectionViewCell.identifier, bundle: nil)
                cell.photosCollectionView.register(nib, forCellWithReuseIdentifier: "ImagesCollectionViewCell")
                let cell = cell.photosCollectionView.dequeueReusableCell(withReuseIdentifier: ImagesCollectionViewCell.identifier, for: indexPath) as! ImagesCollectionViewCell
                cell.imageView.image = photos[indexPath.row]
                cell.removeImage.isHidden = true
                return cell
            }.sizeForItemAt { (_) -> CGSize in
                return CGSize(width: 100, height: 115)
            }.minimumLineSpacingForSectionAt { (_) -> CGFloat in
                return 0
            }.minimumInteritemSpacingForSectionAt { (_) -> CGFloat in
                return 0
            }
            
            cell.photosCollectionView.reloadData()
            return cell
            
        }else if let voiceData = items![indexPath.row].voice{
            
            let nib = UINib(nibName: CartVoiceTableViewCell.identifier, bundle: nil)
            productsTableView.register(nib, forCellReuseIdentifier: CartVoiceTableViewCell.identifier)
            let cell = tableView.dequeueReusableCell(withIdentifier: CartVoiceTableViewCell.identifier, for: indexPath) as! CartVoiceTableViewCell
            cell.loadFrom(data: voiceData)
            return cell
            
        }else if let text = items![indexPath.row].text{
            
            let nib = UINib(nibName: CartTextTableViewCell.identifier, bundle: nil)
            productsTableView.register(nib, forCellReuseIdentifier: CartTextTableViewCell.identifier)
            let cell = tableView.dequeueReusableCell(withIdentifier: CartTextTableViewCell.identifier, for: indexPath) as! CartTextTableViewCell
            cell.textOrder.text = text
            return cell
            
        }else{
            
            let nib = UINib(nibName: CartProductTableViewCell.identifier, bundle: nil)
            productsTableView.register(nib, forCellReuseIdentifier: CartProductTableViewCell.identifier)
            let cell = tableView.dequeueReusableCell(withIdentifier: CartProductTableViewCell.identifier, for: indexPath) as! CartProductTableViewCell
            cell.name.text = "lang".localized == "en" ? items![indexPath.row].name_en : items![indexPath.row].name_ar
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
                CartServices.shared.updateQuantity(newValue: newQty, id: self.items![indexPath.row].cart_id!, nil)
                productsTableView.reloadData()
            }
            cell.decreaseBtn.onTap { [self] in
                guard Int(cell.quantity.text!)! > 1 else{
                    return
                }
                var newQty: Int = Int(cell.quantity.text!)!
                newQty -= 1
                cell.quantity.text = "\(newQty)"
                CartServices.shared.updateQuantity(newValue: newQty, id: (self.items![indexPath.row].cart_id)!, nil)
                productsTableView.reloadData()
            }
            cell.price.text = "\(items![indexPath.row].price * Double(cell.quantity.text!)!) EGP"
            cell.productImage.kf.indicatorType = .activity
            cell.productImage.kf.setImage(with: URL(string: Shared.storageBase + (items![indexPath.row].logo ?? "")), placeholder: nil, options: [], completionHandler: nil)
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let _ = items![indexPath.row].photos{
            return 140
        }else if let _ = items![indexPath.row].voice{
            return 130
        }else{
            return UITableView.automaticDimension
        }
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
