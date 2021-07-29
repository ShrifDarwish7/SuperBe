//
//  RatingsVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 25/07/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class RatingsVC: UIViewController {
    
    @IBOutlet weak var ratingsTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    var presenter: MainPresenter?
    var rates: [Rating]?{
        didSet{
            self.isLoading = false
            self.loadTblFromNib()
        }
    }
    var isLoading = true
    var branch: Branch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MainPresenter(self)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveBranch(sender:)), name: NSNotification.Name("SEND_BRANCH"), object: nil)
        loadTblFromNib()
        ratingsTableView.showAnimatedSkeleton(usingColor: .lightGray, transition: .crossDissolve(0.25))
    }
    
    @objc func didReceiveBranch(sender: NSNotification){
        guard let userInfo = sender.userInfo as? [String: Any] else { return }
        self.branch = (userInfo["branch"] as! Branch)
        presenter?.getBranchRates(branch!.id)
    }
    
    @IBAction func rateBranch(_ sender: Any) {
        Router.toRateBranch(self, branch!)
    }
    
    
    
    @IBAction func reload(_ sender: Any) {
        isLoading = true
        emptyView.isHidden = true
        ratingsTableView.isHidden = false
        loadTblFromNib()
        ratingsTableView.showAnimatedSkeleton(usingColor: .lightGray, transition: .crossDissolve(0.25))
        presenter?.getBranchRates(branch!.id)
    }
    
}

extension RatingsVC: MainViewDelegate{
    func didCompleteWithBranchRates(_ data: [Rating]?, _ error: String?) {
        self.ratingsTableView.hideSkeleton()
        guard error == nil else {
            showToast(error!)
            return
        }
        
        if data!.isEmpty{
            self.ratingsTableView.isHidden = true
            self.emptyView.isHidden = false
        }else{
            self.rates = data!
        }
    }
}

extension RatingsVC: UITableViewDelegate, UITableViewDataSource{
    
    func loadTblFromNib(){
        if isLoading{
            let nib = UINib(nibName: OrdinaryVendorsSkeletonTableViewCell.identifier, bundle: nil)
            ratingsTableView.register(nib, forCellReuseIdentifier: OrdinaryVendorsSkeletonTableViewCell.identifier)
        }else{
            let nib = UINib(nibName: RatingsTableViewCell.identifier, bundle: nil)
            ratingsTableView.register(nib, forCellReuseIdentifier: RatingsTableViewCell.identifier)
        }
        
        ratingsTableView.delegate = self
        ratingsTableView.dataSource = self
        ratingsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rates?.count ?? 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: OrdinaryVendorsSkeletonTableViewCell.identifier, for: indexPath) as! OrdinaryVendorsSkeletonTableViewCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: RatingsTableViewCell.identifier, for: indexPath) as! RatingsTableViewCell
            cell.initFrom(data: self.rates![indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLoading{
            return 115
        }else{
            return UITableView.automaticDimension
        }
    }
    
}
