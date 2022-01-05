//
//  PointsContainerVC+CollectionViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 19/05/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit

extension PointsContainerVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func loadTabs(){
        let nib = UINib(nibName: FilterCollectionViewCell.identifier, bundle: nil)
        tabsCollectionView.register(nib, forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)
        tabsCollectionView.delegate = self
        tabsCollectionView.dataSource = self
        tabsCollectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tabs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, for: indexPath) as! FilterCollectionViewCell
        cell.filterName.textColor = .black
        cell.underLine.backgroundColor = .black
        cell.filterName.text = self.tabs[indexPath.row].name
        if self.tabs[indexPath.row].selected{
            cell.underLine.isHidden = false
            cell.filterName.alpha = 1
        }else{
            cell.filterName.alpha = 0.1
            cell.underLine.isHidden = true
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for i in 0...self.tabs.count-1{
            self.tabs[i].selected = false
        }
        self.tabs[indexPath.row].selected = true
        self.tabsCollectionView.reloadData()
        self.tabsCollectionView.scrollToItem(at: IndexPath(row: indexPath.row, section: 0), at: .centeredHorizontally, animated: true)
        switch indexPath.row {
        case 0:
            self.replaceView(containerView: containerView, identifier: "BalanceVC", storyboard: .profile)
        case 1:
            self.replaceView(containerView: containerView, identifier: "PointsVC", storyboard: .profile)
        default:
            break
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let font = UIFont(name: "Lato-Bold", size: 20)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = ((self.tabs[indexPath.row].name) as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        return CGSize(width: size.width + 20 , height: size.height + 20)
    }
}
