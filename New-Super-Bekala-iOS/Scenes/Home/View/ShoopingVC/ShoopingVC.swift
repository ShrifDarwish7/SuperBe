//
//  ShoopingVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Super Bekala on 7/12/20.
//  Copyright © 2020 Super Bekala. All rights reserved.
//

import UIKit
import SkeletonView

class ShoopingVC: UIViewController, ChooserDelegate {

    @IBOutlet weak var featuredVendorsCollection: UICollectionView!
    @IBOutlet weak var ordinaryVendorsTAbleView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    @IBOutlet weak var allFeaturedBtn: UIButton!
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var categoriesBtn: UIButton!
    @IBOutlet weak var featuredStackContainer: UIStackView!
    
    var presenter: MainPresenter?
    var categories: [Category]?
    var selectedCategory: Category?
    var featuredBranches: [Branch]?
    var branches: [Branch]?
    var parameters: [String:String] = [:]
    var featuredLoading = true
    var ordinaryLoading = true
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        scroller.refreshControl = refreshControl
        
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToTop), name: NSNotification.Name("SCROLL_TO_TOP"), object: nil)
        
        showSkeletonView()
        
        presenter = MainPresenter(self)
        presenter?.getFavourites()
        
    }
    
    @objc func refresh(){
        refreshControl.endRefreshing()
        featuredLoading = true
        ordinaryLoading = true
        self.viewDidLoad()
    }
    
    @objc func scrollToTop(){
        self.scroller.setContentOffset(.zero, animated: true)
    }
    
    func onChoose(_ index: Int) {
        self.selectCategory(index: index)
    }
    
    func showSkeletonView(){
                
        featuredVendorsCollection.hideSkeleton()
        loadFeaturedCollection(identifier: SkeletonLoadingCollectionViewCell.identifier)
        featuredVendorsCollection.showAnimatedSkeleton(usingColor: .lightGray, transition: .crossDissolve(0.25))
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.05) { [self] in
            ordinaryVendorsTAbleView.hideSkeleton()
            loadOrdinaryTable(identifier: OrdinaryVendorsSkeletonTableViewCell.identifier)
            ordinaryVendorsTAbleView.showAnimatedSkeleton(usingColor: .lightGray, transition: .crossDissolve(0.25))
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        tableViewHeight.constant = ordinaryVendorsTAbleView.contentSize.height
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
        self.filtersCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: ("lang".localized == "en" ? .left : .right), animated: true)
        for i in 0...self.categories!.count-1{
            self.categories![i].selected = false
        }
        self.categories![index].selected = true
        self.selectedCategory = self.categories![index]
        self.loadFiltersCollection()
        self.featuredLoading = true
        self.ordinaryLoading = true
        self.showSkeletonView()
        self.updateBranches()
    }
    
    
}
