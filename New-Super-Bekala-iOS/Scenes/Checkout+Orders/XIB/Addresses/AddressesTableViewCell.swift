//
//  AddressesTableViewCell.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 08/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class AddressesTableViewCell: UITableViewCell {

    static let identifier = "AddressesTableViewCell"
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var selectedImg: UIImageView!
    @IBOutlet weak var formattedAddress: UILabel!
    
    func loadFrom(_ address: Address){
        name.text = address.title
        formattedAddress.text = "\(address.city ?? "") \(address.dist ?? "") \(address.landmark ?? "") \(address.building ?? "") \(address.floor ?? "") \(address.flat ?? "") \(address.phone ?? "")"
    }
}
