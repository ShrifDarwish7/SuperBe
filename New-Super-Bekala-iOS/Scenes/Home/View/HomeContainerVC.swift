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
    
    @IBOutlet weak var addView: UIView!
    
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var coverViewCnst: NSLayoutConstraint!
    @IBOutlet weak var tabTitle: UILabel!
    
    @IBOutlet weak var shoppingContainer: UIView!
    @IBOutlet weak var offersContainer: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cartFlage: ViewCorners!
    
    var cartItems: [CartItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addView.layer.cornerRadius = 10
        coverViewCnst.constant = self.view.frame.width - (self.view.frame.width*0.43)
        coverView.roundCorners([.layerMaxXMinYCorner,.layerMaxXMaxYCorner], radius: self.coverView.frame.height/2)
        
        self.replaceView(identifier: "ShoopingVC", storyboard: .home)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        CartServices.shared.getCartItems(itemId: -1, branch: -1) { [self] (items) in
            self.cartItems = items
            if let items = items,
               !items.isEmpty{
                cartFlage.isHidden = false
            }else{
                cartFlage.isHidden = true
            }
        }
    }
    
    @IBAction func toCart(_ sender: Any) {
        CartServices.shared.getCartItems(itemId: -1, branch: -1) { [self] (items) in
            if let items = items,
               items.isEmpty{
                showToast("Your cart is empty")
            }else{
                Router.toCart(self)
            }
        }
    }
  
    @IBAction func TabsActions(_ sender: UIButton) {
        
        shoopingTab.isHidden = true
        offersTab.isHidden = true
        ordersTab.isHidden = true
        favouriteTab.isHidden = true
        
//        shoppingContainer.isHidden = true
//        offersContainer.isHidden = true
        
        shoopingTabBtn.setImage(UIImage(named: "shooping-unselect"), for: .normal)
        offersTabBtn.setImage(UIImage(named: "offers-unselect"), for: .normal)
        ordersTabBtn.setImage(UIImage(named: "last-orders-unselect"), for: .normal)
        favouriteTabBtn.setImage(UIImage(named: "favourites-unselect"), for: .normal)
        
        switch sender.tag {
            
        case 0:
            
            shoopingTab.isHidden = false
            //shoppingContainer.isHidden = false
            self.replaceView(identifier: "ShoopingVC", storyboard: .home)
            shoopingTabBtn.setImage(UIImage(named: "shooping-select"), for: .normal)
            tabTitle.text = "Shooping"
                  minimizeCover()
            
        case 1:
            
            offersTab.isHidden = false
           // offersContainer.isHidden = false
            self.replaceView(identifier: "OffersVC", storyboard: .home)
            offersTabBtn.setImage(UIImage(named: "offers-select"), for: .normal)
            tabTitle.text = "Offers"
            minimizeCover()
            
        case 2:
            
            ordersTab.isHidden = false
            ordersTabBtn.setImage(UIImage(named: "last-orders-select"), for: .normal)
            tabTitle.text = "Last orders"
            expandCover()
            self.replaceView(identifier: "LastOrderVC", storyboard: .orders)
            
        case 3:
            
            favouriteTab.isHidden = false
            favouriteTabBtn.setImage(UIImage(named: "favourites-select"), for: .normal)
            tabTitle.text = "Favourites"
            expandCover()
            
        default:
            break
        }
        
        
    }
    
    func expandCover(){
        
        self.coverViewCnst.constant = -50
        self.view.layoutIfNeeded()
        
//        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
//            
//            self.coverViewCnst.constant = -50
//            self.view.layoutIfNeeded()
//            
//        }) { (_) in
//            
//        }
    }
    
    func minimizeCover(){
        
        self.coverViewCnst.constant = self.view.frame.width - (self.view.frame.width*0.43)
        self.view.layoutIfNeeded()
        
//        UIView.animate(withDuration: 0.4
//            , delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
//
//            self.coverViewCnst.constant = self.view.frame.width - (self.view.frame.width*0.43)
//            self.view.layoutIfNeeded()
//
//        }) { (_) in
//
//        }
        
    }
    
    func replaceView(identifier: String, storyboard: AppStoryboard) {
        containerView.subviews.forEach({ $0.removeFromSuperview() })
        let vc =
       // self.storyboard!.instantiateViewController(withIdentifier: identifier)
        Router.instantiate(appStoryboard: storyboard, identifier: identifier)
        vc.view.frame = self.containerView.bounds;
        containerView.addSubview(vc.view)
        self.addChild(vc)
        vc.didMove(toParent: self)
    }
    
}
