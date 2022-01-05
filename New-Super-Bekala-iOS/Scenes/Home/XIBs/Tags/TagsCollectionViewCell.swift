//
//  TagsCollectionViewCell.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 28/10/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class TagsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TagsCollectionViewCell"
    static let nib = {
        return UINib(nibName: TagsCollectionViewCell.identifier, bundle: nil)
    }

    @IBOutlet weak var tagImage: UIImageView!
    @IBOutlet weak var tagName: UILabel!
    @IBOutlet weak var selectView: ViewCorners!
    
    func loadFrom(_ data: Tag){
        selectView.isHidden = data.selected ? false : true
        tagImage.kf.setImage(with: URL(string: Shared.storageBase + (data.logo ?? "" )))
        tagName.text = "lang".localized == "en" ? data.name?.en : data.name?.ar
    }
    
}
