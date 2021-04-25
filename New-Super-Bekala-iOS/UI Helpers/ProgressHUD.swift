//
//  ProgressHUD.swift
//  Passioneurs
//
//  Created by Sherif Darwish on 1/18/20.
//  Copyright © 2020 Sherif Darwish. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

extension UIViewController {
    func setSVProgressHUD(){
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setDefaultAnimationType(.flat)
        SVProgressHUD.setBackgroundColor(.white)
    }
}
