//
//  CartVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 03/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import SVProgressHUD

class CartVC: UIViewController {
    
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var taxes: UILabel!
    @IBOutlet weak var total: UILabel!
    
    var items: [CartItem]?
    var branches: [CartBranch]?
    var selectedBranch: CartBranch?
    var presenter: MainPresenter?
    var linesTotal = 0.0
    var fetchingSelectedBranch = false
    var setting: Setting?
    var loginPresenter: LoginViewPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MainPresenter(self)
                
        fetchCartBranches()
        loginPresenter = LoginViewPresenter(loginViewDelegate: self)
        loginPresenter?.getSetting()
            
    }
    
    func fetchCartBranches(){
        CartServices.shared.getCartBranches(id: nil) { [self] (branches) in
            if let branches = branches{
                self.branches = branches
                guard !self.branches!.isEmpty else{
                    self.navigationController?.popViewController(animated: true)
                    return
                }
                guard let selectedBranches = self.branches?.filter({ return $0.selected == true }) else { return }

                if selectedBranches.isEmpty{
                    guard !self.branches!.isEmpty else{
                        self.navigationController?.popViewController(animated: true)
                        return
                    }
                    branches[0].selected = true
                    self.selectedBranch = branches[0]
                    
                }else{
                    self.selectedBranch = selectedBranches.first
                }
                fetchCartItems()
                self.loadFiltersCollection()
            }
        }
    }
    
    func fetchCartItems(){
        CartServices.shared.getCartItems(itemId: "-1", branch: Int((self.selectedBranch!.id))) { (items) in
            if let items = items{
                self.items = items                
                for item in items{
                   // let variations = item.variations?.getDecodedObject(from: [Variation].self)
                    if let _ = item.photos{
                        let photosData = try! JSONDecoder.init().decode([Data].self, from: item.photos!)
                        _ = photosData.map({ UIImage(data: $0) })
                    }
                    
                }
                self.loadProductsTableView()
                self.updateBill()
            }
        }
    }
    
    @IBAction func deleteAll(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Items".localized, message: "Are you sure you want to delete items from this vendor?".localized, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete".localized, style: .destructive, handler: { _ in
            CartServices.shared.removeBranchWithItems(Int((self.selectedBranch!.id))) { removed in
                if removed{
                    self.fetchCartBranches()
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel))
        present(alert, animated: true, completion: nil)
    }
    
    func updateBill(){
        self.linesTotal = 0
        self.items?.forEach({ item in
            linesTotal += (item.price * Double(item.quantity))
        })
        self.total.text = "\(self.linesTotal) EGP"
        self.taxes.text = "\(((self.selectedBranch?.taxes ?? 0.0)/100) * self.linesTotal) EGP"
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func toCheckout(_ sender: Any) {
        if setting?.appClosed != 0{
            let errorMsg = "App is closed now,for \(setting?.appCloseMessage ?? "") you can check out later"
            showToast(errorMsg)
            return
        }
        
        
        guard APIServices.shared.isLogged else{
            Router.toRegister(self)
            return
        }
        
        for item in self.items!{
            
            if item.min_qty > 0,
               item.quantity < item.min_qty{
                let errorMsg = "You must have at least \(item.min_qty) of " + ("lang".localized == "en" ? item.name_en! : item.name_ar!) + " in your cart"
                showToast(errorMsg)
                return
            }
            if item.max_qty > 0,
               item.quantity > item.max_qty{
                let errorMsg = "You exceeds the maximum quantity of " + ("lang".localized == "en" ? item.name_en! : item.name_ar!) + " in your cart, quatity must be less than \(item.max_qty)"
                showToast(errorMsg)
                return
            }
            
        }
        let loginPresenter = LoginViewPresenter(loginViewDelegate: self)
        SVProgressHUD.show()
        loginPresenter.getProfile()
    }
    
}
