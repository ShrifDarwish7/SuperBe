//
//  SplashVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 09/03/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if APIServices.shared.isLogged {
            if Shared.userSelectLocation{
                Router.toHome(self)
            }else{
                Router.toAskLocation(self)
            }
        }else{
            Router.toAboutUs(self)
        }
    }

}
