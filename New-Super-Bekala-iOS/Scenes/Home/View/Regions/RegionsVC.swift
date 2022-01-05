//
//  RegionsVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 13/03/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class RegionsVC: UIViewController {
    
    @IBOutlet weak var regionsTableView: UITableView!
    var regions: [Region]?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTableFromNib()
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }


}
