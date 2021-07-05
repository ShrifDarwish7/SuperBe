//
//  OrdinaryVendorTableViewCell.swift
//  New-Super-Bekala-iOS
//
//  Created by Super Bekala on 7/12/20.
//  Copyright © 2020 Super Bekala. All rights reserved.
//

import UIKit
import Cosmos

class OrdinaryVendorTableViewCell: UITableViewCell {
    
    static let identifier = "OrdinaryVendorTableViewCell"

    @IBOutlet weak var vendorPhoto: UIImageView!
    @IBOutlet weak var open_close: UIImageView!
    @IBOutlet weak var vendorName: UILabel!
    @IBOutlet weak var vendorRate: CosmosView!
    @IBOutlet weak var deliveryTime: UILabel!
    @IBOutlet weak var minimumOrder: UILabel!
    @IBOutlet weak var deliveryFees: UILabel!
    @IBOutlet weak var favouriteBtn: UIButton!
    
    func loadUI(){
        vendorPhoto.layer.cornerRadius = vendorPhoto.frame.height/2
        vendorPhoto.layer.borderWidth = 2.5
        vendorPhoto.layer.borderColor = UIColor.Green.cgColor
    }
    
    func loadFrom(data: Branch){
        loadUI()
        vendorPhoto.sd_setImage(with: URL(string: Shared.storageBase + data.logo!)!)
        vendorName.text = "lang".localized == "en" ? data.name?.en : data.name?.ar
//        vendorRate.rating = data.rating ?? 0.0
        deliveryTime.text = "\(data.deliveryDuration ?? 0) MIN"
        deliveryTime.text = "\(data.minOrder ?? 0) EGP"
        deliveryFees.text = "\(data.deliveryFees ?? 0) EGP"
        open_close.image = data.isOpen == 0 ? UIImage(named: "close_icon") : UIImage(named: "open_icon")
    }
    
}
