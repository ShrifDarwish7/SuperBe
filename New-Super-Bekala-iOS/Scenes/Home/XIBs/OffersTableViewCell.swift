//
//  OffersTableViewCell.swift
//  New-Super-Bekala-iOS
//
//  Created by Super Bekala on 8/10/20.
//  Copyright © 2020 Super Bekala. All rights reserved.
//

import UIKit

class OffersTableViewCell: UITableViewCell {

    @IBOutlet weak var onsaleCollectionView: UICollectionView!
    @IBOutlet weak var vendorImage: UIImageView!
    
    func loadUI(){
        vendorImage.layer.cornerRadius = vendorImage.frame.height/2
    }
}
