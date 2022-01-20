//
//  ImagesCollectionViewCell.swift
//  Super-Bekala-Lite
//
//  Created by Super Bekala on 6/28/20.
//  Copyright © 2020 Super Bekala. All rights reserved.
//

import UIKit

class ImagesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ImagesCollectionViewCell"

    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var removeImage: UIButton!
    
}
