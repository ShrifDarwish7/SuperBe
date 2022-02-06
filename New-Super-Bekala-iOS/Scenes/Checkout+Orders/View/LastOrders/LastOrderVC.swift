//
//  LastOrderVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 21/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class LastOrderVC: UIViewController {

    @IBOutlet weak var lastOrdersTableView: UITableView!
    @IBOutlet weak var ordersViewHeight: NSLayoutConstraint!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var ordersTabView: ViewCorners!
    @IBOutlet weak var fastTabView: ViewCorners!
    
    var lastOrders = [LastOrder]()
    var lastServices = [LastOrder]()
    var isLoading = true
    var presenter: MainPresenter?
    var refreshControl = UIRefreshControl()
    var page = 1
    var meta: Meta?
    var parameters: [String: String] = [:]
    var isPaginating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToTop), name: NSNotification.Name("SCROLL_TO_TOP"), object: nil)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        lastOrdersTableView.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        presenter = MainPresenter(self)
        
        lastOrders.removeAll()
        lastServices.removeAll()
        
        showSkeleton()
        page = 1
        
        parameters.updateValue("\(page)", forKey: "page")
        parameters.updateValue("10", forKey: "per_page")
        
        if Shared.selectedOrders{
            selectOrders()
            parameters.updateValue("captain.user", forKey: "with")
            presenter?.getMyOrders(parameters)
        }else{
            selectServices()
            parameters.removeValue(forKey: "with")
            presenter?.getMyServices(parameters)
        }
    }
    
    @objc func refresh(){
        self.reload(self)
    }
    
    @objc func scrollToTop(){
        self.lastOrdersTableView.setContentOffset(.zero, animated: true)
    }
    
    func showSkeleton(){
        isLoading = true

        loadFromNib()
        lastOrdersTableView.isSkeletonable = true
        
        lastOrdersTableView.hideSkeleton()
        lastOrdersTableView.showAnimatedSkeleton(usingColor: .lightGray, transition: .crossDissolve(0.25))
        
        self.view.layoutIfNeeded()
        
        fastTabView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    }
    
    
    func selectOrders(){
        ordersTabView.backgroundColor = UIColor(named: "Buttons-Red")
        fastTabView.backgroundColor = UIColor.lightGray
        ordersTabView.alpha = 1
        fastTabView.alpha = 0.5
        self.emptyView.isHidden = true
        self.lastOrdersTableView.isHidden = false
        fastTabView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        ordersTabView.transform = CGAffineTransform(scaleX: 1, y: 1)
    }
    
    func selectServices(){
        fastTabView.backgroundColor = UIColor(named: "Buttons-Red")
        ordersTabView.backgroundColor = UIColor.lightGray
        fastTabView.alpha = 1
        ordersTabView.alpha = 0.5
        ordersTabView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        fastTabView.transform = CGAffineTransform(scaleX: 1, y: 1)
        self.emptyView.isHidden = true
        self.lastOrdersTableView.isHidden = false
    }
    
    
    @IBAction func tabsAction(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            
            UIView.animate(withDuration: 0.2) { [self] in
                Shared.selectedOrders = true
                self.selectOrders()
                self.view.layoutIfNeeded()
            }
            
        case 1:
            
            UIView.animate(withDuration: 0.2) { [self] in
                Shared.selectedOrders = false
                self.selectServices()
                self.view.layoutIfNeeded()
            }
            
        default:
            break
        }
        self.viewWillAppear(true)
    }
    
    @IBAction func reload(_ sender: Any) {
        self.emptyView.isHidden = true
        self.lastOrdersTableView.isHidden = false
        self.viewWillAppear(true)
    }
    
}


extension LastOrderVC: OrderUpdatedDelegate{
    func onRefreshOrders() {
        self.viewWillAppear(true)
//        showSkeleton()
//        if selectedOrders{
//            selectOrders()
//            presenter?.getMyOrders(parameters)
//        }else{
//            selectServices()
//            presenter?.getMyServices(parameters)
//        }
    }
}
