//
//  SentTextMessageCell.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 05/08/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class SentTextMessageCell: UITableViewCell {

    static let identifier = "SentTextMessageCell"

    @IBOutlet weak var userImage: CircluarImage!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var messageStatusImage: UIImageView!
}
