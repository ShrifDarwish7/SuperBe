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
    
    func loadFrom(data: Branch){
        vendorPhoto.layer.cornerRadius = vendorPhoto.frame.height/2
        vendorPhoto.layer.borderWidth = 2.5
        
        if data.isOpen == 0{
            vendorPhoto.layer.borderColor = UIColor(named: "busyColor")?.cgColor
            open_close.image = "lang".localized == "en" ? UIImage(named: "closed_en") : UIImage(named: "closed_ar")
        }else{
            vendorPhoto.layer.borderColor = UIColor(named: "openColor")?.cgColor
            open_close.image = "lang".localized == "en" ? UIImage(named: "open_en") : UIImage(named: "open_ar")
        }
        
        if data.isOnhold == 1{
            vendorPhoto.layer.borderColor = UIColor(named: "onholdColor")?.cgColor
            open_close.image = "lang".localized == "en" ? UIImage(named: "onhold_en") : UIImage(named: "onhold_ar")
        }
        
        if data.isBusy == 1{
            vendorPhoto.layer.borderColor = UIColor(named: "busyColor")?.cgColor
            open_close.image = "lang".localized == "en" ? UIImage(named: "busy_en") : UIImage(named: "busy_ar")
        }
        
        vendorPhoto.kf.indicatorType = .activity
        vendorPhoto.kf.setImage(with:URL(string: Shared.storageBase + (data.logo ?? ""))!, placeholder: nil, options: [], completionHandler: nil)
        vendorName.text = "lang".localized == "en" ? data.name?.en : data.name?.ar
//        vendorRate.rating = data.rating ?? 0.0
        deliveryTime.text = "\(data.deliveryDuration ?? 0) MIN"
        deliveryTime.text = "\(data.minOrder ?? 0) EGP"
        deliveryFees.text = "\(data.deliveryFees ?? 0) EGP"
    
        if let _ = data.isFavourite,
           data.isFavourite == 1{
            favouriteBtn.setImage(UIImage(named: "heart-2"), for: .normal)
        }else{
            favouriteBtn.setImage(UIImage(named: "heart"), for: .normal)
        }
    }
    
}
