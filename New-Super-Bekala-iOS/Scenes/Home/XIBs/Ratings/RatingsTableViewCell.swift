//
//  RatingsTableViewCell.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 25/07/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import Cosmos

class RatingsTableViewCell: UITableViewCell {

    static let identifier = "RatingsTableViewCell"
    
    @IBOutlet weak var userImage: CircluarImage!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var timeAgo: UILabel!
    @IBOutlet weak var rate: CosmosView!
    @IBOutlet weak var comment: UILabel!
    
    
    func initFrom(data: Rating){
        userImage.kf.setImage(with: URL(string: Shared.storageBase + (data.user?.avatar)!))
        username.text = data.user?.name
        timeAgo.text = data.createdAt
        rate.rating = Double(data.rate!)!
        comment.text = data.comment
    }
}
