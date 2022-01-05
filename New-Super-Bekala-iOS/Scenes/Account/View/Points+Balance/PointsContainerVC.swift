//
//  PointsContainerVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 19/05/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class PointsContainerVC: UIViewController {
    
    @IBOutlet weak var tabsCollectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!

    var tabs = [Tab]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabs.append(Tab(name: "Balance".localized, selected: true))
        tabs.append(Tab(name: "Points".localized, selected: false))
        
        self.replaceView(containerView: containerView, identifier: "BalanceVC", storyboard: .profile)
        
        loadTabs()
    }

}

struct Tab{
    var name: String
    var selected: Bool
}
