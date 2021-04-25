//
//  LastOrdersTableViewCell.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 21/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class LastOrdersTableViewCell: UITableViewCell {

    static let identifier = "LastOrdersTableViewCell"
     
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var branchName: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var statusContainer: ViewCorners!
    
    func loadFrom(_ order: LastOrder){
        logo.sd_setImage(with: URL(string: Shared.storageBase + (order.branch?.logo)!))
        branchName.text = "lang".localized == "en" ? order.branch?.nameEn : order.branch?.nameAr
        orderDate.text = order.createdAt
        status.text = order.status
    }
}
