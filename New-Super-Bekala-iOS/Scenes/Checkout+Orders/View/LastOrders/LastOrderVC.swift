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
    
    var lastOrders: [LastOrder]?
    var isLoading = true
    var presenter: MainPresenter?
    var selectedOrders = true
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToTop), name: NSNotification.Name("SCROLL_TO_TOP"), object: nil)
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        lastOrdersTableView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        presenter = MainPresenter(self)

        showSkeleton()
        
        if selectedOrders{
            selectOrders()
            presenter?.getMyOrders()
        }else{
            selectServices()
            presenter?.getMyServices()
        }
    }
    
    @objc func refresh(){
        refreshControl.endRefreshing()
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
                self.selectedOrders = true
                self.selectOrders()
                self.view.layoutIfNeeded()
            }
            
        case 1:
            
            UIView.animate(withDuration: 0.2) { [self] in
                self.selectedOrders = false
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

