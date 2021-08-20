//
//  SplashVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 09/03/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import Reachability

class SplashVC: UIViewController {

    let reachability = try! Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let window = UIWindow.key{
            let chatMinimizeView = ChatMinimizeView()
            window.addSubview(chatMinimizeView)
            chatMinimizeView.translatesAutoresizingMaskIntoConstraints = false
            let trailingConstraint = NSLayoutConstraint(item: chatMinimizeView, attribute: .trailing, relatedBy: .equal, toItem: window.rootViewController?.view, attribute: .trailing, multiplier: 1, constant: -10)
            let verticalConstraint = NSLayoutConstraint(item: chatMinimizeView, attribute: .centerY, relatedBy: .equal, toItem: window.rootViewController?.view, attribute: .centerY, multiplier: 1, constant: 0)
            let widthConstraint = NSLayoutConstraint(item: chatMinimizeView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
            let heightConstraint = NSLayoutConstraint(item: chatMinimizeView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 160)
            window.addConstraints([trailingConstraint, verticalConstraint, widthConstraint, heightConstraint])
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("RELOAD"), object: nil)
        
        if ConnectionManager.shared.hasConnectivity(){
            if APIServices.shared.isLogged {
                if Shared.userSelectLocation{
                    Router.toHome(self)
                }else{
                    Router.toAskLocation(self)
                }
            }else{
                Router.toAboutUs(self)
            }
        }else{
            Router.toNoConnection(self)
        }
    }
    
    @objc func reload(){
        guard (self.navigationController?.topViewController?.isKind(of: SplashVC.self))! else { return }
        self.viewDidLoad()
    }

}
