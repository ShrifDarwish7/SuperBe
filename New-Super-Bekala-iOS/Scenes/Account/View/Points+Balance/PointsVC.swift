//
//  PointsVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 19/05/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class PointsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension PointsVC: MainViewDelegate{
    func didCompleteWithPoints(_ data: PointsData?, _ error: String?) {
        if let data = data,
           let points = data.total{
           // balanceLbl.text = "\(points) EGP"
        }
    }
}
