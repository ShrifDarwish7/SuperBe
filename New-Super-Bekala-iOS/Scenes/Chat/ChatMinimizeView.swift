//
//  ChatMinimizeView.swift
//  Super Bekala iOS
//
//  Created by Sherif Darwish on 11/2/20.
//  Copyright © 2020 mobidevlabs. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import AVFoundation

@IBDesignable
class ChatMinimizeView: UIView, MainViewDelegate {
    
    @IBOutlet weak var chatMinimize: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var chatLbl: UILabel!
    @IBOutlet weak var adminAvatar: CircluarImage!
    @IBOutlet weak var unseenLbl: RoundedLabel!
    
    let nibName = "ChatMinimizeView"
    var contentView: UIView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        self.makeItDragable()
        contentView = view
        
        self.addTapGesture { (_) in
            Router.toChat(self.parentContainerViewController()!)
        }
        
        chatMinimize.layer.cornerRadius = 10
        
        layer.cornerRadius = 10
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 15
        layer.shadowOffset = CGSize.zero
        layer.shadowColor = UIColor.gray.cgColor
        layer.masksToBounds = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleIfChatting), name: NSNotification.Name("is_chatting"), object: nil)
        
        self.handleIfChatting()
        
    }

    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func makeItDragable(){
        self.addPanGesture { (sender) in
            let translation = sender.translation(in: self.superview)
            self.center = CGPoint(x: self.center.x + translation.x,
                                  y: self.center.y + translation.y)
            sender.setTranslation(CGPoint(x: 0, y: 0), in: self.superview)
        }
    }
    
    @IBAction func close(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "If you exit the chat we will clear the current session messages, are you sure you want to exit ?".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue".localized, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Exit".localized, style: .cancel, handler: { (_) in
            let presenter = MainPresenter(self)
            presenter.lockConversation()
        }))
        self.parentContainerViewController()!.present(alert, animated: true, completion: nil)
    }
    
    func didCompleteLockConversation(_ error: String?) {
        Shared.isChatting = false
        self.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name("is_chatting"), object: nil)
    }
    
    @objc func handleIfChatting(){
        
        chatLbl.text = Shared.currentConversationAdminName
        adminAvatar.kf.setImage(with: URL(string: Shared.currentConversationAdminAvatar ?? ""), placeholder: UIImage(named: "user"))
        
        if Shared.isChatting{
            self.isHidden = false
        }else{
            self.isHidden = true
        }
        
        if Shared.unseenMessages != 0 {
            self.unseenLbl.isHidden = false
            self.unseenLbl.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.unseenLbl.layer.cornerRadius = self.unseenLbl.frame.height / 2
            self.unseenLbl.shake()
            self.unseenLbl.text = "\(Shared.unseenMessages)"
        }else{
            self.unseenLbl.isHidden = true
            self.unseenLbl.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
    }
    
}
