//
//  CategoriesTableViewCell.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 15/02/2022.
//  Copyright © 2022 Super Bekala. All rights reserved.
//

import UIKit

class CategoriesTableViewCell: UITableViewCell {

    static let identifier = "CategoriesTableViewCell"
    static let nib = { return UINib(nibName: CategoriesTableViewCell.identifier, bundle: nil) }
    
    @IBOutlet weak var catName: UILabel!
    @IBOutlet weak var branchesCollectionView: UICollectionView!
    
    
    
}
