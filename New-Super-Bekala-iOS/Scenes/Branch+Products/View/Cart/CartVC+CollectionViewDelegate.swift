//
//  CartVC+CollectionViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 03/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit

extension CartVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func loadFiltersCollection(){
        let nib = UINib(nibName: CartFiltersCollectionViewCell.identifier, bundle: nil)
        filtersCollectionView.register(nib, forCellWithReuseIdentifier: CartFiltersCollectionViewCell.identifier)
        filtersCollectionView.delegate = self
        filtersCollectionView.dataSource = self
        filtersCollectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.branches!.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let branch = self.branches![indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CartFiltersCollectionViewCell.identifier, for: indexPath) as! CartFiltersCollectionViewCell
        cell.name.text = "\(branch.id)"//"lang".localized == "en" ? branch.nameEn : branch.nameAr
        cell.img.sd_setImage(with: URL(string: Shared.storageBase + branch.logo!))
        
        if branch.selected {
            cell.name.textColor = .white
            cell.container.backgroundColor = #colorLiteral(red: 0, green: 0.2441717982, blue: 0.4584932923, alpha: 1)
            cell.container.layer.borderWidth = 0
        }else{
            cell.name.textColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
            cell.container.backgroundColor = .clear
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for i in 0...branches!.count-1{
            branches![i].selected = false
        }
        branches![indexPath.row].selected = true
        self.selectedBranch = branches![indexPath.row]
        try! CartServices.managedObjectContext.save()
        filtersCollectionView.reloadData()
        CartServices.shared.getCartItems(itemId: -1, branch: Int(self.branches![indexPath.row].id)) { (items) in
            if let items = items{
                self.items = items
                self.productsTableView.reloadData()
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let branch = self.branches![indexPath.row]
        let font = UIFont(name: "Lato-Bold", size: 17)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let branchName = "lang".localized == "en" ? branch.name_en : branch.name_ar
        let size = (branchName! as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        return CGSize(width: size.width + 80 , height: filtersCollectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
