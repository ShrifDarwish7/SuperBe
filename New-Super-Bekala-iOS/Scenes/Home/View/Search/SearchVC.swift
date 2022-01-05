//
//  SearchVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 09/05/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import DropDown

class SearchVC: UIViewController{

    @IBOutlet weak var queryTF: UITextField!
  //  @IBOutlet weak var searchType: DropDown!
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var menuContainer: UIView!
    @IBOutlet weak var menuIcon: UIImageView!
    @IBOutlet weak var notFoundStack: UIStackView!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var menuContainerAr: UIView!
    @IBOutlet weak var selectContextView: UIView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var querySearchBar: UISearchBar!
    
    var context: Context = .vendors
    var isLoading = false
    var presenter: MainPresenter?
    var cartItems: [CartItem]?
    var branchId: Int?
    var parameters: [String: String] = [:]
    let options = [
        "Vendors".localized,
        "Products".localized
    ]
    let icons = [
        "vendor_icon",
        "item_icon"
    ]
    let menu = DropDown()
    var receivedQuerey: String?{
        didSet{
            
            self.resultTableView.isHidden = false
            self.notFoundStack.isHidden = true
            
            self.isLoading = true
            self.loadFromNib()
            self.showSkeleton()
            
            parameters.updateValue(receivedQuerey!, forKey: "filter")
                        
            self.presenter?.getBranches(parameters)
        }
    }
    var branches: [Branch]?{
        didSet{
            self.resultTableView.isHidden = false
            self.notFoundStack.isHidden = true
            self.isLoading = false
            self.resultTableView.hideSkeleton()
            self.loadFromNib()
        }
    }
    var products: [Product]?{
        didSet{
            self.resultTableView.isHidden = false
            self.notFoundStack.isHidden = true
            self.isLoading = false
            self.resultTableView.hideSkeleton()
            self.loadFromNib()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MainPresenter(self)
        
        if Shared.isRegion{
            parameters.updateValue("\(Shared.selectedArea.regionsID ?? 0)", forKey: "region_id")
            if Shared.selectedArea.subregionID != 0{
                parameters.updateValue("\(Shared.selectedArea.subregionID ?? 0)", forKey: "subregion_id")
            }
        }else if Shared.isCoords{
            parameters.updateValue(Shared.selectedCoords, forKey: "coordinates")
        }
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .clear
        querySearchBar.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveQuery(sender:)), name: NSNotification.Name("QUERY"), object: nil)
                
        menu.dataSource = options
        menu.cellNib = UINib(nibName: "DropDownCell", bundle: nil)
        menu.customCellConfiguration = {
            index , title , cell in
            guard let cell = cell as? DDCell else { return }
            cell.icon.image = UIImage(named: self.icons[index])
        }
        menu.anchorView = "lang".localized == "en" ? menuContainer : menuContainerAr
        menu.selectRow(0)
        loadSelectedOption()
        
        menu.selectionAction = { [unowned self] (index: Int, item: String) in
            switch index{
            case 0:
                self.context = .vendors
            case 1:
                self.context = .products
            default:
                break
            }
            self.startQuery()
            self.loadSelectedOption()
        }
        
        CartServices.shared.getCartItems(itemId: "-1", branch: -1) { [self] (items) in
            self.cartItems = items
        }
        
        if branchId != nil{
            self.selectContextView.isHidden = true
            self.context = .products
            self.filterView.isHidden = true
        }
        
    }
    @IBAction func toTags(_ sender: Any) {
        presenter?.getTags()
    }
    
    func fetchCartItems(){
        CartServices.shared.getCartItems(itemId: "-1", branch: -1) { [self] (items) in
            self.cartItems = items
        }
    }
    
    @IBAction func showMenu(_ sender: Any) {
        menu.show()
    }
    
    func loadSelectedOption(){
        type.text = menu.selectedItem
        menuIcon.image = UIImage(named: icons[menu.indexForSelectedRow!])
    }
    
    @objc func didReceiveQuery(sender: NSNotification){
        guard let userInfo = sender.userInfo as? [String: String] else { return }
        self.receivedQuerey = userInfo["query"]
    }
    
    func showSkeleton(){
        resultTableView.isSkeletonable = true
        resultTableView.hideSkeleton()
        resultTableView.showAnimatedSkeleton(usingColor: .lightGray, transition: .crossDissolve(0.25))
    }

    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func toFIlters(_ sender: Any) {
        Router.toFilters(self)
    }
    
    func startQuery(){
        guard !querySearchBar.text!.isEmpty else { return }
       // self.view.endEditing(true)
        self.isLoading = true
        self.loadFromNib()
        self.showSkeleton()
        var query: [String: String] = [
            "q": querySearchBar.text!
        ]
        if let branchId = branchId{
            query.updateValue("branch_id=\(branchId)", forKey: "filter")
        }
        
        presenter?.searchWith(query: &query, self.context)
    }
}

enum Context: String{
    case vendors = "branches"
    case products = "branch_products"
}

extension SearchVC: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.startQuery()
    }
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        self.startQuery()
//    }
}

extension SearchVC: TagsDelegate{
    func onSelectTags(_ tags: [Tag]) {
        guard !tags.isEmpty else { return }
        parameters.updateValue(tags.map({ String($0.id) }).joined(separator: ","), forKey: "tags")
        view.endEditing(true)
        isLoading = true
        self.resultTableView.isHidden = false
        self.notFoundStack.isHidden = true
        showSkeleton()
        loadFromNib()
        presenter?.getBranches(parameters)
    }
    
}
