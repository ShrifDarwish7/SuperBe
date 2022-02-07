//
//  ProductCollectionViewCell.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 31/03/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import Kingfisher

class ProductCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ProductCollectionViewCell"

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var inCartView: UIView!
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var increaseBtn: UIButton!
    @IBOutlet weak var decreaseBtn: UIButton!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var salePrice: UILabel!
    @IBOutlet weak var salePriceView: UIView!
    @IBOutlet weak var outOfStockView: UIView!
    @IBOutlet weak var closedView: ViewCorners!
    @IBOutlet weak var discountIcon: UIImageView!
    @IBOutlet weak var discountLbl: UILabel!
    
    func loadFrom(data: Product){
        name.text = "lang".localized == "en" ? data.name?.en : data.name?.ar
        price.text = data.price == 0 ? "Price on selection".localized : ("\(data.price ?? 0) " + "EGP".localized)
        productImage.roundCorners([.layerMinXMinYCorner,.layerMaxXMinYCorner], radius: 25)
        productImage.kf.indicatorType = .activity
        productImage.kf.setImage(with: URL(string: Shared.storageBase + (data.logo ?? "") ), placeholder: nil, options: [], completionHandler: nil)
        
        if let salePrice = data.salePrice,
           salePrice > 0{
            self.salePriceView.isHidden = false
            self.salePrice.text = "\(data.price ?? 0.0) EGP"
            self.price.text = "\(data.salePrice ?? 0.0) EGP"
        }else{
            self.salePriceView.isHidden = true
        }
        
        outOfStockView.isHidden = data.inStock == 1 ? true : false
       // addToCartBtn.isHidden = data.inStock == 1 ? false : true
        
        closedView.isHidden = data.isOpen == 1 ? true : false
       // addToCartBtn.isHidden = data.isOpen == 0 ? false : true
        
        if data.salePrice == nil || data.salePrice == 0{
          //  currentPrice.isHidden = true
          //  lineView.isHidden = true
            discountLbl.isHidden = true
            discountIcon.isHidden = true
        }else{
            discountLbl.isHidden = false
            discountIcon.isHidden = false
            let discount = (Double(data.price!) - Double(data.salePrice!)) * 100.0 / Double(data.price!)
            discountLbl.text = "\(discount.roundToDecimal(1))% " + "OFF".localized
        }
        
    }
    

}
