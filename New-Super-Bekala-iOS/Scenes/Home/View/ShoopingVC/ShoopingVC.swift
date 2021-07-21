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
        
        NotificationCenter.default.addObserver(self, selector: #selector(didChooseCategory(sender:)), name: NSNotification.Name("DID_CHOOSE_OPTION"), object: nil)

    }
    
    @objc func didChooseCategory(sender: NSNotification){
        guard let userInfo = sender.userInfo as? [String: Any] else { return}
        self.selectCategory(index: userInfo["index"] as! Int)
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
    
    @IBAction func toChooser(_ sender: Any) {
        guard let categories = self.categories else { return }
        var list = [String]()
        categories.forEach { category in
            list.append(("lang".localized == "en" ? category.name?.en : category.name?.ar)!)
        }
        Router.toChooser(self, list)
    }
    
    func selectCategory(index: Int){
        for i in 0...self.categories!.count-1{
            self.categories![i].selected = false
        }
        self.categories![index].selected = true
        self.selectedCategory = self.categories![index]
        self.filtersCollectionView.reloadData()
        self.filtersCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: ("lang".localized == "en" ? .left : .right), animated: true)
        self.featuredLoading = true
        self.ordinaryLoading = true
        self.showSkeletonView()
        self.updateBranches()
    }
    
    
}
