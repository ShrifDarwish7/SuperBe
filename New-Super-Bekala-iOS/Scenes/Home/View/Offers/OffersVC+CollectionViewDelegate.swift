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
//    
//    func loadFiltersCollection(){
//        let nib = UINib(nibName: FilterCollectionViewCell.identifier, bundle: nil)
//        filtersCollection.register(nib, forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)
//        filtersCollection.delegate = self
//        filtersCollection.dataSource = self
//        if let flowLayout = filtersCollection?.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
//        }
//        filtersCollection.reloadData()
//
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case filtersCollection:
            return self.offersTabs.count
        case specialOffersCollection:
            return self.slider?.count ?? 1
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case filtersCollection:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OffersTabsCollectionViewCell.identifier, for: indexPath) as! OffersTabsCollectionViewCell
            cell.name.text = offersTabs[indexPath.row].name
            cell.icon.image = offersTabs[indexPath.row].image
            if offersTabs[indexPath.row].selected{
                cell.name.alpha = 1
                cell.icon.alpha = 1
            }else{
                cell.name.alpha = 0.5
                cell.icon.alpha = 0.5
            }
            return cell
            
        case specialOffersCollection:
            
            if sliderIsLoading{
                let nib = UINib(nibName: ProductSkeletonCollectionViewCell.identifier, bundle: nil)
                specialOffersCollection.register(nib, forCellWithReuseIdentifier: ProductSkeletonCollectionViewCell.identifier)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductSkeletonCollectionViewCell.identifier, for: indexPath) as! ProductSkeletonCollectionViewCell
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SpecialOffersCollectionViewCell.identifier, for: indexPath) as! SpecialOffersCollectionViewCell
                let urlStr = self.slider![indexPath.row].image//"lang".localized == "en" ? self.slider![indexPath.row].image?.en : self.slider![indexPath.row].image?.ar
                cell.image.kf.indicatorType = .activity
                cell.image.kf.setImage(with: URL(string: Shared.storageBase + urlStr!), placeholder: nil, options: [], completionHandler: nil)
                cell.image.contentMode = .scaleAspectFit
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
            
            showSkeletonView()
            
            for i in 0...offersTabs.count-1{
                offersTabs[i].selected = false
            }
            offersTabs[indexPath.row].selected = true
            collectionView.reloadData()
            
            page = 1
            branches.removeAll()
            parameters.updateValue("\(page)", forKey: "page")
            
            switch indexPath.row{
            case 0:
                presenter?.getBranches(parameters)
            case 1:
                presenter?.getOffers(parameters)
            case 2:
                presenter?.getCouponsOffers(parameters)
            default: break
            }
            
        case specialOffersCollection:
            
            switch self.slider![indexPath.row].slidableType {
            case .branch:
                
                guard let branch = self.slider![indexPath.row].branch else { return }
                
                if branch.isOnhold == 1{
                    
                    let msg = "lang".localized == "en" ? "\(branch.name?.en ?? "") is on hold at the moment" : "\(branch.name?.ar ?? "") معلق حاليا"
                    showAlert(title: "", message: msg)
                    
                }else if branch.isBusy == 1 {
                    
                    let msg = "lang".localized == "en" ? "\(branch.name?.en ?? "") is currently busy, and your order may take longer than expected" : "\(branch.name?.en ?? "") مشغول حاليًا ، وقد يستغرق طلبك وقتًا أطول من المتوقع"
                    let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
                    let continueAction = UIAlertAction(title: "Contiue".localized, style: .default) { _ in
                        Router.toBranch(self, branch)
                    }
                    let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
                    alert.addAction(continueAction)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                    
                }else if branch.isOpen == 1{
                    
                    Router.toBranch(self, branch)
                    
                }else if branch.isOpen == 0 {
                    
//                    let msg = "lang".localized == "en" ? "\(branch.name?.en ?? "") is currently closed, and is not accepting orders at this time, you can continue exploring and adding items to your cart and order when vendor is available" : "\(branch.name?.ar ?? "") مغلق حاليًا ، ولا يقبل الطلبات في الوقت الحالي ، يمكنك متابعة استكشاف المنتجات وإضافتها إلى سلة التسوق وطلبها عند توفر المتجر"
                    let msg = "lang".localized == "en" ? "\(branch.name?.en ?? "") is currently closed, and will open in \(branch.openingTime ?? "")" : "\(branch.name?.ar ?? "") " +  "مغلق حاليا، وسيكون متاح الساعة" + " \(branch.openingTime ?? "")"

                    let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
                    let continueAction = UIAlertAction(title: "Contiue".localized, style: .default) { _ in
                        Router.toBranch(self, branch)
                    }
                    let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
                    alert.addAction(continueAction)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            case .product:
                
                guard let product = self.slider![indexPath.row].product else { return }
                Router.toProduct(self, product)
                
            case .coupons:
                
                UIPasteboard.general.string = self.slider![indexPath.row].name
                showAlert(title: "", message: "Coupon copied to clipboard".localized)
                
            case .category:
                break
            }
        default:
            break
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case filtersCollection:
            return CGSize(width: collectionView.frame.width/3, height: collectionView.frame.height)
//            let font = UIFont(name: "Lato-Bold", size: 20)
//            let fontAttributes = [NSAttributedString.Key.font: font]
//            let size = (("lang".localized == "en" ? self.categories?[indexPath.row].name!.en : self.categories?[indexPath.row].name!.ar)! as NSString ).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
//            return CGSize(width: size.width + 10 , height: size.height + 20)
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
