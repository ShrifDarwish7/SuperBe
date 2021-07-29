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
    
    func loadFrom(data: Product){
        name.text = "lang".localized == "en" ? data.name?.en : data.name?.ar
        price.text = data.price == 0 ? "Price on selection" : "\(data.price ?? 0) EGP"
        productImage.roundCorners([.layerMinXMinYCorner,.layerMaxXMinYCorner], radius: 25)
        productImage.kf.indicatorType = .activity
        productImage.kf.setImage(with: URL(string: Shared.storageBase + (data.images?.first ?? "") ), placeholder: nil, options: [], completionHandler: nil)
        
        if let salePrice = data.salePrice,
           salePrice > 0{
            self.salePriceView.isHidden = false
            self.salePrice.text = "\(data.price ?? 0.0) EGP"
            self.price.text = "\(data.salePrice ?? 0.0) EGP"
        }else{
            self.salePriceView.isHidden = true
        }
        
        outOfStockView.isHidden = data.inStock == 1 ? true : false
        addToCartBtn.isHidden = data.inStock == 1 ? false : true
    }
    

}
