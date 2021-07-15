//
//  HomeContainerVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Super Bekala on 7/12/20.
//  Copyright © 2020 Super Bekala. All rights reserved.
//

import UIKit

class HomeContainerVC: UIViewController {


    @IBOutlet weak var shoopingTabBtn: UIButton!
    @IBOutlet weak var offersTabBtn: UIButton!
    @IBOutlet weak var ordersTabBtn: UIButton!
    @IBOutlet weak var favouriteTabBtn: UIButton!
    
    @IBOutlet weak var shoopingTab: UILabel!
    @IBOutlet weak var offersTab: UILabel!
    @IBOutlet weak var ordersTab: UILabel!
    @IBOutlet weak var favouriteTab: UILabel!
    @IBOutlet weak var profilePic: CircluarImage!
    
    @IBOutlet weak var addView: UIView!
    
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var coverViewCnst: NSLayoutConstraint!
    @IBOutlet weak var tabTitle: UILabel!
    @IBOutlet weak var moreOptionsStack: UIStackView!
    
    @IBOutlet weak var shoppingContainer: UIView!
    @IBOutlet weak var offersContainer: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cartFlage: ViewCorners!
    @IBOutlet weak var orderMethodsView: UIView!
    @IBOutlet weak var blockBlurView: UIVisualEffectView!
    @IBOutlet weak var contactUsView: UIView!
    @IBOutlet weak var changeLocationBlockView: UIView!
    @IBOutlet weak var locationSheetTopCnst: NSLayoutConstraint!
    @IBOutlet weak var addressesContainer: UIView!
    @IBOutlet weak var profileImage: CircluarImage!
    
    var cartItems: [CartItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.kf.setImage(with: URL(string: Shared.storageBase + APIServices.shared.user!.avatar))
        
        NotificationCenter.default.addObserver(self, selector: #selector(didChooseAddress), name: NSNotification.Name("DID_CHOOSE_ADDRESS"), object: nil)
        
        orderMethodsView.transform = CGAffineTransform(scaleX: 0, y: 0)
        addView.layer.cornerRadius = 10
        coverViewCnst.constant = self.view.frame.width - (self.view.frame.width*0.43)
        coverView.roundCorners([.layerMaxXMinYCorner,.layerMaxXMaxYCorner], radius: self.coverView.frame.height/2)
        
        self.replaceView(containerView: containerView, identifier: "ShoopingVC", storyboard: .home)
        
        self.dismissChangeLocationSheet()
        
        profileImage.addTapGesture { (_) in
            Router.toProfile(self)
        }
        
        blockBlurView.addTapGesture { (_) in
            self.dismissOrderMethodsView()
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        CartServices.shared.getCartItems(itemId: "-1", branch: -1) { [self] (items) in
            self.cartItems = items
            if let items = items,
               !items.isEmpty{
                cartFlage.isHidden = false
            }else{
                cartFlage.isHidden = true
            }
        }
    }
    
    @IBAction func toQuickOrder(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            Shared.selectedServices = .voice
        case 1:
            Shared.selectedServices = .text
        case 2:
            Shared.selectedServices = .images
        default:
            break
        }
        Router.toShareLocation(self)
    }
    
    
    @objc func didChooseAddress(){
        self.dismissChangeLocationSheet()
        self.replaceView(containerView: containerView, identifier: "ShoopingVC", storyboard: .home)
    }
    
    @IBAction func changeLocation(_ sender: Any) {
        self.showChangeLocationSheet()
    }
    
    @IBAction func dismissSheet(_ sender: Any) {
        self.dismissChangeLocationSheet()
    }
    
    func showChangeLocationSheet(){
        self.replaceView(containerView: self.addressesContainer, identifier: "ChangeLocationVC", storyboard: .profile)
        changeLocationBlockView.isHidden = false
        locationSheetTopCnst.constant = 350
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: []) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            
        }
    }
    
    func dismissChangeLocationSheet(){
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: []) {
            self.locationSheetTopCnst.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.changeLocationBlockView.isHidden = true
        }
    }
    
    @IBAction func addOrderAction(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            sender.tag = 1
            showOrderMethodsView()
        case 1:
            sender.tag = 0
            dismissOrderMethodsView()
        default:
            break
        }
    }
    
    func showOrderMethodsView(){
        
        self.blockBlurView.isHidden = false
        self.orderMethodsView.isHidden = false
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            
            self.blockBlurView.alpha = 1
            self.orderMethodsView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.addView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.orderMethodsView.alpha = 1
            
        }) { (_) in
            
        }
        
    }
    
    func dismissOrderMethodsView(){
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            
            self.blockBlurView.alpha = 0
            self.orderMethodsView.alpha = 0
            self.addView.transform = CGAffineTransform(scaleX: 1, y: 1)
            
        }) { (_) in
        
            self.blockBlurView.isHidden = true
            self.orderMethodsView.isHidden = true
            self.orderMethodsView.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
        
    }
    
    @IBAction func toCart(_ sender: Any) {
        CartServices.shared.getCartItems(itemId: "-1", branch: -1) { [self] (items) in
            if let items = items,
               items.isEmpty{
                showToast("Your cart is empty")
            }else{
                Router.toCart(self)
            }
        }
    }
    
    @IBAction func showMoreOptiions(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            expandCover()
            sender.tag = 1
        case 1:
            minimizeCover()
            sender.tag = 0
        default:
            break
        }
    }
    
    @IBAction func dismissContactUs(_ sender: Any) {
        UIView.animate(withDuration: 0.2) {
            self.contactUsView.alpha = 0
        } completion: { (_) in
            self.contactUsView.isHidden = true
        }

    }
    
    @IBAction func showContactUs(_ sender: Any) {
        self.contactUsView.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.contactUsView.alpha = 1
        }
    }
    
    
    @IBAction func TabsActions(_ sender: UIButton) {
        
        shoopingTab.isHidden = true
        offersTab.isHidden = true
        ordersTab.isHidden = true
        favouriteTab.isHidden = true
        
        shoopingTabBtn.setImage(UIImage(named: "shooping-unselect"), for: .normal)
        offersTabBtn.setImage(UIImage(named: "offers-unselect"), for: .normal)
        ordersTabBtn.setImage(UIImage(named: "last-orders-unselect"), for: .normal)
        favouriteTabBtn.setImage(UIImage(named: "favourites-unselect"), for: .normal)
        
        switch sender.tag {
            
        case 0:
            
            shoopingTab.isHidden = false
            self.replaceView(containerView: containerView, identifier: "ShoopingVC", storyboard: .home)
            shoopingTabBtn.setImage(UIImage(named: "shooping-select"), for: .normal)
            tabTitle.text = "Shooping"
            
        case 1:
            
            offersTab.isHidden = false
            self.replaceView(containerView: containerView, identifier: "OffersVC", storyboard: .home)
            offersTabBtn.setImage(UIImage(named: "offers-select"), for: .normal)
            tabTitle.text = "Offers"
            
        case 2:
            
            ordersTab.isHidden = false
            ordersTabBtn.setImage(UIImage(named: "last-orders-select"), for: .normal)
            tabTitle.text = "Last orders"
            self.replaceView(containerView: containerView, identifier: "LastOrderVC", storyboard: .orders)
            
        case 3:
            
            favouriteTab.isHidden = false
            favouriteTabBtn.setImage(UIImage(named: "favourites-select"), for: .normal)
            tabTitle.text = "Favourites"
            self.replaceView(containerView: containerView, identifier: "FavouritesVC", storyboard: .profile)
            
        default:
            break
        }
        
        
    }
    
    func expandCover(){
        
        self.coverViewCnst.constant = -50
        self.moreOptionsStack.isHidden = false
        self.tabTitle.isHidden = true
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [], animations: {
            
            self.view.layoutIfNeeded()
            
        }) { (_) in
            
        }
    }
    
    func minimizeCover(){
        
        self.coverViewCnst.constant = self.view.frame.width - (self.view.frame.width*0.43)
        self.moreOptionsStack.isHidden = true
        self.tabTitle.isHidden = false
        
        UIView.animate(withDuration: 0.4
                       , delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [], animations: {

            self.view.layoutIfNeeded()

        }) { (_) in

        }
        
    }
    
    @IBAction func toSearch(_ sender: Any) {
        Router.toSearch(self)
    }
    
    
    
}
