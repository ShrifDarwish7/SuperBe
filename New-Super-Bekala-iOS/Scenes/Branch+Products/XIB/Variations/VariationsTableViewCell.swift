//
//  VariationsTableViewCell.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 13/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class VariationsTableViewCell: UITableViewCell {

    static let identifier = "VariationsTableViewCell"
    
    @IBOutlet weak var variationName: UILabel!
    @IBOutlet weak var chosedVariation: UILabel!
    @IBOutlet weak var optionsTableView: UITableView!
    @IBOutlet weak var optionsTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var optionsContainer: ViewCorners!
    @IBOutlet weak var expandBtn: UIButton!
    @IBOutlet weak var min_max: UILabel!
    
}
