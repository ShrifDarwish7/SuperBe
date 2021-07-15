//
//  ProductSearchResultTableViewCell.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 09/05/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import Cosmos

class ProductSearchResultTableViewCell: UITableViewCell {

    static let identifier = "ProductSearchResultTableViewCell"
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var branchImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rate: CosmosView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var addToCart: UIButton!
    @IBOutlet weak var increaseBtn: UIButton!
    @IBOutlet weak var decreaseBtn: UIButton!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var inCartView: UIView!
    
    
    func loadFrom(_ product: Product){
        productImage.layer.cornerRadius = productImage.frame.height/2
        branchImage.layer.cornerRadius = branchImage.frame.height/2
        
        productImage.kf.indicatorType = .activity
        productImage.kf.setImage(with: URL(string: Shared.storageBase + ((product.images?.first ?? product.branch?.logo) ?? "")))
        
        branchImage.kf.setImage(with: URL(string: Shared.storageBase + (product.branch?.logo ?? "")))
        name.text = "lang".localized == "en" ? product.name?.en : product.name?.ar
        price.text = "\(product.price ?? 0.0) EGP"
        if let vars = product.variations,
           vars.isEmpty{
            price.isHidden = true
        }else{
            price.isHidden = false
        }
    }
    
}
