//
//  UserCouponsVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Super Be on 06/01/2022.
//  Copyright © 2022 Super Bekala. All rights reserved.
//

import UIKit

class UserCouponsVC: UIViewController, MainViewDelegate {
    
    @IBOutlet weak var statusCollectionView: UICollectionView!
    @IBOutlet weak var couponsTableView: UITableView!
    
    var mainStatus = [CouponStatus]()
    var presenter: MainPresenter!
    var coupons: [Coupon]!{
        didSet{
            couponsTableView.delegate = self
            couponsTableView.dataSource = self
            couponsTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MainPresenter(self)
        presenter.getUserCoupons(.available)
        
        mainStatus.append(CouponStatus(name: "Valid".localized, selected: true))
        mainStatus.append(CouponStatus(name: "Used".localized, selected: false))
        mainStatus.append(CouponStatus(name: "Expired".localized, selected: false))
        
        statusCollectionView.delegate = self
        statusCollectionView.dataSource = self

    }
    
    func didCompleteWithUserCoupns(_ data: [Coupon]?) {
        guard let coupons = data else { return }
        self.coupons = coupons
    }

}

extension UserCouponsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coupons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCouponsTableViewCell.identifer, for: indexPath) as! UserCouponsTableViewCell
        cell.name.text = coupons[indexPath.row].code
        cell.desc.text = "lang".localized == "en" ? coupons[indexPath.row].couponResponseDescription?.en : coupons[indexPath.row].couponResponseDescription?.ar
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension UserCouponsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainStatus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCouponsCollectionViewCell.identifer, for: indexPath) as! UserCouponsCollectionViewCell
        cell.loadfrom(status: mainStatus[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for i in 0...mainStatus.count-1{
            mainStatus[i].selected = false
        }
        mainStatus[indexPath.row].selected = true
        collectionView.reloadData()
        switch indexPath.row {
        case 0:
            presenter.getUserCoupons(.available)
        case 1:
            presenter.getUserCoupons(.used)
        case 2:
            presenter.getUserCoupons(.expired)
        default: return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: collectionView.frame.height)
    }
}

enum CouponType: String{
    case used = "used"
    case available = "available"
    case expired = "expired"
}
