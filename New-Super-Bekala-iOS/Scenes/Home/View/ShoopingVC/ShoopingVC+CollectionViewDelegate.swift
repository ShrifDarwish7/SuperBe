//
//  ShoopingVC+CollectionViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 16/03/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit
import SkeletonView

extension ShoopingVC: UICollectionViewDelegate, SkeletonCollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func loadFiltersCollection(){
        let nib = UINib(nibName: FilterCollectionViewCell.identifier, bundle: nil)
        filtersCollectionView.register(nib, forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)
        filtersCollectionView.delegate = self
        filtersCollectionView.dataSource = self
        if let flowLayout = filtersCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
         //   flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        }
        filtersCollectionView.reloadData()

    }
    
    func loadFeaturedCollection(identifier: String){
        let nib = UINib(nibName: identifier, bundle: nil)
        featuredVendorsCollection.register(nib, forCellWithReuseIdentifier: identifier)
        featuredVendorsCollection.delegate = self
        featuredVendorsCollection.dataSource = self
        featuredVendorsCollection.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case filtersCollectionView:
            return self.categories?.count ?? 0
        case featuredVendorsCollection:
            return self.branches?.count ?? 5
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case filtersCollectionView:
            
            let cell = filtersCollectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, for: indexPath) as! FilterCollectionViewCell
            cell.filterName.text = "lang".localized == "en" ? self.categories?[indexPath.row].name?.en: self.categories?[indexPath.row].name?.ar
            cell.filterName.sizeToFit()
            cell.filterName.lineBreakMode = .byCharWrapping
            if self.categories?[indexPath.row].selected ?? false{
                cell.underLine.isHidden = false
            }else{
                cell.underLine.isHidden = true
            }
            
            return cell
            
        case featuredVendorsCollection:
            
            if featuredLoading{
                
                let cell = self.featuredVendorsCollection.dequeueReusableCell(withReuseIdentifier: SkeletonLoadingCollectionViewCell.identifier, for: indexPath) as! SkeletonLoadingCollectionViewCell
                return cell
                
            }else{
                
                let cell = self.featuredVendorsCollection.dequeueReusableCell(withReuseIdentifier: FeaturedCollectionViewCell.identifier, for: indexPath) as! FeaturedCollectionViewCell
                cell.loadFrom(data: self.featuredBranches![indexPath.row])
                return cell
                
            }
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        case filtersCollectionView:

            for i in 0...self.categories!.count-1{
                self.categories![i].selected = false
            }
            self.categories![indexPath.row].selected = true
            self.selectedCategory = self.categories![indexPath.row]
            self.filtersCollectionView.reloadData()
            self.filtersCollectionView.scrollToItem(at: IndexPath(row: indexPath.row, section: 0), at: .centeredHorizontally, animated: true)
            self.featuredLoading = true
            self.ordinaryLoading = true
            self.showSkeletonView()
            self.updateBranches()

        case featuredVendorsCollection:

            Router.toBranch(self, self.featuredBranches![indexPath.row])

        default:
            break
        }

        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case featuredVendorsCollection:
            return CGSize(width: 180, height: 220)
        case filtersCollectionView:
            let font = UIFont(name: "Lato-Bold", size: 16)
            let fontAttributes = [NSAttributedString.Key.font: font]
            let size = (("lang".localized == "en" ? self.categories?[indexPath.row].name?.en ?? "" : self.categories?[indexPath.row].name?.ar ?? "") as NSString ).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
            return CGSize(width: size.width + 10 , height: size.height + 20)
        default:
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return 1
    }

    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 2
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier{
        switch skeletonView {
        case filtersCollectionView:
            return FilterCollectionViewCell.identifier
        case featuredVendorsCollection:
            return "SkeletonLoadingCollectionViewCell"
        default:
            return ""
        }
        
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, supplementaryViewIdentifierOfKind: String, at indexPath: IndexPath) -> ReusableCellIdentifier?{
        switch skeletonView {
        case filtersCollectionView:
            return FilterCollectionViewCell.identifier
        case featuredVendorsCollection:
            return FeaturedCollectionViewCell.identifier
        default:
            return ""
        }
    }
    
    
}
