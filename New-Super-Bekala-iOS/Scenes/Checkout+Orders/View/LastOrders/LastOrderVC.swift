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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchAndReload()
    }
    
    func fetchAndReload(){
        isLoading = true
        
        presenter = MainPresenter(self)
        presenter?.getMyOrders()
        
        loadFromNib()
        lastOrdersTableView.isSkeletonable = true
        showSkeleton()
        
        selectOrders()
        self.view.layoutIfNeeded()
        
        fastTabView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    }
    
    func showSkeleton(){
        lastOrdersTableView.hideSkeleton()
        lastOrdersTableView.showAnimatedSkeleton(usingColor: .lightGray, transition: .crossDissolve(0.25))
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
    
    
    @IBAction func tabsAction(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            
            UIView.animate(withDuration: 0.2) { [self] in
                self.selectOrders()
                self.view.layoutIfNeeded()
            }
            
        case 1:
            
            fastTabView.backgroundColor = UIColor(named: "Buttons-Red")
            ordersTabView.backgroundColor = UIColor.lightGray
            fastTabView.alpha = 1
            ordersTabView.alpha = 0.5
            UIView.animate(withDuration: 0.2) { [self] in
                ordersTabView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                fastTabView.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.view.layoutIfNeeded()
            }
            
        default:
            break
        }
    }
    
    @IBAction func reload(_ sender: Any) {
        self.emptyView.isHidden = true
        self.lastOrdersTableView.isHidden = false
        self.fetchAndReload()
    }
    
}
