//
//  ImagedCategoryCollectionViewCell.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 19/10/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class ImagedCategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ImagedCategoryCollectionViewCell"
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var cont: UIView!
    
    func loadFrom(_ data: Category){
        logo.kf.setImage(with: URL(string: Shared.storageBase + (("lang".localized == "en" ? data.logo?.en : data.logo?.ar) ?? "")))
        name.text = "lang".localized == "en" ? data.name?.en : data.name?.ar
        cont.layer.shadowOpacity = 0.3
        cont.layer.shadowRadius = 5
        cont.layer.shadowOffset = CGSize.zero
        cont.layer.shadowColor = UIColor.gray.cgColor
        cont.layer.masksToBounds = false
        cont.layer.cornerRadius = 10
    }
    
}
