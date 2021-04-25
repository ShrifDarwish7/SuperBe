//
//  CartProductTableViewCell.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 03/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class CartProductTableViewCell: UITableViewCell {

    static let identifier = "CartProductTableViewCell"
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var increaseBtn: UIButton!
    @IBOutlet weak var decreaseBtn: UIButton!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var desc: UILabel!
    
}
