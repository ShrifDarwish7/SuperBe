//
//  ChatVC+TableViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 12/08/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit

extension ChatVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let messageDate = dateFormatter.date(from: self.messages[indexPath.row].createdAt!)
        dateFormatter.dateFormat = "h:mm a"//"MMM d, h:mm a"
        
        if self.messages[indexPath.row].senderID == APIServices.shared.user?.id{
            let cell = tableView.dequeueReusableCell(withIdentifier: SentTextMessageCell.identifier, for: indexPath) as! SentTextMessageCell
            cell.message.text = self.messages[indexPath.row].body
            cell.timeStamp.text = dateFormatter.string(from: messageDate!)
            cell.userImage.kf.setImage(with: URL(string: Shared.storageBase + (userOne?.avatar ?? "")))
            cell.messageStatusImage.isHidden = false
            if self.messages[indexPath.row].delivered {
                cell.messageStatusImage.image = UIImage(named: "message_sent")
            }else{
                cell.messageStatusImage.image = UIImage(named: "message_loading")
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: ReceivedTextMessageCell.identifier, for: indexPath) as! ReceivedTextMessageCell
            cell.message.text = self.messages[indexPath.row].body
            cell.timeStamp.text = dateFormatter.string(from: messageDate!)
            cell.userImage.kf.setImage(with: URL(string: Shared.storageBase + (userTwo?.avatar ?? "")))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
