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
            cell.filterName.text = self.categories?[indexPath.row].branchCategoryLanguage.first?.name
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
                
                let inCartItems = self.cartItems?.filter({ return $0.cart_id == self.products![indexPath.row].id })
                if inCartItems!.isEmpty{
                    cell.inCartView.isHidden = true
                    cell.addToCartBtn.isHidden = false
                }else{
                    cell.inCartView.isHidden = false
                    cell.addToCartBtn.isHidden = true
                    cell.quantity.text = "\(inCartItems?.first?.quantity ?? 1)"
                }
                
                cell.addToCartBtn.onTap {
                    
                    guard self.products![indexPath.row].variations == nil || (self.products![indexPath.row].variations?.isEmpty == true) else {
                        Router.toProduct(self, self.branch, self.products![indexPath.row])
                        return
                    }
                    
                    cell.inCartView.isHidden = false
                    cell.addToCartBtn.isHidden = true
                    
                    self.products![indexPath.row].quantity = 1
                    self.products![indexPath.row].notes = ""
                    
                    CartServices.shared.addToCart(self.branch!, self.products![indexPath.row]) { (completed) in
                        if completed{
                            self.fetchCartItems()
                           // self.showToast("Product added successfully to your cart")
                        }
                    } exist: { (exist) in
                        if exist{
                            self.showToast("Your cart contains the same product, please choose another one or choose any other variations if exists")
                        }
                    }
                }
                
                cell.increaseBtn.onTap { [self] in
                    guard Int(cell.quantity.text!)! > 0 else{
                        return
                    }
                    var newQty: Int = Int(cell.quantity.text!)!
                    newQty += 1
                    cell.quantity.text = "\(newQty)"
                    CartServices.shared.updateQuantity(newValue: newQty, id: Int(inCartItems!.first!.cart_id), nil)
                    fetchCartItems()
                }
                
                cell.decreaseBtn.onTap { [self] in
                    guard Int(cell.quantity.text!)! > 1 else{
                        return
                    }
                    var newQty: Int = Int(cell.quantity.text!)!
                    newQty -= 1
                    cell.quantity.text = "\(newQty)"
                    CartServices.shared.updateQuantity(newValue: newQty, id: Int(inCartItems!.first!.cart_id), nil)
                    fetchCartItems()
                }
                
                return cell
            }
            
        default:
            return UICollectionViewCell()
        }
    }
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
//        return 1
//    }
    
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
            let size = ((self.categories?[indexPath.row].branchCategoryLanguage.first?.name ?? "") as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
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
            for i in 0...self.categories!.count-1{ self.categories![i].selected = false }
            self.categories![indexPath.row].selected = true
            self.selectedCat = self.categories![indexPath.row]
            self.filtersCollectionView.reloadData()
            self.filtersCollectionView.scrollToItem(at: IndexPath(row: indexPath.row, section: 0), at: .centeredHorizontally, animated: true)
            isLoading = true
            productsCollectionView.showAnimatedSkeleton(usingColor: .lightGray, transition: .crossDissolve(0.25))
            loadProductsCollection()
            //prms.updateValue("branch_category_id=\(self.selectedCat?.id ?? 0)", forKey: "filter")
            presenter?.getBranchProduct(id: branch!.id, prms: prms)
        case productsCollectionView:
//            SVProgressHUD.show()
//            APIServices.shared.call(.getProductByID(1, 3, ["with": "variations.options"])) { (data) in
//                print(JSON(data))
//                SVProgressHUD.dismiss()
//                Router.toProduct(self, self.branch,try! JSON(data!)["data"].rawData().getDecodedObject(from: Product.self))
//            }
            Router.toProduct(self, self.branch, self.products![indexPath.row])
        default:
            break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        guard (self.products?.count ?? 0) > 4 else { return  }
        
        let maxHeight: CGFloat = self.view.frame.height - UIApplication.shared.statusBarFrame.height - 50
        let minHeight: CGFloat = self.view.frame.height * 0.5
        let y: CGFloat = scrollView.contentOffset.y
        let newViewHeight = self.productsViewHeight.constant + y
        if newViewHeight > maxHeight{
            self.productsViewHeight.constant = maxHeight
        }else if newViewHeight < minHeight{
            self.productsViewHeight.constant = minHeight
        }else{
            self.productsViewHeight.constant = newViewHeight
           // scrollView.contentOffset.y = 0
        }

    }
}
