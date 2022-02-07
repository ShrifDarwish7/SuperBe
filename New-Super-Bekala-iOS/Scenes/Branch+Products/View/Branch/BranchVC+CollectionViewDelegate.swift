//
//  BranchVC+CollectionViewDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 31/03/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit
import SkeletonView
import SVProgressHUD
import SwiftyJSON

extension BranchVC: UICollectionViewDelegate, SkeletonCollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
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
        filtersCollectionView.semanticContentAttribute = "lang".localized == "en" ? .forceLeftToRight : .forceRightToLeft
    }
    
    func loadProductsCollection(){
        
        if isLoading{
            let nib = UINib(nibName: ProductSkeletonCollectionViewCell.identifier, bundle: nil)
            productsCollectionView.register(nib, forCellWithReuseIdentifier: ProductSkeletonCollectionViewCell.identifier)
        }else{
            let nib = UINib(nibName: ProductCollectionViewCell.identifier, bundle: nil)
            productsCollectionView.register(nib, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        }
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        productsCollectionView.reloadData()
        if !(products?.isEmpty ?? false){
            productsCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case filtersCollectionView:
            return self.categories?.count ?? 4
        case productsCollectionView:
            return self.products?.count ?? 4
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case filtersCollectionView:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, for: indexPath) as! FilterCollectionViewCell
            cell.filterName.text = "lang".localized == "en" ? self.categories?[indexPath.row].name?.en : self.categories?[indexPath.row].name?.ar
            if self.categories![indexPath.row].selected ?? false{
                cell.underLine.isHidden = false
            }else{
                cell.underLine.isHidden = true
            }
            return cell
            
        case productsCollectionView:
            
            if isLoading{
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductSkeletonCollectionViewCell.identifier, for: indexPath) as! ProductSkeletonCollectionViewCell
                return cell
                
            }else{
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as! ProductCollectionViewCell
                cell.productImage.layer.cornerRadius = 25
                cell.loadFrom(data: self.products![indexPath.row])
                
                if self.products![indexPath.row].inStock == 1{
                    let inCartItems = self.cartItems?.filter({ return $0.cart_id == String(self.products![indexPath.row].id!) })
                    if inCartItems!.isEmpty{
                        cell.inCartView.isHidden = true
                        cell.addToCartBtn.isHidden = false
                    }else{
                        cell.inCartView.isHidden = false
                        cell.addToCartBtn.isHidden = true
                        cell.quantity.text = "\(inCartItems?.first?.quantity ?? 1)"
                    }
                    cell.increaseBtn.onTap { [self] in
                        guard Int(cell.quantity.text!)! > 0 else{
                            return
                        }
                        var newQty: Int = Int(cell.quantity.text!)!
                        newQty += 1
                        cell.quantity.text = "\(newQty)"
                        CartServices.shared.updateQuantity(newValue: newQty, id: (inCartItems!.first!.cart_id)!, nil)
                        fetchCartItems()
                    }
                    
                    cell.decreaseBtn.onTap { [self] in
                        guard Int(cell.quantity.text!)! > 1 else{
                            return
                        }
                        var newQty: Int = Int(cell.quantity.text!)!
                        newQty -= 1
                        cell.quantity.text = "\(newQty)"
                        CartServices.shared.updateQuantity(newValue: newQty, id: (inCartItems!.first!.cart_id)!, nil)
                        fetchCartItems()
                    }
                }else{
                    cell.addToCartBtn.isHidden = true
                    cell.inCartView.isHidden = true
                }
                
                cell.addToCartBtn.onTap {
                    
                    guard self.products![indexPath.row].variations == nil || (self.products![indexPath.row].variations?.isEmpty == true) else {
                        Router.toProduct(self, self.products![indexPath.row])
                        return
                    }
                    
                    cell.inCartView.isHidden = false
                    cell.addToCartBtn.isHidden = true
                    
                    self.products![indexPath.row].quantity = 1
                    self.products![indexPath.row].notes = ""
                    
                    CartServices.shared.addToCart(self.products![indexPath.row]) { (completed) in
                        if completed{
                            self.fetchCartItems()
                        }
                    }
                }
                
                return cell
            }
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 4
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        switch skeletonView {
        case filtersCollectionView:
            return FilterCollectionViewCell.identifier
        case productsCollectionView:
            return ProductSkeletonCollectionViewCell.identifier
        default:
            return ""
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, supplementaryViewIdentifierOfKind: String, at indexPath: IndexPath) -> ReusableCellIdentifier?{
        switch skeletonView {
        case filtersCollectionView:
            return FilterCollectionViewCell.identifier
        case productsCollectionView:
            return ProductSkeletonCollectionViewCell.identifier
        default:
            return ""
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case filtersCollectionView:
            let font = UIFont(name: "Lato-Bold", size: 16)
            let fontAttributes = [NSAttributedString.Key.font: font]
            let size = (("lang".localized == "en" ? self.categories?[indexPath.row].name?.en ?? "" : self.categories?[indexPath.row].name?.ar ?? "") as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
            return CGSize(width: size.width + 30 , height: size.height + 20)
        case productsCollectionView:
            return CGSize(width: self.productsCollectionView.frame.width/2, height: 250)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case filtersCollectionView:
            
            self.selectCategory(index: indexPath.row)
            
        case productsCollectionView:
            
            guard self.products![indexPath.row].inStock == 1 else { return }
            guard self.products![indexPath.row].isOpen == 1 else { return }
            self.products![indexPath.row].branch = self.branch
            Router.toProduct(self, self.products![indexPath.row])
            
        default:
            break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        guard (self.products?.count ?? 0) > 4 else { return  }
  
        let y: CGFloat = scrollView.contentOffset.y
        let newViewHeight = self.productsViewHeight.constant - y
        if newViewHeight > infoStack.frame.height{
            self.productsViewHeight.constant = infoStack.frame.height
        }else if newViewHeight < 0{
            self.productsViewHeight.constant = 0
        }else{
            self.productsViewHeight.constant = newViewHeight
        }
        
    }
}
