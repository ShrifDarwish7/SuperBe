//
//  ShoopingVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Super Bekala on 7/12/20.
//  Copyright © 2020 Super Bekala. All rights reserved.
//

import UIKit
import SkeletonView

class ShoopingVC: UIViewController {

    @IBOutlet weak var featuredVendorsCollection: UICollectionView!
    @IBOutlet weak var ordinaryVendorsTAbleView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    @IBOutlet weak var allFeaturedBtn: UIButton!
    
    var presenter: MainPresenter?
    var categories: [Category]?
    var selectedCategory: Category?
    var featuredBranches: [Branch]?
    var branches: [Branch]?
    var parameters: [String:String] = [:]
    var featuredLoading = true
    var ordinaryLoading = true
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        
        showSkeletonView()
        
        presenter = MainPresenter(self)
        presenter?.getFavourites()

    }
    
    func showSkeletonView(){
        ordinaryVendorsTAbleView.hideSkeleton()
        featuredVendorsCollection.hideSkeleton()
                
        loadFiltersCollection()
        loadFeaturedCollection(identifier: SkeletonLoadingCollectionViewCell.identifier)
        loadOrdinaryTable(identifier: OrdinaryVendorsSkeletonTableViewCell.identifier)
        
        filtersCollectionView.isSkeletonable = true
        featuredVendorsCollection.isSkeletonable = true
        ordinaryVendorsTAbleView.isSkeletonable = true
        
        filtersCollectionView.showAnimatedSkeleton(usingColor: .lightGray, transition: .crossDissolve(0.25))

        featuredVendorsCollection.showAnimatedSkeleton(usingColor: .lightGray, transition: .crossDissolve(0.25))
       
        ordinaryVendorsTAbleView.showAnimatedSkeleton(usingColor: .lightGray, transition: .crossDissolve(0.25))
    }
    
    override func viewDidLayoutSubviews() {
        super.updateViewConstraints()
        tableViewHeight.constant = ordinaryVendorsTAbleView.contentSize.height + 125
        self.view.layoutIfNeeded()
    }

    @IBAction func toAllFeatured(_ sender: Any) {
        Router.toViewAllFeatured(self, self.featuredBranches!)
    }
    
}
