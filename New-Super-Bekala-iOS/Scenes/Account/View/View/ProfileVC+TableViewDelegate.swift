//
//  ProfileVC+TableViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 18/05/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit

extension ProfileVC: UITableViewDelegate, UITableViewDataSource{
    func loadAddressesTable(){
        //let nib = UINib(nibName: AddressesTableViewCell.identifier, bundle: nil)
        addressesTableView.register(ProfileAddressesTableViewCell.nib(), forCellReuseIdentifier: ProfileAddressesTableViewCell.identifier)
        addressesTableView.delegate = self
        addressesTableView.dataSource = self
        addressesTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses!.count > 0 ? 1 : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileAddressesTableViewCell.identifier, for: indexPath) as! ProfileAddressesTableViewCell
        cell.loadFrom(self.addresses![indexPath.row])
        
        cell.selectBtn.onTap {
            guard self.addresses![indexPath.row].selected == 0 else { return }
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
        
        viewWillLayoutSubviews()
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        view.layoutIfNeeded()
        viewWillLayoutSubviews()
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.presenter?.updateAddress(self.addresses![indexPath.row].id, ["selected": "1"])
//    }
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction = UIContextualAction(style: .destructive, title: "Delete".localized) { (_, _, _) in
//            self.acitvityIndicator.startAnimating()
//            self.presenter?.deleteAddress(self.addresses![indexPath.row].id)
//        }
//        let editAction = UIContextualAction(style: .normal, title: "Edit".localized) { (_, _, _) in
//            Router.toEditAddreess(self, self.addresses![indexPath.row])
//        }
//        editAction.backgroundColor = .cyan
//        return UISwipeActionsConfiguration(actions: [editAction,deleteAction])
//    }
}
