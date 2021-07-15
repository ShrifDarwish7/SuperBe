//
//  FavouritesVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 05/07/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class FavouritesVC: UIViewController {
    
    @IBOutlet weak var favouritesTableView: UITableView!
    @IBOutlet weak var favouritesViewHeight: NSLayoutConstraint!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var branchesTabView: ViewCorners!
    @IBOutlet weak var productsTabView: ViewCorners!
    
    var branches: [Branch]?
    var products: [Product]?
    var isLoading = true
    var presenter: MainPresenter?
    var query: FavouriteQuery = .branch
    var cartItems: [CartItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MainPresenter(self)
        presenter?.getFavourites()
        
        loadFromNib()
        favouritesTableView.isSkeletonable = true
        showSkeleton()
        
        productsTabView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        CartServices.shared.getCartItems(itemId: "-1", branch: -1) { [self] (items) in
            self.cartItems = items
        }
    }
    
    func showSkeleton(){
        favouritesTableView.hideSkeleton()
        favouritesTableView.showAnimatedSkeleton(usingColor: .lightGray, transition: .crossDissolve(0.25))
    }
    
    func updataUI(){
        switch query {
        case .branch:
            if let branches = self.branches, !branches.isEmpty{
                self.isLoading = false
                emptyView.isHidden = true
                self.loadFromNib()
            }else{
                favouritesTableView.isHidden = true
                emptyView.isHidden = false
            }
        case .product:
            if let products = self.products, !products.isEmpty{
                self.isLoading = false
                emptyView.isHidden = true
                self.loadFromNib()
            }else{
                favouritesTableView.isHidden = true
                emptyView.isHidden = false
            }
        }
    }
    
    
    @IBAction func tabsAction(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            
            branchesTabView.backgroundColor = UIColor(named: "Buttons-Red")
            productsTabView.backgroundColor = UIColor.lightGray
            branchesTabView.alpha = 1
            productsTabView.alpha = 0.5
            self.emptyView.isHidden = true
            self.favouritesTableView.isHidden = false
            self.query = .branch
            UIView.animate(withDuration: 0.2) { [self] in
                productsTabView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                branchesTabView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.view.layoutIfNeeded()
            }
            
        case 1:
            
            productsTabView.backgroundColor = UIColor(named: "Buttons-Red")
            branchesTabView.backgroundColor = UIColor.lightGray
            productsTabView.alpha = 1
            branchesTabView.alpha = 0.5
            self.query = .product
            UIView.animate(withDuration: 0.2) { [self] in
                branchesTabView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                productsTabView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.view.layoutIfNeeded()
            }
            
        default:
            break
        }
        updataUI()
    }
    
    @IBAction func reload(_ sender: Any) {
        self.emptyView.isHidden = true
        self.favouritesTableView.isHidden = false
        self.viewDidLoad()
    }
    
}

enum FavouriteQuery: String{
    case branch = "Branch"
    case product = "BranchProduct"
}
