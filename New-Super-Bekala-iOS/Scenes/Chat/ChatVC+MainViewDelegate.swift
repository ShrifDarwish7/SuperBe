//
//  ChatVC+MainViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 12/08/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import SVProgressHUD

extension ChatVC: MainViewDelegate{
    
    func didCompleteWithConversation(_ data: Conversation?, _ error: String?) {
        
        SVProgressHUD.dismiss()
        minimizeBtn.isHidden = false
        
        if let data = data{
            
          //  guard data.userTwo != nil else { return }
            
            waitingAgentView.isHidden = true
            
            userOne = data.userOne
            userTwo = data.userTwo
            
            Shared.currentConversationAdminName = data.userTwo?.name
            Shared.currentConversationAdminAvatar = Shared.storageBase + (data.userTwo?.avatar ?? "")
            
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let msgEn = "Hi, \(userOne?.name ?? ""). Thanks for contacting Super Be. This is \(userTwo?.name ?? ""), I hope you`re having a good day, How may I help you?"
            let msgAr = "أهلا \(userOne?.name ?? "") ، " + " شكرا لتواصلك مع سوبر بي ، معاك " + (userTwo?.name ?? "") + " ، اقدر اساعدك ازاي؟"
//            self.messages.append(
//                Message(body: "lang".localized == "en" ? msgEn : msgAr,
//                        senderID: 0,
//                        createdAt: dateFormatter.string(from: Date())))
        
            data.messages?.forEach { message in self.messages.append(message) }
            
            agentName.text = data.userTwo?.name
            chatTableView.delegate = self
            chatTableView.dataSource = self
            chatTableView.reloadData()
            
            if self.messages.count > 0 {
                chatTableView.scrollToRow(at: IndexPath(row: self.messages.count-1, section: 0), at: .bottom, animated: true)
            }
                        
            guard data.status != "locked" else {
                lockView.isHidden = false
                return
            }
            
            lockView.isHidden = true
                        
        }else{
            if Shared.orderChatting!{
                presenter!.startConversation("Order Issue", "\(Shared.orderChattingId!)")
            }else{
                presenter!.startConversation()
            }
        }
    }
    
    func didCompleteStartConversation(_ Id: Int?) {
        if let id = Id{
            Shared.currentConversationId = id
            self.viewDidLoad()
        }
    }
    
    func didCompleteSendMessage(_ sent: Bool, _ id: Int) {
        if sent{
            messages[messages.firstIndex{ $0.incrementalId == id }!].delivered = true
            chatTableView.reloadData()
        }
    }
    
    func didCompleteReopenConversation(_ error: String?) {
    
        activityIndicator.stopAnimating()
        reopenBtn.isHidden = false
        
        guard error == nil else {
            showToast(error!)
            return
        }
        lockView.isHidden = true
    }
    
    func didCompleteLockConversation(_ error: String?) {
        guard error == nil else {
            showToast(error!)
            return
        }
        Shared.unseenMessages = 0
        Shared.isChatting = false
        NotificationCenter.default.post(name: NSNotification.Name("is_chatting"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
}
