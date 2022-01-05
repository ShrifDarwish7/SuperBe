//
//  NoConnectionVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 22/07/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import Reachability

class NoConnectionVC: UIViewController {

    let reachability = try! Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7)
        }
    }
    
    @IBAction func exitAction(_ sender: Any) {
        exit(0)
    }
    
    @IBAction func retryActiion(_ sender: Any) {
        if ConnectionManager.shared.hasConnectivity(){
            self.view.backgroundColor = .clear
            self.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: NSNotification.Name("RELOAD"), object: nil, userInfo: nil)
        }
    }
    
    @objc func reachabilityChanged(note: Notification){
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .wifi, .cellular:
            self.view.backgroundColor = .clear
            self.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }

}
