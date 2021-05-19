//
//  CitiesVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 13/03/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class CitiesVC: UIViewController {

    @IBOutlet weak var citiesTableView: UITableView!
    
    var cities: [City]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        citiesTableView.delegate = self
        citiesTableView.dataSource = self
        citiesTableView.reloadData()
        
    }

    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

