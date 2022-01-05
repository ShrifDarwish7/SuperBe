//
//  OnSaleCollectionViewCell.swift
//  New-Super-Bekala-iOS
//
//  Created by Super Bekala on 8/10/20.
//  Copyright © 2020 Super Bekala. All rights reserved.
//

import UIKit

class OnSaleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "OnSaleCollectionViewCell"

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var increaseBtn: UIButton!
    @IBOutlet weak var decreaseBtn: UIButton!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var inCartView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var currentPrice: UILabel!
    @IBOutlet weak var previousPrice: UILabel!
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var discountIcon: UIImageView!
    @IBOutlet weak var discountLbl: UILabel!
    
    func loadUI(data: Product){
        self.containerView.layer.cornerRadius = 25
        self.productImage.roundCorners([.layerMinXMinYCorner,.layerMaxXMinYCorner], radius: 25)
        self.shadowView.roundCorners([.layerMinXMaxYCorner,.layerMaxXMaxYCorner], radius: 25)
        name.text = "lang".localized == "en" ? data.name?.en : data.name?.ar
       // previousPrice.text = "\(data.price ?? 0) EGP"
        currentPrice.text = "\(data.salePrice ?? 0) EGP"
        previousPrice.text = data.price == 0 ? "Price on selection".localized : ("\(data.price ?? 0) " + "EGP".localized)
        productImage.kf.indicatorType = .activity
        productImage.kf.setImage(with: URL(string: Shared.storageBase + (data.images?.first ?? "") ), placeholder: nil, options: [], completionHandler: nil)
        
        
        if data.salePrice == nil || data.salePrice == 0{
            currentPrice.isHidden = true
            lineView.isHidden = true
            discountLbl.isHidden = true
            discountIcon.isHidden = true
        }else{
            discountLbl.isHidden = false
            discountIcon.isHidden = false
            let discount = (Double(data.price!) - Double(data.salePrice!)) * 100.0 / Double(data.price!)
            discountLbl.text = "\(discount.roundToDecimal(1))% " + "OFF".localized
        }
        
        if data.price == nil || data.price == 0{
            currentPrice.isHidden = true
        }
        
    }
    
}
