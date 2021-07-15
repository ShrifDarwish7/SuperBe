//
//  OrderVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 21/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class OrderVC: UIViewController {
    
    @IBOutlet weak var orderStatusView: UIView!
    @IBOutlet var statusCol: [UILabel]!
    @IBOutlet weak var statusViewWidth: NSLayoutConstraint!
    @IBOutlet weak var branchImage: UIImageView!
    @IBOutlet weak var branchName: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var orderCoupon: UILabel!
    @IBOutlet weak var couponStack: UIStackView!
    @IBOutlet weak var paymentMethod: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var productsTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var status1Indicator: ViewCorners!
    @IBOutlet weak var status2Indicator: ViewCorners!
    @IBOutlet weak var status3Indicator: ViewCorners!
    @IBOutlet weak var status4Indicator: ViewCorners!
    @IBOutlet weak var orderId: UILabel!
    @IBOutlet weak var status1: UILabel!
    @IBOutlet weak var status2: UILabel!
    @IBOutlet weak var status3: UILabel!
    @IBOutlet weak var status4: UILabel!
    @IBOutlet weak var cancelBtn: ViewCorners!
    @IBOutlet weak var cancelLbl: UILabel!
    @IBOutlet weak var reasonBtn: RoundedButton!
    @IBOutlet weak var failedStatusView: UIView!
    @IBOutlet weak var completedStatusView: UIView!
    @IBOutlet weak var rateBtn: RoundedButton!
    @IBOutlet weak var completedLbl: UILabel!
    @IBOutlet weak var deliveryFees: UILabel!
    @IBOutlet weak var tax: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var discount: UILabel!
    
    var order: LastOrder?
    var presenter: MainPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MainPresenter(self)
        
        cancelLbl.transform = CGAffineTransform(rotationAngle: -(.pi/2))
        reasonBtn.transform = CGAffineTransform(rotationAngle: -(.pi/2))
        completedLbl.transform = CGAffineTransform(rotationAngle: -(.pi/2))
        rateBtn.transform = CGAffineTransform(rotationAngle: -(.pi/2))
        
        orderId.text = "#\(order?.id ?? 000000)"
        address.text = order?.address?.title
        
        let swipLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipLeft.direction = .left
        self.view.addGestureRecognizer(swipLeft)
        
        let swipRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipRight.direction = .right
        self.view.addGestureRecognizer(swipRight)

        
        for lbl in statusCol{
            lbl.transform = CGAffineTransform(rotationAngle: -(.pi/2))
        }
        
        if let products = order?.lineItems,
           !products.isEmpty{
            self.loadProductsTable()
        }
        branchImage.kf.indicatorType = .activity
        branchImage.kf.setImage(with: URL(string: Shared.storageBase + (order?.branch?.logo)!), placeholder: nil, options: [], completionHandler: nil)
        branchName.text = order?.branch?.name//"lang".localized == "en" ? order?.branch?.nameEn : order?.branch?.nameAr
        orderDate.text = order?.createdAt
        cancelBtn.isHidden = order?.status == "processing" ? false : true
        deliveryFees.text = "\(order?.shippingTotal ?? 0.0) EGP"
        discount.text = "\(order?.discountTotal ?? 0.0) EGP"
        tax.text = "\(order?.taxesTotal ?? 0.0) EGP"
        total.text = "\(order?.orderTotal ?? 0.0) EGP"
                
        switch order?.status {
        case "processing":
            status2Indicator.alpha = 0.5
            status3Indicator.alpha = 0.5
            status4Indicator.alpha = 0.5
            status2.alpha = 0.5
            status3.alpha = 0.5
            status4.alpha = 0.5
        case "pending":
            status1Indicator.alpha = 0.5
            status3Indicator.alpha = 0.5
            status4Indicator.alpha = 0.5
            status1.alpha = 0.5
            status3.alpha = 0.5
            status4.alpha = 0.5
        case "out-for-delivery":
            status2Indicator.alpha = 0.5
            status1Indicator.alpha = 0.5
            status4Indicator.alpha = 0.5
            status2.alpha = 0.5
            status1.alpha = 0.5
            status4.alpha = 0.5
        case "completed":
//            status2Indicator.alpha = 0.5
//            status3Indicator.alpha = 0.5
//            status1Indicator.alpha = 0.5
//            status2.alpha = 0.5
//            status3.alpha = 0.5
//            status1.alpha = 0.5
            completedStatusView.isHidden = false
        case "cancelled", "failed":
            failedStatusView.isHidden = false
        default:
            break
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        productsTableViewHeight.constant = productsTableView.contentSize.height
        self.view.layoutIfNeeded()
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func cancelOrderAction(_ sender: Any) {
        self.presenter?.updateOrder(id: (order?.id)!, prms: ["status": "cancelled"])
    }
    
    
    @objc func didSwipe(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .left:
            UIView.animate(withDuration: 0.2) {
                self.statusViewWidth.constant = 0
                self.view.layoutIfNeeded()
            }
        case .right:
            UIView.animate(withDuration: 0.2) {
                self.statusViewWidth.constant = 85
                self.view.layoutIfNeeded()
            }
        default:
            break
        }
    }


}

extension OrderVC: MainViewDelegate{
    func didCompleteUpdateOrder(_ data: LastOrder?, _ error: String?) {
        if let _ = data{
            self.navigationController?.popViewController(animated: true)
        }else{
            showToast(error!)
        }
    }
}
