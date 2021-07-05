//
//  OffersVC+CollectionViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 24/05/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit
import SkeletonView

extension OffersVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SkeletonCollectionViewDataSource{
    
    func loadFiltersCollection(){
        let nib = UINib(nibName: FilterCollectionViewCell.identifier, bundle: nil)
        filtersCollection.register(nib, forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)
        filtersCollection.delegate = self
        filtersCollection.dataSource = self
        if let flowLayout = filtersCollection?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        }
        filtersCollection.reloadData()

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case filtersCollection:
            return self.categories!.count
        case specialOffersCollection:
            return self.slider?.count ?? 1
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case filtersCollection:
            
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
            
        case specialOffersCollection:
            
            if sliderIsLoading{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductSkeletonCollectionViewCell.identifier, for: indexPath) as! ProductSkeletonCollectionViewCell
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpecialOffersCollectionViewCell.identifier, for: indexPath) as! SpecialOffersCollectionViewCell
                let urlStr = "lang".localized == "en" ? self.slider![indexPath.row].image.en : self.slider![indexPath.row].image.ar
                cell.image.sd_setImage(with: URL(string: Shared.storageBase + urlStr!))
                return cell
            }
            
        default:
            return UICollectionViewCell()
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch collectionView {
        case specialOffersCollection:
            pageControl.currentPage = indexPath.row
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView {
        case filtersCollection:
            for i in 0...self.categories!.count-1{
                self.categories![i].selected = false
            }
            self.categories![indexPath.row].selected = true
            self.selectedCategory = self.categories![indexPath.row]
            self.filtersCollection.reloadData()
            self.filtersCollection.scrollToItem(at: IndexPath(row: indexPath.row, section: 0), at: .centeredHorizontally, animated: true)
            self.showSkeletonView()
            self.updateBranches()
        case specialOffersCollection:
            switch self.slider![indexPath.row].slidableType {
            case .branch:
                self.presenter?.getBranchBy(self.slider![indexPath.row].slidableID)
            default:
                break
            }
        default:
            break
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case filtersCollection:
            let font = UIFont(name: "Lato-Bold", size: 16)
            let fontAttributes = [NSAttributedString.Key.font: font]
            let size = (("lang".localized == "en" ? self.categories?[indexPath.row].name!.en : self.categories?[indexPath.row].name!.ar)! as NSString ).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
            return CGSize(width: size.width + 10 , height: size.height + 20)
        default:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        switch skeletonView {
        case filtersCollection:
            return FilterCollectionViewCell.identifier
        case specialOffersCollection:
            return ProductSkeletonCollectionViewCell.identifier
        default:
            return ""
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
