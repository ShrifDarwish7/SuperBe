//
//  ProductVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 01/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import Cosmos

class ProductVC: UIViewController {

    @IBOutlet weak var favouriteBtn: UIButton!
    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var productDesc: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImagesCollectionView: UICollectionView!
    @IBOutlet weak var notesHeight: NSLayoutConstraint!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var notesTV: UITextView!
    @IBOutlet weak var variationTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var variationsTableView: UITableView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var price1: UILabel!
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var expandNotesBTn: UIButton!
    @IBOutlet weak var selectedProductView: UIView!
    @IBOutlet weak var productName1: UILabel!
    @IBOutlet weak var selectedOptions: UILabel!
    @IBOutlet weak var addToCartBtn: ViewCorners!
    @IBOutlet weak var notesView: ViewCorners!
    @IBOutlet weak var salePriceView: UIView!
    @IBOutlet weak var salePrice: UILabel!
    @IBOutlet weak var addedHight: NSLayoutConstraint!
    @IBOutlet weak var addedView: UIView!
    @IBOutlet weak var showCartView: UIView!
    @IBOutlet weak var showCartHeight: NSLayoutConstraint!
    
    let minHeaderViewHeight: CGFloat = UIApplication.shared.statusBarFrame.height
    let maxHeaderViewHeight: CGFloat = 270
    var product: Product?
    var popFlage = false
    var productSelectedTotal = 0.0
    var presenter: MainPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MainPresenter(self)
        
        if let variations = product!.variations,
           !variations.isEmpty{
            product?.variations = variations.filter({ return $0.inStock == 1 })
            self.variationsTableView.isHidden = false
            loadVariationTableView()
            if !(variations.filter({ return $0.isRequired == 1 }).isEmpty){
                self.addToCartBtn.alpha = 0.5
                self.addToCartBtn.tag = 0
            }else{
                self.addToCartBtn.alpha = 1
                self.addToCartBtn.tag = 1
            }
        }else{
            self.addToCartBtn.alpha = 1
            self.addToCartBtn.tag = 1
            self.variationsTableView.isHidden = true
        }
        
        if let salePrice = product?.salePrice,
           salePrice > 0{
            self.salePriceView.isHidden = false
            self.salePrice.text = "\(self.product?.price?.roundToDecimal(2) ?? 0) EGP"
            self.product?.price = salePrice
        }else{
            self.salePriceView.isHidden = true
        }

        productImagesCollectionView.delegate = self
        productImagesCollectionView.dataSource = self
        productImagesCollectionView.reloadData()
        
        product!.images = [product!.logo ?? ""]
        
        pageControl.isHidden = (product?.images?.count ?? 0) > 1 ? false : true
        pageControl.numberOfPages = product?.images?.count ?? 0
        pageControl.onChange { (page) in
            self.productImagesCollectionView.scrollToItem(at: IndexPath(item: page, section: 0), at: .centeredHorizontally, animated: true)
        }
        productName.text = "lang".localized == "en" ? product?.name?.en : product?.name?.ar
        productName1.text = "lang".localized == "en" ? product?.name?.en : product?.name?.ar
        
        productDesc.text = "lang".localized == "en" ? product?.description?.en : product?.description?.ar
        price.isHidden = product?.price == 0 ? true : false
        price.text = "\(product?.price?.roundToDecimal(2) ?? 0) EGP"
        price1.isHidden = product?.price == 0 ? true : false
        price1.text = "\(product?.price?.roundToDecimal(2) ?? 0) EGP"
        
        self.updateUI(nil)
        
        if let favs = Shared.favProducts,
           !favs.isEmpty,
           !favs.filter({ return $0.id == self.product?.id }).isEmpty{
            favouriteBtn.setImage(UIImage(named: "favourite"), for: .normal)
            favouriteBtn.tag = 1
        }else{
            favouriteBtn.setImage(UIImage(named: "unfavourite"), for: .normal)
        }
        
        self.notesHeight.constant = 0
        expandNotesBTn.tag = 0
        notesView.isHidden = true
        UIView.animate(withDuration: 0.2) { [self] in
            expandNotesBTn.transform = CGAffineTransform(rotationAngle: .pi)
        }
        
        showCartHeight.constant = 0
        addedHight.constant = 0
        
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        variationTableViewHeight.constant = variationsTableView.contentSize.height
        self.view.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        super.updateViewConstraints()
        variationTableViewHeight.constant = variationsTableView.contentSize.height 
        self.view.layoutIfNeeded()
    }
    
    
    @IBAction func showCart(_ sender: Any) {
        Router.toCart(self)
        showCartHeight.constant = 0
        showCartView.isHidden = true
    }
    
    @IBAction func back(_ sender: Any) {
//        if popFlage == true{
//            let alert = UIAlertController(title: "Are your sure you want to close?".localized, message: "Going back will clear all of your choises".localized, preferredStyle: .alert)
//            let back = UIAlertAction(title: "Go back".localized, style: .default) { (_) in
//                self.navigationController?.popViewController(animated: true)
//            }
//            let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
//            alert.addAction(back)
//            alert.addAction(cancel)
//            self.present(alert, animated: true, completion: nil)
//        }else{
//            self.navigationController?.popViewController(animated: true)
//        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func favourite(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            let prms = [
                "model_id": "\(self.product!.id!)",
                "model": "BranchProduct"
            ]
            favouriteBtn.setImage(UIImage(named: "favourite"), for: .normal)
            self.presenter?.addToFavourite(prms, nil, nil)
        case 1:
            favouriteBtn.setImage(UIImage(named: "unfavourite"), for: .normal)
            guard let favs = Shared.favProducts, !favs.isEmpty else { return }
            guard let favId = favs.filter({ return $0.id == product!.id}).first?.favouriteId else { return }
            self.presenter?.removeFromFavourites(favId, nil, nil)
        default:
            break
        }
    }
    
    
    @IBAction func openNotes(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            self.notesHeight.constant = 100
            sender.tag = 1
            notesView.isHidden = false
            UIView.animate(withDuration: 0.2) {
                sender.transform = CGAffineTransform(rotationAngle: .pi*2)
            }
            notesTV.becomeFirstResponder()
        case 1:
            self.notesHeight.constant = 0
            sender.tag = 0
            notesView.isHidden = true
            UIView.animate(withDuration: 0.2) {
                sender.transform = CGAffineTransform(rotationAngle: .pi)
            }
            self.view.endEditing(true)
        default:
            break
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        self.view.endEditing(true)
    }
    
    @IBAction func increaseQtyAction(_ sender: Any) {
        guard Int(quantity.text!)! > 0 else {
            return
        }
        quantity.text = "\(Int(quantity.text!)! + 1)"
        updateUI(nil)
    }
    
    @IBAction func decreaseQtyAction(_ sender: Any) {
        guard Int(quantity.text!)! > 1 else {
            return
        }
        quantity.text = "\(Int(quantity.text!)! - 1)"
        updateUI(nil)
    }
    
    @IBAction func addToCart(_ sender: Any) {
        switch self.addToCartBtn.tag {
        case 1:
            var product = self.product
            product?.quantity = Int(quantity.text!)!
            product?.notes = notesTV.text!
            product?.desc = selectedOptions.text!
            product?.price = Double(productSelectedTotal)
            
            if let variations = product?.variations, !variations.isEmpty{
                for i in 0...(product?.variations!.count)!-1{
                    product!.variations![i].options = product!.variations![i].options?.filter({ return $0.selected == true })
                }
            }
            
            CartServices.shared.addToCart(product!) { (completed) in
                if completed{
                    UIView.animate(withDuration: 0.25, delay: 0, options: []) { [self] in
                        addedHight.constant = 55
                        showCartHeight.constant = 55
                        addedView.isHidden = false
                        showCartView.isHidden = false
                        view.layoutIfNeeded()
                    } completion: { _ in
                        DispatchQueue.main.asyncAfter(deadline: .now()+1) { [self] in
                            UIView.animate(withDuration: 0.25, delay: 0, options: []) {
                                addedHight.constant = 0
                                view.layoutIfNeeded()
                            } completion: { _ in
                                addedView.isHidden = true
                            }
                        }
                    }
                }
            }
        default:
            break
        }
              
    }
    
    func updateUI(_ index: Int?){
        
        var total = product?.price?.roundToDecimal(2) ?? 0.0
        
        if let variations = product?.variations,
           !variations.isEmpty{
            for variation in variations{
                
                let selectedOtps = variation.options?.filter({ return $0.selected == true })
                
                if variation.isAddition == 0{
                    
                    guard !(selectedOtps?.isEmpty)! else { continue }
                    total += (selectedOtps?.first?.price)!.roundToDecimal(2)
                    
                }else{
                    
                    selectedOtps!.forEach({ (option) in
                        total += option.price!.roundToDecimal(2)
                    })
                    
                }
            }
        }
        
        price.isHidden = total == 0.0 ? true : false
        price.text = "\((total * Double(quantity.text!)!).roundToDecimal(2)) EGP"
        price1.isHidden = total == 0.0 ? true : false
        price1.text = "\((total * Double(quantity.text!)!).roundToDecimal(2)) EGP"
        productSelectedTotal = Double(total).roundToDecimal(2)
        
        if let variations = product?.variations,
            !(variations.filter({ return $0.isRequired == 1 }).isEmpty){

            for variation in product!.variations!{

                if variation.isRequired == 1 && variation.isAddition == 0{
                    let selectedOtps = variation.options?.filter({ return $0.selected == true })
                    if !(selectedOtps?.isEmpty)! {
                        self.addToCartBtn.alpha = 1
                        self.addToCartBtn.tag = 1
                    }else{
                        self.addToCartBtn.alpha = 0.5
                        self.addToCartBtn.tag = 0
                        break
                    }
                }else if variation.isRequired == 1 && variation.isAddition == 1{
                    let checkedOtps = variation.options?.filter({ return $0.selected == true })
                    if let min = variation.min, min != 0{
                        guard checkedOtps!.count >= min else {
                            self.addToCartBtn.alpha = 0.5
                            self.addToCartBtn.tag = 0
                            break
                        }
                        self.addToCartBtn.alpha = 1
                        self.addToCartBtn.tag = 1
                    }else{
                        self.addToCartBtn.alpha = 1
                        self.addToCartBtn.tag = 1
                    }
                    if let max = variation.max, max != 0{
                        guard checkedOtps!.count <= max else{
                            self.addToCartBtn.alpha = 0.5
                            self.addToCartBtn.tag = 0
                            if let index = index{ product!.variations![index].expanded = false }
                            let contentOffset = self.scroller.contentOffset
                            self.variationsTableView.reloadData()
                            self.view.layoutIfNeeded()
                            self.viewDidLayoutSubviews()
                            self.scroller.setContentOffset(contentOffset, animated: false)
                            break
                        }
                        self.addToCartBtn.alpha = 1
                        self.addToCartBtn.tag = 1
                    }else{
                        self.addToCartBtn.alpha = 1
                        self.addToCartBtn.tag = 1
                    }
                    if !(checkedOtps?.isEmpty)! {
                        self.addToCartBtn.alpha = 1
                        self.addToCartBtn.tag = 1
                    }else{
                        self.addToCartBtn.alpha = 0.5
                        self.addToCartBtn.tag = 0
                        break
                    }
                }

            }
        }else{
            self.addToCartBtn.alpha = 1
            self.addToCartBtn.tag = 1
        }
        
        var temp: [String] = []
        
        for variation in product!.variations ?? []{
            let selectedOpts = variation.options?.filter({ return $0.selected == true })
            if selectedOpts?.isEmpty == false{
                temp.append(selectedOpts!.map({ "lang".localized == "en" ? "\($0.name!.en ?? "")" : "\($0.name!.ar ?? "")" }).joined(separator: " , "))
//                selectedOptsStr = selectedOpts!.map({ "lang".localized == "en" ? "\($0.name!.en ?? "")" : "\($0.name!.ar ?? "")" }).joined(separator: ", ")
            }
            print("selectedOpts",temp)
        }
        
        selectedOptions.text = temp.isEmpty ? "" : ("[" + temp.joined(separator: " , ") + "]")
    }
    
    
}
