//
//  BranchVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 29/03/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import Cosmos

class BranchVC: UIViewController, ChooserDelegate {

    @IBOutlet weak var fastOrderContainer: ViewCorners!
    @IBOutlet weak var branchLogoContainer: ViewCorners!
    @IBOutlet weak var logoXPosition: NSLayoutConstraint!
    @IBOutlet weak var fastOrderXPosition: NSLayoutConstraint!
    @IBOutlet weak var fastOrderOptionsView: UIStackView!
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
    @IBOutlet weak var branchName: UILabel!
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var minimumOrder: UILabel!
    @IBOutlet weak var fees: UILabel!
    @IBOutlet weak var cartFlage: ViewCorners!
    @IBOutlet weak var replacableView: UIView!
    @IBOutlet weak var reviewsCount: UILabel!
    @IBOutlet weak var categoriesBtn: UIButton!
    @IBOutlet weak var couponDesc: UILabel!
    @IBOutlet weak var couponStack: UIStackView!
    @IBOutlet weak var couponBtn: RoundedButton!
    @IBOutlet weak var couponView: ViewCorners!
    @IBOutlet weak var notFoundStack: UIStackView!
    @IBOutlet weak var favouriteBtn: UIButton!
    @IBOutlet weak var infoStack: UIStackView!
    
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
        
        if let favs = Shared.favBranches,
           !favs.isEmpty,
           !favs.filter({ return $0.id == self.branch!.id }).isEmpty{
            favouriteBtn.setImage(UIImage(named: "favourite"), for: .normal)
            favouriteBtn.tag = 1
        }else{
            favouriteBtn.setImage(UIImage(named: "unfavourite"), for: .normal)
        }
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchCartItems()
    }
    
    func onChoose(_ index: Int) {
        self.selectCategory(index: index)
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
            let contentOffset = productsCollectionView.contentOffset
            self.loadProductsCollection()
            productsCollectionView.setContentOffset(contentOffset, animated: true)
        }
    }
    
    func initUI(){
        
        reviewsCount.isHidden = (branch?.reviewCount ?? 0) > 0 ? false : true
        reviewsCount.text = "(\(branch?.reviewCount ?? 0))"
        
        fastOrderContainer.alpha = 0.5
        fastOrderXPosition.constant = self.view.frame.width/4
        fastOrderContainer.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        self.view.layoutIfNeeded()
        
        filtersCollectionView.isSkeletonable = true
        filtersCollectionView.showAnimatedSkeleton(usingColor: .lightGray, transition: .crossDissolve(0.25))
        
        productsCollectionView.isSkeletonable = true
        productsCollectionView.showAnimatedSkeleton(usingColor: .lightGray, transition: .crossDissolve(0.25))

        fastOrderOptionsView.isHidden = branch?.quickOrder == 0 ? true : false
        rateView.rating = Double(branch?.rating ?? "0.0")!
        branchName.text = "lang".localized == "en" ? branch?.name?.en : branch?.name?.ar
        
        logo.kf.indicatorType = .activity
        logo.kf.setImage(with: URL(string: Shared.storageBase + (branch?.logo)!), placeholder: nil, options: [], completionHandler: nil)
        bgLogo.kf.setImage(with: URL(string: Shared.storageBase + (branch?.logo)!), placeholder: nil, options: [], completionHandler: nil)
        
        duration.text = "\(branch?.deliveryDuration ?? 0) Min"
        minimumOrder.text = "\(branch?.minOrder ?? 0) EGP"
        fees.text = "\(branch?.deliveryFees ?? 0 ) EGP"
        
        productsViewHeight.constant = infoStack.frame.height
        view.layoutIfNeeded()
        
        if let coupons = branch?.coupons,
           !coupons.isEmpty{
            couponView.isHidden = false
            if let nameEn = coupons.first?.name?.en,
               let nameAr = coupons.first?.name?.ar{
                couponDesc.text = "lang".localized == "en" ? nameEn : nameAr
            }else{
                couponDesc.text = coupons.first?.name?.ar
            }
            branch!.coupons![0].branch = branch!.id
            if Shared.coupons.filter({ $0.branch == branch?.id }).isEmpty{
                couponBtn.setTitle("TAP TO USE COUPON".localized, for: .normal)
            }else{
                couponBtn.setTitle("Coupon Applied".localized, for: .normal)
            }
        }else{
            couponView.isHidden = true
        }
    }
    
    @IBAction func favouriteAction(_ sender: UIButton){
        switch sender.tag {
        case 0:
            let prms = [
                "model_id": "\(branch!.id)",
                "model": "Branch"
            ]
            favouriteBtn.setImage(UIImage(named: "favourite"), for: .normal)
            self.presenter?.addToFavourite(prms, nil, nil)
        case 1:
            favouriteBtn.setImage(UIImage(named: "unfavourite"), for: .normal)
            guard let favs = Shared.favBranches, !favs.isEmpty else { return }
            guard let favId = favs.filter({ return $0.id == branch!.id}).first?.favouriteId else { return }
            self.presenter?.removeFromFavourites(favId, nil, nil)
        default:
            break
        }
    }
    
    @IBAction func useCouponAction(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            var desc = ""
            if let nameEn = branch?.coupons?.first?.couponResponseDescription?.en,
               let nameAr = branch?.coupons?.first?.couponResponseDescription?.ar{
                desc = "lang".localized == "en" ? nameEn : nameAr
            }else{
                desc = (branch?.coupons?.first?.couponResponseDescription?.ar) ?? ""
            }
            let alert = UIAlertController(title: "", message: desc, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Apply".localized, style: .default, handler: { [self] _ in
                Shared.coupons.append((branch?.coupons?.first)!)
                sender.tag = 1
                sender.setTitle("Coupon Applied".localized, for: .normal)
            }))
            alert.addAction(UIAlertAction(title: "Cancel".localized, style: .destructive, handler: nil))
            present(alert, animated: true, completion: nil)
        default: break
        }
    }
    
    @IBAction func toImageOrder(_ sender: Any) {
        Router.toImagesOrder(self, branch!)
    }
    
    @IBAction func dismissProduct(_ sender: Any) {
        self.productsViewHeight.constant = self.view.frame.height * 0.5
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func toSearchAction(_ sender: Any) {
        Router.toSearch(self, branch?.id)
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
                showToast("Cart of this vendor is empty".localized)
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
            self.replacableView.isHidden = true
        case 1:
            self.allLbl.isHidden = false
            replacableView.isHidden = false
        
            self.replaceView(containerView: replacableView, identifier: "InfoVC", storyboard: .home)
            NotificationCenter.default.post(name: NSNotification.Name("SEND_BRANCH"), object: nil, userInfo: ["branch": self.branch!])
            
        case 2:
            self.offersLbl.isHidden = false
        case 3:
            replacableView.isHidden = false
            self.ratesLbl.isHidden = false
            self.replaceView(containerView: replacableView, identifier: "RatingsVC", storyboard: .other)
            NotificationCenter.default.post(name: NSNotification.Name("SEND_BRANCH"), object: nil, userInfo: ["branch": self.branch!])
            
        default:
            break
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        
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
        print(index)
        notFoundStack.isHidden = true
        for i in 0...self.categories!.count-1 { self.categories![i].selected = false }
        self.categories![index].selected = true
        self.selectedCat = self.categories![index]
        
        loadFiltersCollection()
       // self.filtersCollectionView.reloadData()
        filtersCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: "lang".localized == "en" ? .left : .right , animated: true)
        isLoading = true
//
//        if "lang".localized == "ar"{
//            filtersCollectionView.semanticContentAttribute = .forceRightToLeft
//        }
        //productsCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        productsCollectionView.showAnimatedSkeleton(usingColor: .lightGray, transition: .crossDissolve(0.25))
        loadProductsCollection()
        prms.updateValue("branch_category_id=\(self.selectedCat?.id ?? 0)", forKey: "filter")
        presenter?.getBranchProduct(id: branch!.id, prms: prms)
    }
    

}
