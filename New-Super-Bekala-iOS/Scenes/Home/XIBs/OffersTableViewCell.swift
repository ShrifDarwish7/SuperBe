//
//  OffersTableViewCell.swift
//  New-Super-Bekala-iOS
//
//  Created by Super Bekala on 8/10/20.
//  Copyright © 2020 Super Bekala. All rights reserved.
//

import UIKit
import Cosmos

class OffersTableViewCell: UITableViewCell {
    
    static let identifier = "OffersTableViewCell"

    @IBOutlet weak var onsaleCollectionView: UICollectionView!
    @IBOutlet weak var vendorImage: UIImageView!
    @IBOutlet weak var branchName: UILabel!
    @IBOutlet weak var branchRate: CosmosView!
    @IBOutlet weak var showMore: UIButton!
    
    
}
