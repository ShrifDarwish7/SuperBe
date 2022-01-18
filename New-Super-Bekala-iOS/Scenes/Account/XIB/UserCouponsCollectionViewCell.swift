//
//  UserCouponsCollectionViewCell.swift
//  New-Super-Bekala-iOS
//
//  Created by Super Be on 06/01/2022.
//  Copyright © 2022 Super Bekala. All rights reserved.
//

import UIKit

class UserCouponsCollectionViewCell: UICollectionViewCell {

    static let identifer = "UserCouponsCollectionViewCell"
    
    @IBOutlet weak var containerView: ViewCorners!
    @IBOutlet weak var name: UILabel!
    
    func loadfrom(status: CouponStatus){
        name.text = status.name
        if status.selected{
            containerView.borderColor = .red
            name.textColor = .red
        }else{
            containerView.borderColor = .lightGray
            name.textColor = .lightGray
        }
    }

}

struct CouponStatus{
    var name: String
    var selected: Bool
}
