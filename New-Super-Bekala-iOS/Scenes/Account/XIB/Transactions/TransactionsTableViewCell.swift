//
//  TransactionsTableViewCell.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 22/05/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class TransactionsTableViewCell: UITableViewCell {
    
    static let identifier = "TransactionsTableViewCell"

    @IBOutlet weak var containerView: ViewCorners!
    @IBOutlet weak var statusIcon: UIImageView!
    @IBOutlet weak var points: UILabel!
    
    
}
