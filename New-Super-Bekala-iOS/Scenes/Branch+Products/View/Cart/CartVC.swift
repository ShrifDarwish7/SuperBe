//
//  CartVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 03/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class CartVC: UIViewController {
    
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var deliveryFees: UILabel!
    @IBOutlet weak var total: UILabel!
    
    var items: [CartItem]?
    var branches: [CartBranch]?
    var selectedBranch: CartBranch?
    var presenter: MainPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MainPresenter(self)
                
        fetchCartBranches()
            
    }
    
    func fetchCartBranches(){
        CartServices.shared.getCartBranches(id: nil) { [self] (branches) in
            if let branches = branches{
                self.branches = branches
                guard let selectedBranches = self.branches?.filter({ return $0.selected == true }) else { return }
                if selectedBranches.isEmpty{
                    guard !self.branches!.isEmpty else{
                        self.navigationController?.popViewController(animated: true)
                        return
                    }
                    self.branches![0].selected = true
                    self.selectedBranch = self.branches![0]
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
                        let photos = photosData.map({ UIImage(data: $0) })
                    }
                    
                }
                self.loadProductsTableView()
                self.updateBill()
            }
        }
    }
    
    func updateBill(){
        var total = 0.0
        self.items?.forEach({ item in
            total += (item.price * Double(item.quantity))
        })
        self.total.text = "\(total) EGP"
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func toCheckout(_ sender: Any) {
        
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
        
        presenter?.getBranchBy(Int(selectedBranch!.id))
    }
    
}
