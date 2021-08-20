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
        let nib = UINib(nibName: AddressesTableViewCell.identifier, bundle: nil)
        addressesTableView.register(nib, forCellReuseIdentifier: AddressesTableViewCell.identifier)
        addressesTableView.delegate = self
        addressesTableView.dataSource = self
        addressesTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addresses!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddressesTableViewCell.identifier, for: indexPath) as! AddressesTableViewCell
        cell.loadFrom(self.addresses![indexPath.row])
        
        if self.addresses![indexPath.row].selected == 1{
            cell.selectedImg.isHidden = false
            cell.name.alpha = 1
            cell.formattedAddress.alpha = 1
        }else{
            cell.selectedImg.isHidden = true
            cell.name.alpha = 0.3
            cell.formattedAddress.alpha = 0.3
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presenter?.updateAddress(self.addresses![indexPath.row].id, ["selected": "1"])
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextualAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            self.acitvityIndicator.startAnimating()
            self.presenter?.deleteAddress(self.addresses![indexPath.row].id)
        }
        return UISwipeActionsConfiguration(actions: [contextualAction])
    }
}

