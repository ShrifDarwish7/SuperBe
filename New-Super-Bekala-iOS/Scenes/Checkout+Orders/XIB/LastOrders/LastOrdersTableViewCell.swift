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
    @IBOutlet weak var branchImgView: ViewCorners!
    
    func loadFrom(_ order: LastOrder){
        
        logo.kf.indicatorType = .activity
        logo.kf.setImage(with: URL(string: Shared.storageBase + (order.branch?.logo ?? "")), placeholder: nil, options: [], completionHandler: nil)
        branchName.text = order.branch?.name
        orderDate.text = order.createdAt
        status.text = order.status
        
        if order.branch == nil{
            branchImgView.isHidden = true
            orderDate.isHidden = true
            branchName.text = order.createdAt
        }else{
            branchImgView.isHidden = false
            orderDate.isHidden = false
        }
    }
    
}
