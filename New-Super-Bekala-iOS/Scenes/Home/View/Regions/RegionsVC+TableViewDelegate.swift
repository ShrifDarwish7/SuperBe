//
//  RegionsVC+TableViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 13/03/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit

extension RegionsVC: UITableViewDelegate, UITableViewDataSource{
    
    func loadTableFromNib(){
        let nib = UINib(nibName: "RegionsTableViewCell", bundle: nil)
        self.regionsTableView.register(nib, forCellReuseIdentifier: "RegionsTableViewCell")
        self.regionsTableView.delegate = self
        self.regionsTableView.dataSource = self
        self.regionsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.regions!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegionsTableViewCell", for: indexPath) as! RegionsTableViewCell
        
        cell.cityName.text = "lang".localized == "en" ? self.regions![indexPath.row].name?.en : self.regions![indexPath.row].name?.ar
        
        if let subregions = self.regions![indexPath.row].subregions,
           !subregions.isEmpty{
            cell.regionTableView.numberOfRows { (_) -> Int in
                return self.regions![indexPath.row].subregions!.count
            }.cellForRow { (index) -> UITableViewCell in
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
                cell.textLabel?.text = "lang".localized == "en" ? self.regions![indexPath.row].subregions![index.row].name?.en : self.regions![indexPath.row].subregions![index.row].name?.ar
               // cell.textLabel?.font = UIFont(name: "Cairo-SemiBold", size: 13)
                cell.selectionStyle = .none
                return cell
            }.heightForRowAt { (_) -> CGFloat in
                return 30
            }.didSelectRowAt { (index) in
                Shared.userSelectLocation = true
                Shared.isCoords = false
                Shared.isRegion = true
                Shared.selectedArea = SelectedArea(
                    regionsID: self.regions![indexPath.row].id,
                    regionsNameEn: self.regions![indexPath.row].name?.en,
                    regionNameAr: self.regions![indexPath.row].name?.ar,
                    subregionID: self.regions![indexPath.row].subregions![index.row].id,
                    subregionEn: self.regions![indexPath.row].subregions![index.row].name?.en,
                    subregionAr: self.regions![indexPath.row].subregions![index.row].name?.ar)
                Router.toHome(self)
            }
            cell.regionTableView.reloadData()
        }else{
            cell.expandIcon.isHidden = true
        }
        
        if self.regions![indexPath.row].expanded ?? false{
            cell.expandIcon.image = UIImage(named: "unexpand")
            cell.regionTableView.isHidden = false
            cell.heightCnst.constant = CGFloat((self.regions![indexPath.row].subregions?.count ?? 0) * 30)
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }else{
            cell.heightCnst.constant = 0
            cell.regionTableView.isHidden = true
            cell.expandIcon.image = UIImage(named: "expand")
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let subregions = self.regions![indexPath.row].subregions,
           !subregions.isEmpty{
            self.regions![indexPath.row].expanded = !(self.regions![indexPath.row].expanded ?? false)
            self.regionsTableView.reloadData()
        }else{
            Shared.userSelectLocation = true
            Shared.isCoords = false
            Shared.isRegion = true
            Shared.selectedArea = SelectedArea(
                regionsID: self.regions![indexPath.row].id,
                regionsNameEn: self.regions![indexPath.row].name?.en,
                regionNameAr: self.regions![indexPath.row].name?.ar,
                subregionID: 0,
                subregionEn: "",
                subregionAr: ""
            )
            Router.toHome(self)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.regions![indexPath.row].expanded ?? false{
            return CGFloat((self.regions![indexPath.row].subregions?.count ?? 0) * 30 + 60)
        }else{
            return 60
        }
    }
}
