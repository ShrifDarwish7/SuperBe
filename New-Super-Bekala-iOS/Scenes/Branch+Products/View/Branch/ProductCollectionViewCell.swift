//
//  ProductCollectionViewCell.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 31/03/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

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
    
    func loadFrom(data: Product){
        name.text = "\(data.id!)"
        price.text = "\(data.price ?? 0) EGP"
        productImage.sd_setImage(with: URL(string: Shared.storageBase + (data.images?.first ?? "") ))
    }
    

}
