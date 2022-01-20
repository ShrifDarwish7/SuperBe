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
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var rateBtn: UIButton!
    @IBOutlet weak var rateView: UIView!
    
    func loadFrom(_ order: LastOrder){
        
        logo.kf.indicatorType = .activity
        logo.kf.setImage(with: URL(string: Shared.storageBase + (order.branch?.logo ?? "")), placeholder: nil, options: [], completionHandler: nil)
        branchName.text = order.branch?.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let orderDate = dateFormatter.date(from: order.createdAt!)
        dateFormatter.dateFormat = "MMM d, h:mm a"
        self.orderDate.text = dateFormatter.string(from: orderDate!)
        status.text = order.status?.rawValue.localized
        orderId.text = "#\(order.id!)"
        rateView.alpha = order.status == .completed ? 1.0 : 0.3
        
        if order.branch == nil{
            branchImgView.isHidden = true
            self.orderDate.isHidden = true
            branchName.text = dateFormatter.string(from: orderDate!)
        }else{
            branchImgView.isHidden = false
            self.orderDate.isHidden = false
        }
        
        switch order.status {
        case .processing: statusContainer.backgroundColor = #colorLiteral(red: 0.4048153162, green: 0.7739678025, blue: 0.9675973058, alpha: 1)
        case .pending: statusContainer.backgroundColor = #colorLiteral(red: 0.9526476264, green: 0.6694008708, blue: 0.4233491421, alpha: 1)
        case .outForDelivery: statusContainer.backgroundColor = #colorLiteral(red: 0.9589375854, green: 0.4156478643, blue: 0.7633641362, alpha: 1)
        case .completed: statusContainer.backgroundColor = #colorLiteral(red: 0.5046545863, green: 0.8244745135, blue: 0.2936052084, alpha: 1)
        case .cancelled,.failed: statusContainer.backgroundColor = .systemRed
        default: break
        }
        
    }
    
}
