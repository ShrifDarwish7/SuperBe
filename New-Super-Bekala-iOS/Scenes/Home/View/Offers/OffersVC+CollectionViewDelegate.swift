//
//  OffersVC+CollectionViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 24/05/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit

extension OffersVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func loadFiltersCollection(){
        let nib = UINib(nibName: FilterCollectionViewCell.identifier, bundle: nil)
        filtersCollection.register(nib, forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)
        filtersCollection.delegate = self
        filtersCollection.dataSource = self
        if let flowLayout = filtersCollection?.collectionViewLayout as? UICollectionViewFlowLayout {
         //   flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        }
        filtersCollection.reloadData()

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, for: indexPath) as! FilterCollectionViewCell
        cell.filterName.text = "lang".localized == "en" ? self.categories?[indexPath.row].name?.en: self.categories?[indexPath.row].name?.ar
        cell.filterName.sizeToFit()
        cell.filterName.lineBreakMode = .byCharWrapping
        if self.categories?[indexPath.row].selected ?? false{
            cell.underLine.isHidden = false
        }else{
            cell.underLine.isHidden = true
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        for i in 0...self.categories!.count-1{
            self.categories![i].selected = false
        }
        self.categories![indexPath.row].selected = true
        self.selectedCategory = self.categories![indexPath.row]
        self.filtersCollection.reloadData()
        self.filtersCollection.scrollToItem(at: IndexPath(row: indexPath.row, section: 0), at: .centeredHorizontally, animated: true)
        self.showSkeletonView()
        self.updateBranches()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let font = UIFont(name: "Lato-Bold", size: 16)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (("lang".localized == "en" ? self.categories?[indexPath.row].name!.en : self.categories?[indexPath.row].name!.ar)! as NSString ).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        return CGSize(width: size.width + 10 , height: size.height + 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
