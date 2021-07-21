//
//  InfoVC+TableViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 10/07/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit

extension InfoVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case phonesTableView:
            return (branch?.phones!.count)!
        case deliveryAreasTableView:
            return (branch?.deliveryRegions!.count)!
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        cell.selectionStyle = .none
        switch tableView {
        case phonesTableView:
            cell.textLabel?.text = branch?.phones![indexPath.row]
        case deliveryAreasTableView:
            cell.textLabel?.text = branch?.deliveryRegions![indexPath.row].name
        default:
            break
        }
        return cell
    }
    
}
