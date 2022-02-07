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
    @IBOutlet weak var addToCart: UIButton!
    @IBOutlet weak var increaseBtn: UIButton!
    @IBOutlet weak var decreaseBtn: UIButton!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var inCartView: UIView!
    @IBOutlet weak var stockView: ViewCorners!
    @IBOutlet weak var closedView: ViewCorners!
    
    
    func loadFrom(_ product: Product){
        
        branchImage.isUserInteractionEnabled = true
        branchImage.addTapGesture { _ in
            Router.toBranch(UIApplication.getTopViewController()!, product.branch!)
        }
        
        productImage.layer.cornerRadius = productImage.frame.height/2
        branchImage.layer.cornerRadius = branchImage.frame.height/2
        
        productImage.kf.indicatorType = .activity
        productImage.kf.setImage(with: URL(string: Shared.storageBase + ((product.images?.first ?? product.branch?.logo) ?? "")))
        
        branchImage.kf.setImage(with: URL(string: Shared.storageBase + (product.branch?.logo ?? "")))
        name.text = "lang".localized == "en" ? product.name?.en : product.name?.ar
       // price.text = "\(product.price ?? 0.0) EGP"
       // price.isHidden = product.price == 0 ? true : false
//        if let vars = product.variations,
//           vars.isEmpty{
//            price.isHidden = true
//        }else{
//            price.isHidden = false
//        }
        
        stockView.isHidden = product.inStock == 1 ? true : false
       // addToCart.isHidden = product.inStock == 1 ? false : true
        
        closedView.isHidden = product.isOpen == 1 ? true : false
        
//        if product.inStock == 1{
//            stockView.isHidden = true
//            addToCart.isHidden = false
//        }else{
//            stockView.isHidden = false
//            addToCart.isHidden = true
//        }
    }
    
}
