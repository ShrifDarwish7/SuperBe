//
//  PayContainerVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 19/07/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class PayContainerVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {
            self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
        }
    }
    
    @IBAction func close(_ sender: Any) {
        self.view.backgroundColor = .clear
        self.dismiss(animated: true, completion: nil)
    }

}
