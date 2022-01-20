//
//  CartPhotosTableViewCell.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 27/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class CartPhotosTableViewCell: UITableViewCell {

   static let identifier = "CartPhotosTableViewCell"
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var removeBtn: UIButton!
}
