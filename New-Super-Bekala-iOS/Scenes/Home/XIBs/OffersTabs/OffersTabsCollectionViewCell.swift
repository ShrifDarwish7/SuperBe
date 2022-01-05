//
//  OffersTabsCollectionViewCell.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 26/12/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class OffersTabsCollectionViewCell: UICollectionViewCell {

    static let identifier = "OffersTabsCollectionViewCell"
    static let nib = { return UINib(nibName: OffersTabsCollectionViewCell.identifier, bundle: nil) }

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
}
