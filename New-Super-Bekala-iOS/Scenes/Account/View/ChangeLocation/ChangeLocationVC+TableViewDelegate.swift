//
//  ChangeLocationVC+TableViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 27/06/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit

extension ChangeLocationVC: UITableViewDelegate, UITableViewDataSource{
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
        cell.name.text = self.addresses![indexPath.row].title
        
        if self.addresses![indexPath.row].selected == 1{
            cell.selectedImg.isHidden = false
            cell.name.alpha = 1
        }else{
            cell.selectedImg.isHidden = true
            cell.name.alpha = 0.3
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Shared.userSelectLocation = true
        Shared.isCoords = true
        Shared.isRegion = false
        Shared.selectedCoords = self.addresses![indexPath.row].coordinates!
        Shared.deliveringToTitle = self.addresses![indexPath.row].title
        self.presenter?.updateAddress(self.addresses![indexPath.row].id, ["selected": "1"])
    }
}
