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
    @IBOutlet weak var wallet: UILabel!
    @IBOutlet weak var deliveryStack: UIStackView!
    @IBOutlet weak var discountStack: UIStackView!
    @IBOutlet weak var taxStack: UIStackView!
    @IBOutlet weak var walletStack: UIStackView!
    @IBOutlet weak var statusBtn: UIButton!
    @IBOutlet weak var captainView: ViewCorners!
    @IBOutlet weak var captainAvatar: CircluarImage!
    @IBOutlet weak var captainName: UILabel!
    
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
        
        if let address = order?.address{
            self.address.text = address.title
        }else{
            address.text = "Receive from vendor".localized
        }
        
        //deliveryStack.isHidden = order?.shippingTotal == 0 ? true : false
        discountStack.isHidden = order?.discountTotal == 0 ? true : false
        taxStack.isHidden = order?.taxesTotal == 0 ? true : false
        walletStack.isHidden = order?.paidFromWallet == 0 ? true : false
        
        let swipLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipLeft.direction = .left
        self.view.addGestureRecognizer(swipLeft)
        
        let swipRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
        swipRight.direction = .right
        self.view.addGestureRecognizer(swipRight)

        if let coupons = order?.coupons, !coupons.isEmpty{
            orderCoupon.text = coupons.joined(separator: ", ")
            couponStack.isHidden = false
        }else{
            couponStack.isHidden = true
        }
        
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
        deliveryFees.text = "\(order?.shippingTotal?.roundToDecimal(2) ?? 0.0) EGP"
        discount.text = "\(order?.discountTotal?.roundToDecimal(2) ?? 0.0) EGP"
        tax.text = "\(order?.taxesTotal?.roundToDecimal(2) ?? 0.0) EGP"
        total.text = "\(order?.orderTotal?.roundToDecimal(2) ?? 0.0) EGP"
        
        switch order?.paymentMethod {
        case 0:
            paymentMethod.text = "Cash".localized
        case 1:
            paymentMethod.text = "Card on delivery".localized
        case 2:
            paymentMethod.text = "Online payment".localized
        case 3:
            paymentMethod.text = "Wallet".localized
        case 4:
            paymentMethod.text = "Cash & Wallet".localized
        default : break
        }
                
        if let captain = order?.captain,
           let captainUser = captain.user{
            captainView.isHidden = false
            captainAvatar.kf.setImage(with: URL(string: Shared.storageBase + captainUser.avatar!))
            captainName.text = captainUser.name
        }else{
            captainView.isHidden = true
        }
        
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
       // hideStatusView()
    }
    
    @IBAction func callCaptain(_ sender: Any) {
        guard let phone = order?.captain?.user?.phone else { return }
        Shared.call(phoneNumber: phone)
    }
    
    @IBAction func rateAction(_ sender: Any) {
        Router.toRateOrder(self, (self.order?.branch?.id)!, (self.order?.id)!)
    }
    
    
    @IBAction func openAddressInMaps(_ sender: Any) {
        guard let address = self.order?.address else { return }
        self.openInMaps(coordinates: address.coordinates ?? "0.0")
    }
    
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancelOrderAction(_ sender: Any) {
        self.presenter?.updateOrder(id: (order?.id)!, prms: ["status": "cancelled"])
    }
    
    
    @objc func didSwipe(_ sender: UISwipeGestureRecognizer) {
        if "lang".localized == "en"{
            switch sender.direction {
            case .left:
                hideStatusView()
            case .right:
                showStatusView()
            default:
                break
            }
        }else{
            switch sender.direction {
            case .right:
                hideStatusView()
            case .left:
                showStatusView()
            default:
                break
            }
        }
        
    }
    
    @IBAction func statusAction(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            showStatusView()
            sender.tag = 1
        case 1:
            hideStatusView()
            sender.tag = 0
        default:
            break
        }
    }
    
    
    func showStatusView(){
        UIView.animate(withDuration: 0.2) {
            self.statusViewWidth.constant = 85
            self.view.layoutIfNeeded()
            self.statusBtn.tag = 1
        }
    }

    func hideStatusView(){
        UIView.animate(withDuration: 0.2) {
            self.statusViewWidth.constant = 0
            self.statusBtn.tag = 0
            self.view.layoutIfNeeded()
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
