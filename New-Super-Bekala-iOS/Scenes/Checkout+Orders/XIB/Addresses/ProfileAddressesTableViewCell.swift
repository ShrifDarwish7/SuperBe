//
//  ProfileAddressesTableViewCell.swift
//  New-Super-Bekala-iOS
//
//  Created by Super Be on 29/12/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class ProfileAddressesTableViewCell: UITableViewCell {

    static let identifier = "ProfileAddressesTableViewCell"
    static let nib = { return UINib(nibName: ProfileAddressesTableViewCell.identifier, bundle: nil)}
    
    @IBOutlet weak var addressTitle: UILabel!
    @IBOutlet weak var addressStr: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    
    func loadFrom(_ data: Address){
        addressTitle.text = data.title?.localized
        addressStr.text = "\(data.city ?? "") \(data.dist ?? "") \(data.landmark ?? "") \(data.building ?? "") \(data.floor ?? "") \(data.flat ?? "")"
        phone.text = "\(data.phone ?? "")"
    }
    
}
