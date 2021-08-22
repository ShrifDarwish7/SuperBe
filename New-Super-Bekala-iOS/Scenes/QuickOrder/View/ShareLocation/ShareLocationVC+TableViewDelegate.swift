//
//  ShareLocationVC+TableViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 30/06/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

extension ShareLocationVC: UITableViewDelegate, UITableViewDataSource{
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
        cell.name.alpha = 1
        cell.selectedImg.isHidden = true
        cell.loadFrom(self.addresses![indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let coords = self.addresses![indexPath.row].coordinates
        let landmark = self.addresses![indexPath.row].landmark!.replacingOccurrences(of: ",", with: " ") + " , " +  self.addresses![indexPath.row].street!.replacingOccurrences(of: ",", with: " ") + " , " + self.addresses![indexPath.row].building!.replacingOccurrences(of: ",", with: " ") + " , " + self.addresses![indexPath.row].floor!.replacingOccurrences(of: ",", with: " ") + " , " + self.addresses![indexPath.row].flat!.replacingOccurrences(of: ",", with: " ")
        
        switch locationState {
        case .pickup:
            pickupTF.text = self.addresses![indexPath.row].title
            pickupLocation = coords
            pickupLandmark = landmark
            selectedPickupAddressId = self.addresses![indexPath.row].id
        case .dropOff:
            dropOffTF.text = self.addresses![indexPath.row].title
            dropOffLocation = coords
            dropOffLandmark = landmark
            selectedDropoffAddressId = self.addresses![indexPath.row].id
        default:
            break
        }
        
        self.dismissAdddressesAlert()
    }
}

