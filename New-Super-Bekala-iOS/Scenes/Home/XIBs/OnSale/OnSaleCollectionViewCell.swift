//
//  OnSaleCollectionViewCell.swift
//  New-Super-Bekala-iOS
//
//  Created by Super Bekala on 8/10/20.
//  Copyright © 2020 Super Bekala. All rights reserved.
//

import UIKit

class OnSaleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    func loadUI(){
        self.containerView.layer.cornerRadius = 25
        self.productImage.layer.cornerRadius = 25
        self.shadowView.roundCorners([.layerMinXMaxYCorner,.layerMaxXMaxYCorner], radius: 25)
    }
    
}
