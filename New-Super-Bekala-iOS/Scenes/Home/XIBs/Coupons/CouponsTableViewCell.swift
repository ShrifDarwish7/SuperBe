//
//  CouponsTableViewCell.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 27/12/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import Cosmos

class CouponsTableViewCell: UITableViewCell {
 
    static let identifier = "CouponsTableViewCell"
    static let nib = { return UINib(nibName: CouponsTableViewCell.identifier, bundle: nil) }
    
    @IBOutlet weak var vendorImage: UIImageView!
    @IBOutlet weak var branchName: UILabel!
    @IBOutlet weak var branchRate: CosmosView!
    @IBOutlet weak var couponCode: UILabel!
    @IBOutlet weak var couponDisc: UILabel!
    @IBOutlet weak var copyBtn: UIButton!
    
    func loadFrom(_ data: Branch){
        vendorImage.kf.setImage(with: URL(string: Shared.storageBase + data.logo!))
        branchName.text = "lang".localized == "en" ? data.name?.en : data.name?.ar
        branchRate.rating = Double(data.rating ?? "0.0")!
        couponCode.text = data.coupons?.first?.code
        couponDisc.text = "lang".localized == "en" ? data.coupons?.first?.couponResponseDescription?.en : data.coupons?.first?.couponResponseDescription?.ar
    }
    
}
