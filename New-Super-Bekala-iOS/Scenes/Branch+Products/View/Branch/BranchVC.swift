//
//  BranchVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 29/03/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import Cosmos

class BranchVC: UIViewController {

    @IBOutlet weak var fastOrderContainer: ViewCorners!
    @IBOutlet weak var branchLogoContainer: ViewCorners!
    @IBOutlet weak var logoXPosition: NSLayoutConstraint!
    @IBOutlet weak var fastOrderXPosition: NSLayoutConstraint!
    @IBOutlet weak var fastOrderOptionsView: UIView!
    @IBOutlet weak var branchInfoStack: UIStackView!
    @IBOutlet weak var popularLbl: UILabel!
    @IBOutlet weak var allLbl: UILabel!
    @IBOutlet weak var offersLbl: UILabel!
    @IBOutlet weak var ratesLbl: UILabel!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    //@IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var productsViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var productsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var bgLogo: UIImageView!
    @IBOutlet weak var branchStatus: UILabel!
    @IBOutlet weak var branchName: UILabel!
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var minimumOrder: UILabel!
    @IBOutlet weak var fees: UILabel!
    @IBOutlet weak var cartFlage: ViewCorners!
    
    var bottomSheetPanStartingTopConstant : CGFloat = 30.0
    var categories: [BranchCategory]?
    var selectedCat: BranchCategory?
    var presenter: MainPresenter?
    var branch: Branch?
    var products: [Product]?
    var isLoading: Bool = true
    var prms: [String: String] = [:]
    var cartItems: [CartItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProductsCollection()
        presenter = MainPresenter(self)
        initUI()
        presenter?.getBranchCats(prms: [:], id: branch!.id)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchCartItems()
    }
    
    func fetchCartItems(){
        CartServices.shared.getCartItems(itemId: "-1", branch: self.branch!.id) { [self] (items) in
            self.cartItems = items
            if let items = items,
               !items.isEmpty{
                cartFlage.isHidden = false
            }else{
                cartFlage.isHidden = true
            }
            self.loadProductsCollection()
        }
    }
    
    func initUI(){
        fastOrderContainer.alpha = 0.5
        fastOrderXPosition.constant = self.view.frame.width/4
        fastOrderContainer.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        productsViewHeight.constant = self.view.frame.height / 2
        self.view.layoutIfNeeded()
        
        filtersCollectionView.isSkeletonable = true
        filtersCollectionView.showAnimatedSkeleton(usingColor: .lightGray, transition: .crossDissolve(0.25))
        
        productsCollectionView.isSkeletonable = true
        productsCollectionView.showAnimatedSkeleton(usingColor: .lightGray, transition: .crossDissolve(0.25))

        fastOrderContainer.isHidden = branch?.quickOrder == 1 ? true : false
        rateView.rating = branch?.rating ?? 1.0
        branchName.text = "lang".localized == "en" ? branch?.name?.en : branch?.name?.ar
        logo.sd_setImage(with: URL(string: Shared.storageBase + (branch?.logo)!))
        bgLogo.sd_setImage(with: URL(string: Shared.storageBase + (branch?.logo)!))
        duration.text = "\(branch?.deliveryDuration ?? 0) Min"
        minimumOrder.text = "\(branch?.minOrder ?? 0) EGP"
        fees.text = "\(branch?.deliveryFees ?? 0 ) EGP"
    }
    
    @IBAction func toImageOrder(_ sender: Any) {
        Router.toImagesOrder(self, branch!)
    }
    
    @IBAction func toVoiceOrder(_ sender: Any) {
        Router.toVoiceOrder(self, branch!)
    }
    
    @IBAction func toTextOrder(_ sender: Any) {
        Router.toTextOrder(self, branch!)
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func toCart(_ sender: Any) {
        CartServices.shared.getCartItems(itemId: "-1", branch: self.branch!.id) { [self] (items) in
            if let items = items,
               items.isEmpty{
                showToast("Cart of this vendor is empty")
            }else{
                Router.toCart(self)
            }
        }
    }
    
    @IBAction func logoAnimatedAction(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            UIView.animate(withDuration: 0.5, delay: 0.2) { [self] in
                branchLogoContainer.alpha = 1
                logoXPosition.constant = 0
                branchLogoContainer.transform = CGAffineTransform(scaleX: 1, y: 1)
                fastOrderContainer.alpha = 0.5
                fastOrderXPosition.constant = self.view.frame.width/4
                fastOrderContainer.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                branchInfoStack.isHidden = false
                fastOrderOptionsView.alpha = 0
                branchInfoStack.alpha = 1
                self.view.layoutIfNeeded()
            } completion: { [self] (_) in
                fastOrderOptionsView.isHidden = true
            }
        case 1:
            UIView.animate(withDuration: 0.5, delay: 0.2) { [self] in
                branchLogoContainer.alpha = 0.5
                logoXPosition.constant = self.view.frame.width/4 * -1
                branchLogoContainer.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                fastOrderContainer.alpha = 1
                fastOrderXPosition.constant = 0
                fastOrderContainer.transform = CGAffineTransform(scaleX: 1, y: 1)
                fastOrderOptionsView.isHidden = false
                fastOrderOptionsView.alpha = 1
                branchInfoStack.alpha = 0
                self.view.layoutIfNeeded()
            } completion: { [self] (_) in
                branchInfoStack.isHidden = true
            }

        default:
            break
        }
   
    }
    
    @IBAction func tabsAction(_ sender: UIButton) {
        self.popularLbl.isHidden = true
        self.allLbl.isHidden = true
        self.offersLbl.isHidden = true
        self.ratesLbl.isHidden = true
        
        switch sender.tag {
        case 0:
            self.popularLbl.isHidden = false
        case 1:
            self.allLbl.isHidden = false
        case 2:
            self.offersLbl.isHidden = false
        case 3:
            self.ratesLbl.isHidden = false
        default:
            break
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    

}
