//
//  OptionsTableViewCell.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 13/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class OptionsTableViewCell: UITableViewCell {

    static let identifier = "OptionsTableViewCell"
    
    @IBOutlet weak var radionImg: UIImageView!
    @IBOutlet weak var optionName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var salePriceView: UIView!
    @IBOutlet weak var salePrice: UILabel!
    @IBOutlet weak var priceStack: UIStackView!
}
