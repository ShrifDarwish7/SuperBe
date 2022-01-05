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
        
        if Shared.isRegion{
            parameters.updateValue("\(Shared.selectedArea.regionsID ?? 0)", forKey: "region_id")
            if Shared.selectedArea.subregionID != 0{
                parameters.updateValue("\(Shared.selectedArea.subregionID ?? 0)", forKey: "subregion_id")
            }
        }else if Shared.isCoords{
            parameters.updateValue(Shared.selectedCoords, forKey: "coordinates")
        }
        parameters.updateValue("all", forKey: "lang")
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        scroller.refreshControl = refreshControl
        
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToTop), name: NSNotification.Name("SCROLL_TO_TOP"), object: nil)
        
        showSkeletonView()
                
        presenter = MainPresenter(self)
        if APIServices.shared.isLogged{
            presenter?.getFavourites()
        }else{
            presenter?.getCategories(parameters)
        }
        
        //NotificationCenter.default.addObserver(self, selector: #selector(shouldShowCategories), name: NSNotification.Name(rawValue: "SHOULD_SHOW_CATEGORIES"), object: nil)
        
    }
    
//    @objc func shouldShowCategories(){
//        Router.toChooseCategory(self, self, categories!)
//    }
    
    @objc func refresh(){
        refreshControl.endRefreshing()
//        featuredLoading = true
//        ordinaryLoading = true
//        self.viewDidLoad()
        selectCategory(index: (categories!.firstIndex(where: { $0.id == selectedCategory?.id }))!)
    }
    
    @objc func scrollToTop(){
        self.scroller.setContentOffset(.zero, animated: true)
    }
    
    func onChoose(_ index: Int) {
        self.selectCategory(index: categories!.firstIndex(where: { $0.id == index })!)
    }
    
    func showSkeletonView(){
                
        featuredVendorsCollection.hideSkeleton()
        loadFeaturedCollection(identifier: SkeletonLoadingCollectionViewCell.identifier)
        featuredVendorsCollection.showAnimatedSkeleton(usingColor: .lightGray, transition: .crossDissolve(0.25))
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.05) { [self] in
            ordinaryVendorsTAbleView.hideSkeleton()
            ordinaryVendorsTAbleView.showAnimatedSkeleton(usingColor: .lightGray, transition: .crossDissolve(0.25))
            loadOrdinaryTable(identifier: OrdinaryVendorsSkeletonTableViewCell.identifier)
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
//        guard let categories = self.categories else { return }
//        var list = [String]()
//        categories.forEach { category in
//            list.append(("lang".localized == "en" ? category.name?.en : category.name?.ar)!)
//        }
//       // Router.toChooser(self, "lang".localized == "en" ? list : list.reversed())
//        Router.toChooser(self, list)
        Router.toChooseCategory(self, self, "lang".localized == "ar" ? categories!.reversed() : categories!)
    }
    
    func selectCategory(index: Int){
        guard !self.categories!.isEmpty else { return }
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
        filtersCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: ("lang".localized == "en" ? .left : .right), animated: true)
    }
    
    
}
