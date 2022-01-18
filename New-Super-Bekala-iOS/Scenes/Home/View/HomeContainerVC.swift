//
//  HomeContainerVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Super Bekala on 7/12/20.
//  Copyright © 2020 Super Bekala. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeContainerVC: UIViewController, LoginDelegate {
    
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
    @IBOutlet weak var deliveryLocationTitle: UILabel!
    @IBOutlet weak var profileHintView: UIView!
    @IBOutlet weak var profileHintTopCnst: NSLayoutConstraint!
    @IBOutlet weak var serviceHintView: UIView!
    @IBOutlet weak var serviceHintBottomCnst: NSLayoutConstraint!
    
   // var cartItems: [CartItem]?
    var selectedTab = Tabs.shooping
   // var shouldShowCats = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didChooseAddress), name: NSNotification.Name("DID_CHOOSE_ADDRESS"), object: nil)

        orderMethodsView.transform = CGAffineTransform(scaleX: 0, y: 0)
        addView.layer.cornerRadius = 10
        coverViewCnst.constant = self.view.frame.width - (self.view.frame.width*0.5)
        if "lang".localized == "en"{
            coverView.roundCorners([.layerMaxXMinYCorner,.layerMaxXMaxYCorner], radius: self.coverView.frame.height/2)
        }else{
            coverView.roundCorners([.layerMinXMinYCorner,.layerMinXMaxYCorner], radius: self.coverView.frame.height/2)
        }
        
        if let lastVC = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)!-2],
           lastVC.isKind(of: OrderPlacedVC.self) == true || lastVC.isKind(of: ServicesCheckoutVC.self) == true{
            shoopingTab.isHidden = true
            offersTab.isHidden = true
            favouriteTab.isHidden = true
            
            shoopingTabBtn.setImage(UIImage(named: "shooping-unselect"), for: .normal)
            offersTabBtn.setImage(UIImage(named: "offers-unselect"), for: .normal)
            favouriteTabBtn.setImage(UIImage(named: "favourites-unselect"), for: .normal)
            ordersTab.isHidden = false
            ordersTabBtn.setImage(UIImage(named: "last-orders-select"), for: .normal)
            
            guard selectedTab != .orders else {
                NotificationCenter.default.post(name: NSNotification.Name("SCROLL_TO_TOP"), object: nil, userInfo: nil)
                return
            }
            
            tabTitle.text = "Last Orders".localized
            self.replaceView(containerView: containerView, identifier: "LastOrderVC", storyboard: .orders)
            selectedTab = .orders
        
        }else{
            self.replaceView(containerView: containerView, identifier: "ShoopingNav", storyboard: .home)
        }
                
        profileImage.addTapGesture { (_) in
            if APIServices.shared.isLogged{
                let presenter = LoginViewPresenter(loginViewDelegate: self)
                SVProgressHUD.show()
                presenter.getProfile()
            }else{
                Router.toRegister(self)
            }
        }
        
        blockBlurView.addTapGesture { (_) in
            self.dismissOrderMethodsView()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) { [self] in
            if !Shared.didGetProfileHint{
                shakeProfileHint()
                profileHintView.isHidden = false
            }else{
                profileHintView.isHidden = true
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if !APIServices.shared.isLogged{
            profileImage.image = UIImage(systemName: "person.fill")
        }else{
            profileImage.kf.setImage(with: URL(string: Shared.storageBase + (APIServices.shared.user?.avatar ?? "")))
        }
        deliveryLocationTitle.text = Shared.deliveringToTitle
        CartServices.shared.getCartBranches(id: nil) { [self] branches in
            if let branches = branches, !branches.isEmpty {
                cartFlage.isHidden = false
            }else{
                cartFlage.isHidden = true
            }
        }
    }
    
    func shakeProfileHint(){
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
            UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction]) { [self] in
                profileHintTopCnst.constant = 30
                view.layoutIfNeeded()
            } completion: { [self] _ in
                UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction]) {
                    profileHintTopCnst.constant = 15
                    view.layoutIfNeeded()
                }
            }
        }
    }
    
    func shakeServiceHint(){
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
            UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction]) { [self] in
                serviceHintBottomCnst.constant = 30
                view.layoutIfNeeded()
            } completion: { [self] _ in
                UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction]) {
                    serviceHintBottomCnst.constant = 15
                    view.layoutIfNeeded()
                }
            }
        }
    }
    
    @IBAction func dismissProfileHint(_ sender: Any) {
        Shared.didGetProfileHint = true
        UIView.animate(withDuration: 0.2) { [self] in
            profileHintView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        } completion: { [self] _ in
            profileHintView.isHidden = true
            serviceHintView.isHidden = false
            shakeServiceHint()
        }
    }
    
    @IBAction func dismissServiceHint(_ sender: Any) {
        Shared.didGetServiceHint = true
        UIView.animate(withDuration: 0.2) { [self] in
            serviceHintView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        } completion: { [self] _ in
            serviceHintView.isHidden = true
        }
    }
    
    
    func onLogin() {
        self.selectShooping()
        self.replaceView(containerView: containerView, identifier: "ShoopingNav", storyboard: .home)
        profileImage.kf.setImage(with: URL(string: Shared.storageBase + (APIServices.shared.user?.avatar ?? "")))
    }
    
    func onLogout() {
        self.selectShooping()
        self.replaceView(containerView: containerView, identifier: "ShoopingNav", storyboard: .home)
        profileImage.image = UIImage(systemName: "person.fill")
    }
    
    func selectShooping(){
        offersTab.isHidden = true
        ordersTab.isHidden = true
        favouriteTab.isHidden = true
        offersTabBtn.setImage(UIImage(named: "offers-unselect"), for: .normal)
        ordersTabBtn.setImage(UIImage(named: "last-orders-unselect"), for: .normal)
        favouriteTabBtn.setImage(UIImage(named: "favourites-unselect"), for: .normal)
        shoopingTab.isHidden = false
        shoopingTabBtn.setImage(UIImage(named: "shooping-select"), for: .normal)
        tabTitle.text = "Shooping".localized
        selectedTab = .shooping
    }
    
    @IBAction func toProfile(_ sender: Any) {
        let presenter = LoginViewPresenter(loginViewDelegate: self)
        presenter.getProfile()
    }
    
    @IBAction func toChat(_ sender: Any) {
        guard Shared.isChatting == false else {
            showAlert(title: "", message: "Please first close your current conversation session to start new one".localized)
            return
        }
        let presenter = MainPresenter(self)
        presenter.startConversation()
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
        deliveryLocationTitle.text = Shared.deliveringToTitle
        self.replaceView(containerView: containerView, identifier: "ShoopingNav", storyboard: .home)
    }
    
    @IBAction func changeLocation(_ sender: Any) {
        Router.toChangeLocation(self)
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
        CartServices.shared.getCartBranches(id: nil) { branches in
            if let branches = branches, !branches.isEmpty {
                Router.toCart(self)
            }else{
                self.showToast("Your cart is empty".localized)
            }
        }
//        CartServices.shared.getCartItems(itemId: "-1", branch: -1) { [self] (items) in
//            if let items = items,
//               !items.isEmpty{
//                Router.toCart(self)
//            }else{
//                showToast("Your cart is empty".localized)
//            }
//        }
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
        
        switch sender.tag {
        case 2,3:
            guard APIServices.shared.isLogged else{
                Router.toRegister(self)
                return
            }
        default: break
        }
        
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
            shoopingTabBtn.setImage(UIImage(named: "shooping-select"), for: .normal)
            
            guard selectedTab != .shooping else {
                NotificationCenter.default.post(name: NSNotification.Name("SCROLL_TO_TOP"), object: nil, userInfo: nil)
                return
            }
            
            self.replaceView(containerView: containerView, identifier: "ShoopingNav", storyboard: .home)
            
            tabTitle.text = "Shooping".localized
            selectedTab = .shooping
            
        case 1:
                        
            offersTab.isHidden = false
            offersTabBtn.setImage(UIImage(named: "offers-select"), for: .normal)
            
            guard selectedTab != .offers else {
                NotificationCenter.default.post(name: NSNotification.Name("SCROLL_TO_TOP"), object: nil, userInfo: nil)
                return
            }
            
            self.replaceView(containerView: containerView, identifier: "OffersVC", storyboard: .home)
            
            tabTitle.text = "Offers".localized
            selectedTab = .offers
            
        case 2:
            
            ordersTab.isHidden = false
            ordersTabBtn.setImage(UIImage(named: "last-orders-select"), for: .normal)
            
            guard selectedTab != .orders else {
                NotificationCenter.default.post(name: NSNotification.Name("SCROLL_TO_TOP"), object: nil, userInfo: nil)
                return
            }
            
            tabTitle.text = "Last Orders".localized
            self.replaceView(containerView: containerView, identifier: "LastOrderVC", storyboard: .orders)
            selectedTab = .orders
            
        case 3:
            
            favouriteTab.isHidden = false
            favouriteTabBtn.setImage(UIImage(named: "favourites-select"), for: .normal)
            
            guard selectedTab != .favourite else {
                NotificationCenter.default.post(name: NSNotification.Name("SCROLL_TO_TOP"), object: nil, userInfo: nil)
                return
            }
            
            tabTitle.text = "Favourite".localized
            self.replaceView(containerView: containerView, identifier: "FavouritesVC", storyboard: .profile)
            selectedTab = .favourite
            
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

enum Tabs{
    case shooping
    case offers
    case orders
    case favourite
}

extension HomeContainerVC: MainViewDelegate{
    func didCompleteStartConversation(_ Id: Int?) {
        if let id = Id{
            Shared.currentConversationId = id
            Router.toChat(self)
        }
    }
}

extension HomeContainerVC: LoginViewDelegate{
    func didCompleteWithProfile(_ error: String?) {
        SVProgressHUD.dismiss()
        if let err = error{
            showToast(err)
        }else{
            Router.toProfile(self)
        }
    }
}
