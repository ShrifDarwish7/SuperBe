//
//  TextMessageTableViewCell.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 01/08/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class TextMessageTableViewCell: UITableViewCell {

    static let identifier = "TextMessageTableViewCell"

    @IBOutlet weak var bubbleImage: UIImageView!
    @IBOutlet weak var bubbleView: UIView!
    
    
    func loadFrom(message: Message){
        if message.senderID == APIServices.shared.user?.id{
            
        }else{
            
        }
    }
}
