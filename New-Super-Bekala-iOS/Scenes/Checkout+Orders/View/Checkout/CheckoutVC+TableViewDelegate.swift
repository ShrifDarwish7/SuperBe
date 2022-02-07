//
//  CheckoutVC+TableViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 08/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit

extension CheckoutVC: UITableViewDelegate, UITableViewDataSource{
    func loadAddressesTable(){
       // let nib = UINib(nibName: AddressesTableViewCell.identifier, bundle: nil)
        addressesTableView.register(ProfileAddressesTableViewCell.nib(), forCellReuseIdentifier: ProfileAddressesTableViewCell.identifier)
        addressesTableView.delegate = self
        addressesTableView.dataSource = self
        addressesTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case lineItemsTableView:
            return cartItems!.filter({ return !$0.is_media }).count
        case addressesTableView:
            return addresses!.count > 0 ? 1 : 0
        default:  return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        
        case lineItemsTableView:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: LinesSummaryTableViewCell.identifier, for: indexPath) as! LinesSummaryTableViewCell
            let item = cartItems!.filter({ return !$0.is_media })[indexPath.row]
            cell.quantity.text = "\(item.quantity) X"
            cell.name.text = "lang".localized == "en" ? item.name_en : item.name_ar
            let variations = item.variations?.getDecodedObject(from: [Variation].self)
            cell.variations.isHidden = variations!.isEmpty ? true : false
            cell.price.text = "\(item.price * Double(item.quantity)) " + "EGP".localized
            cell.variations.text = item.desc

            return cell
            
        case addressesTableView:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileAddressesTableViewCell.identifier, for: indexPath) as! ProfileAddressesTableViewCell
            cell.loadFrom(self.addresses![indexPath.row])
            
            cell.selectBtn.onTap {
                guard self.addresses![indexPath.row].selected == 0 else { return }
                self.acitvityIndicator.startAnimating()
                self.presenter?.updateAddress(self.addresses![indexPath.row].id, ["selected": "1"])
            }
            
            cell.deleteBtn.onTap {
                let alert = UIAlertController(title: nil, message: "Are you sure you want to delete this address ?".localized, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Delete".localized, style: .destructive, handler: { _ in
                    self.acitvityIndicator.startAnimating()
                    self.presenter?.deleteAddress(self.addresses![indexPath.row].id)
                }))
                alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            cell.editBtn.onTap {
                Router.toEditAddreess(self, self.addresses![indexPath.row])
            }
            
            if self.addresses![indexPath.row].selected == 1{
                cell.selectBtn.tintColor = .systemGreen
                cell.selectBtn.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            }else{
                cell.selectBtn.tintColor = .black
                cell.selectBtn.setImage(UIImage(systemName: "circle"), for: .normal)
            }
            
            return cell
            
        default: return UITableViewCell()
            
        }       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.view.layoutIfNeeded()
        self.viewWillLayoutSubviews()
    }
}

