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

    @IBOutlet weak var moreFeaturedVendors: UIButton!
    @IBOutlet weak var featuredVendorsCollection: UICollectionView!
    @IBOutlet weak var ordinaryVendorsTAbleView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    
    var presenter: MainPresenter?
    var categories: [Category]?
    var selectedCategory: Category?
    var featuredBranches: [Branch]?
    var branches: [Branch]?
    var parameters: [String:String] = [/*"lang": "lang".localized*/:]
    var isLoading = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showSkeletonView()
        
        presenter = MainPresenter(self)

        loadActions()
    }
    
    func showSkeletonView(){
        ordinaryVendorsTAbleView.hideSkeleton()
        featuredVendorsCollection.hideSkeleton()
        
        isLoading = true
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if Shared.isRegion{
            parameters.updateValue("\(Shared.selectedArea.regionsID ?? 0)", forKey: "region_id")
            if Shared.selectedArea.subregionID != 0{
                parameters.updateValue("\(Shared.selectedArea.subregionID ?? 0)", forKey: "subregion_id")
            }
        }else if Shared.isCoords{
            parameters.updateValue(Shared.selectedCoords, forKey: "coordinates")
        }
        self.presenter?.getCategories(parameters)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.updateViewConstraints()
        tableViewHeight.constant = ordinaryVendorsTAbleView.contentSize.height + 20
        self.view.layoutIfNeeded()
    }
    
    
    func loadActions(){
        
        moreFeaturedVendors.onTap {
            self.performSegue(withIdentifier: "moreFeatured", sender: self)
        }
        
    }

}
