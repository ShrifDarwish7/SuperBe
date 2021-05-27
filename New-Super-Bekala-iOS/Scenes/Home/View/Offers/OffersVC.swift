//
//  OffersVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Super Bekala on 8/10/20.
//  Copyright © 2020 Super Bekala. All rights reserved.
//

import UIKit

class OffersVC: UIViewController {

    @IBOutlet weak var specialOffersCollection: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var specialOffersStack: UIStackView!
    @IBOutlet weak var filtersCollection: UICollectionView!
    @IBOutlet weak var offersTableView: UITableView!
    @IBOutlet weak var stackHeightCnst: NSLayoutConstraint!
    @IBOutlet weak var specialOffersView: UIView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    var presenter: MainPresenter?
    var cartItems: [CartItem]?
    var parameters: [String:String] = [:]
    var selectedCategory: Category?
    var branches: [Branch]?{
        didSet{
            self.isLoading = false
            self.offersTableView.hideSkeleton()
            self.loadTbl()
        }
    }
    var isLoading = true
    var categories: [Category]?{
        didSet{
            self.loadFiltersCollection()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MainPresenter(self)
        
        if Shared.isRegion{
            parameters.updateValue("\(Shared.selectedArea.regionsID ?? 0)", forKey: "region_id")
            if Shared.selectedArea.subregionID != 0{
                parameters.updateValue("\(Shared.selectedArea.subregionID ?? 0)", forKey: "subregion_id")
            }
        }else if Shared.isCoords{
            parameters.updateValue(Shared.selectedCoords, forKey: "coordinates")
        }
        self.presenter?.getCategories(parameters)
        showSkeletonView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        CartServices.shared.getCartItems(itemId: "-1", branch: -1) { [self] (items) in
            self.cartItems = items
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tableHeight.constant = offersTableView.contentSize.height + 20
        self.offersTableView.isScrollEnabled = false
        self.view.layoutIfNeeded()
    }
   
    override func viewDidLayoutSubviews() {
        super.updateViewConstraints()
        self.tableHeight.constant = offersTableView.contentSize.height + 20
        self.offersTableView.isScrollEnabled = false
        self.view.layoutIfNeeded()
    }
    
    func showSkeletonView(){
        
        offersTableView.hideSkeleton()
        
        isLoading = true
        
        loadTbl()
        
        offersTableView.isSkeletonable = true
        
        offersTableView.showAnimatedSkeleton(usingColor: .lightGray, transition: .crossDissolve(0.25))
        
    }
    
//    func loadSpecialOffersCollection(){
//
//        specialOffersCollection.numberOfItemsInSection { (_) -> Int in
//            return 1
//        }.cellForItemAt { (index) -> UICollectionViewCell in
//
//            let cell = self.specialOffersCollection.dequeueReusableCell(withReuseIdentifier: "SpecialOffersCell", for: index) as! SpecialOffersCollectionViewCell
//            return cell
//
//        }
//
//    }
    

}
