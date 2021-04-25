//
//  FeaturedCollectionViewCell.swift
//  New-Super-Bekala-iOS
//
//  Created by Super Bekala on 7/12/20.
//  Copyright © 2020 Super Bekala. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage

class FeaturedCollectionViewCell: UICollectionViewCell {

    static let identifier = "FeaturedCollectionViewCell"
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var vendorPhoto: UIImageView!
    @IBOutlet weak var vendorName: UILabel!
    @IBOutlet weak var vendorRate: CosmosView!
    @IBOutlet weak var deliveryTime: UILabel!
    @IBOutlet weak var minimumOrder: UILabel!
    @IBOutlet weak var deliveryFees: UILabel!
    
    func loadUI(){
        
        container.layer.cornerRadius = 30
        container.setupShadow()
        vendorPhoto.roundCorners([.layerMinXMinYCorner,.layerMaxXMinYCorner], radius: 30)
        
    }
    
    func loadFrom(data: Branch){
        loadUI()
        vendorPhoto.sd_setImage(with: URL(string: Shared.storageBase + data.logo! ))
        vendorName.text = "lang".localized == "en" ? data.branchLanguage?.first?.name : data.branchLanguage?[1].name
        vendorRate.rating = data.rating ?? 0.0
        deliveryTime.text = "\(data.deliveryDuration ?? 0) MIN"
        deliveryTime.text = "\(data.minOrder ?? 0) EGP"
        deliveryFees.text = "\(data.deliveryFees ?? 0) EGP"
    }

}
