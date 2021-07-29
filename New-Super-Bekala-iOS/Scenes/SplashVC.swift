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
