//
//  FeaturedCollectionViewCell.swift
//  New-Super-Bekala-iOS
//
//  Created by Super Bekala on 7/12/20.
//  Copyright © 2020 Super Bekala. All rights reserved.
//

import UIKit
import Cosmos

class FeaturedCollectionViewCell: UICollectionViewCell {

    static let identifier = "FeaturedCollectionViewCell"
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var vendorPhoto: UIImageView!
    @IBOutlet weak var vendorName: UILabel!
    @IBOutlet weak var vendorRate: CosmosView!
    @IBOutlet weak var deliveryTime: UILabel!
    @IBOutlet weak var minimumOrder: UILabel!
    @IBOutlet weak var deliveryFees: UILabel!
    @IBOutlet weak var favouriteBtn: UIButton!
    
    func loadUI(){
        
        container.layer.cornerRadius = 30
        container.setupShadow()
        vendorPhoto.roundCorners([.layerMinXMinYCorner,.layerMaxXMinYCorner], radius: 30)
        
    }
    
    func loadFrom(data: Branch){
        loadUI()
        vendorPhoto.kf.indicatorType = .activity
        vendorPhoto.kf.setImage(with: URL(string: Shared.storageBase + data.logo! ), placeholder: nil, options: [], completionHandler: nil)
        vendorName.text = "lang".localized == "en" ? data.name?.en : data.name?.ar
//        vendorRate.rating = data.rating ?? 0.0
        deliveryTime.text = "\(data.deliveryDuration ?? 0) MIN"
        minimumOrder.text = "\(data.minOrder ?? 0) EGP"
        deliveryFees.text = "\(data.deliveryFees ?? 0) EGP"
        if let _ = data.isFavourite,
           data.isFavourite == 1{
            favouriteBtn.setImage(UIImage(named: "favourite"), for: .normal)
        }else{
            favouriteBtn.setImage(UIImage(named: "unfavourite"), for: .normal)
        }
    }

}
