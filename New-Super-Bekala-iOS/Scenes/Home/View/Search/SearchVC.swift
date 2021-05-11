//
//  SearchVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 09/05/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import iOSDropDown

class SearchVC: UIViewController{

    @IBOutlet weak var queryTF: UITextField!
    @IBOutlet weak var searchType: DropDown!
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var notFoundStack: UIStackView!
    
    var context: Context = .vendors
    var isLoading = false
    var presenter: MainPresenter?
    var cartItems: [CartItem]?
    var branches: [Branch]?{
        didSet{
            self.resultTableView.isHidden = false
            self.notFoundStack.isHidden = true
            self.isLoading = false
            self.loadFromNib()
            self.resultTableView.hideSkeleton()
        }
    }
    var products: [Product]?{
        didSet{
            self.resultTableView.isHidden = false
            self.notFoundStack.isHidden = true
            self.isLoading = false
            self.loadFromNib()
            self.resultTableView.hideSkeleton()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MainPresenter(self)
        
        queryTF.addTarget(self, action: #selector(queryDidChange), for: .editingChanged)
        
        searchType.optionArray = ["vendors","products"]
        searchType.didSelect { (_, index, _) in
            switch index{
            case 0:
                self.context = .vendors
            case 1:
                self.context = .products
            default:
                break
            }
            self.queryDidChange()
        }
        
        CartServices.shared.getCartItems(itemId: "-1", branch: -1) { [self] (items) in
            self.cartItems = items
        }
        
    }
    
    @objc func queryDidChange(){
        self.isLoading = true
        self.loadFromNib()
        self.showSkeleton()
        var query: [String: String] = [
           // "lang": "lang".localized,
            "q": queryTF.text!
        ]
        presenter?.searchWith(query: &query, self.context)
    }
    
    func showSkeleton(){
        resultTableView.isSkeletonable = true
        resultTableView.hideSkeleton()
        resultTableView.showAnimatedSkeleton(usingColor: .lightGray, transition: .crossDissolve(0.25))
    }

    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

enum Context: String{
    case vendors = "branches"
    case products = "branch_products"
}
