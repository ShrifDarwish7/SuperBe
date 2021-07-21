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
            if (self.featuredBranches?.count ?? 5) > 3{
                self.allFeaturedBtn.isHidden = false
                return 3
            }else{
                self.allFeaturedBtn.isHidden = true
                return self.branches?.count ?? 3
            }
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
                if let favBranches = Shared.favBranches,
                   !favBranches.isEmpty,
                   !favBranches.filter({ return $0.id == self.featuredBranches![indexPath.row].id}).isEmpty{
                    self.featuredBranches![indexPath.row].isFavourite = 1
                }
                cell.loadFrom(data: self.featuredBranches![indexPath.row])
                cell.favouriteBtn.tag = indexPath.row
                cell.favouriteBtn.addTarget(self, action: #selector(addToFavourite(sender:)), for: .touchUpInside)
                return cell
                
            }
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        case filtersCollectionView:

            selectCategory(index: indexPath.row)

        case featuredVendorsCollection:

            Router.toBranch(self, self.featuredBranches![indexPath.row])

        default:
            break
        }

        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case featuredVendorsCollection:
            return CGSize(width: 180, height: 250)
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
    
    @objc func addToFavourite(sender: UIButton){
        if let favBranches = Shared.favBranches,
           !favBranches.isEmpty,
           !favBranches.filter({ return $0.id == self.featuredBranches![sender.tag].id}).isEmpty{
            let fav = favBranches.filter({ return $0.id == self.featuredBranches![sender.tag].id}).first
            presenter?.removeFromFavourites((fav?.favouriteId)!, sender.tag, true)
        }else{
            let prms = [
                "model_id": "\(self.featuredBranches![sender.tag].id)",
                "model": "Branch"
            ]
            self.presenter?.addToFavourite(prms, sender.tag, true)
        }
    }
    
    
}
