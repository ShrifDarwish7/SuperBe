//
//  ChatMinimizeView.swift
//  Super Bekala iOS
//
//  Created by Sherif Darwish on 11/2/20.
//  Copyright © 2020 mobidevlabs. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class ChatMinimizeView: UIView {
    
    @IBOutlet weak var chatMinimize: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var chatLbl: UILabel!
    
    let nibName = "ChatMinimizeView"
    var contentView:UIView?
    
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
//            if !UserDefaults.init().bool(forKey: "isLogged"){
//                Alert.show(self.parentContainerViewController()!, message: "Firstly ... you must login")
//            }else{
//
//                switch Shared.chatType {
//                case .admin:
//                    let storyboard = UIStoryboard(name: "Chat", bundle: nil)
//                    let vc = storyboard.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsViewController
//                    vc.chatType = .admin
//                    self.parentContainerViewController()?.navigationController?.pushViewController(vc, animated: true)
//                default:
//                    let storyboard = UIStoryboard(name: "Chat", bundle: nil)
//                    let vc = storyboard.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsViewController
//                    vc.receivedOrderId = Shared.chatOrderId!
//                    vc.chatType = .delivery
//                    self.parentContainerViewController()?.navigationController?.pushViewController(vc, animated: true)
//                }
//
//
//            }
        }
        
        closeBtn.layer.cornerRadius = closeBtn.frame.height/2
        chatMinimize.layer.cornerRadius = 10
        iconView.layer.cornerRadius = iconView.frame.height/2
        self.layer.cornerRadius = 10
        chatLbl.text = "Chat".localized
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleIfChatting), name: NSNotification.Name("is_chatting"), object: nil)
        
        if Shared.isChatting{
            self.isHidden = false
        }else{
            self.isHidden = true
        }
        
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
        alert.addAction(UIAlertAction(title: "Continue".localized, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Exit".localized, style: .default, handler: { (_) in
            Shared.isChatting = false
            self.isHidden = true
            NotificationCenter.default.post(name: NSNotification.Name("is_chatting"), object: nil)
        }))
        self.parentContainerViewController()!.present(alert, animated: true, completion: nil)
    }
    
    @objc func handleIfChatting(){
        if Shared.isChatting{
            self.isHidden = false
        }else{
            self.isHidden = true
        }
    }
    
}
