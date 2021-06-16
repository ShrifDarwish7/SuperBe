//
//  CheckoutVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 07/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import Cosmos
import SwiftyJSON
import SVProgressHUD

class CheckoutVC: UIViewController {

    @IBOutlet weak var notesHeight: NSLayoutConstraint!
    @IBOutlet weak var receiveViewHeight: NSLayoutConstraint!
    @IBOutlet weak var receiveOptionView: ViewCorners!
    @IBOutlet weak var paymentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var paymentOptionView: ViewCorners!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var backStack: UIStackView!
    @IBOutlet weak var deliveryBtn: UIButton!
    @IBOutlet weak var receiveFromShopBtn: UIButton!
    @IBOutlet weak var cashOnDeliveryBtn: UIButton!
    @IBOutlet weak var creditOnDeliveryBtn: UIButton!
    @IBOutlet weak var creditBtn: UIButton!
    @IBOutlet weak var notesTV: UITextView!
    @IBOutlet weak var receiveDeliveryStack: UIStackView!
    @IBOutlet weak var receiveFromShopStack: UIStackView!
    @IBOutlet weak var promoViewHeight: NSLayoutConstraint!
    @IBOutlet weak var promoView: ViewCorners!
    @IBOutlet weak var cashOnDeliveryStack: UIStackView!
    @IBOutlet weak var creditOnDeliveryStack: UIStackView!
    @IBOutlet weak var creditStack: UIStackView!
    @IBOutlet weak var addressStack: UIStackView!
    @IBOutlet weak var promoViewContainer: UIView!
    @IBOutlet weak var branchLogo: UIImageView!
    @IBOutlet weak var branchRate: CosmosView!
    @IBOutlet weak var branchName: UILabel!
    @IBOutlet weak var addressesTableView: UITableView!
    @IBOutlet weak var acitvityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addressesView: ViewCorners!
    @IBOutlet weak var selectedAddressLbl: UILabel!
    @IBOutlet weak var expandAddressImg: UIImageView!
    @IBOutlet weak var notesView: ViewCorners!
    @IBOutlet weak var blockView: UIView!
    @IBOutlet weak var bottomSheetTopCnst: NSLayoutConstraint!
    @IBOutlet weak var paymentContainerView: UIView!
    
    let minHeaderViewHeight: CGFloat = UIApplication.shared.statusBarFrame.height + 135
    let maxHeaderViewHeight: CGFloat = 250
    var branch: Branch?
    var selectedReceiveOption: Int?
    var selectedPayment: Int?
    var presenter: MainPresenter?
    var addresses: [Address]?
    var items: [CartItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MainPresenter(self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissPaymentSheet(sender:)), name: NSNotification.Name("DISMISS_PAYMENT"), object: nil)
       // branchName.text = "lang".localized == "en" ? branch?.branchLanguage?.first?.name : branch?.branchLanguage![0].name
        branchName.text = "\(branch?.id ?? 0)"
        branchLogo.sd_setImage(with: URL(string: Shared.storageBase + (branch?.logo)!))
        branchRate.rating = branch?.rating ?? 3.0
        
        receiveViewHeight.constant = 60
        receiveOptionView.isHidden = true
        paymentViewHeight.constant = 60
        paymentOptionView.isHidden = true
        notesHeight.constant = 0
        promoViewHeight.constant = 60
        promoView.isHidden = true
        
        blockView.isHidden = true
        bottomSheetTopCnst.constant = self.view.frame.height
        
        receiveFromShopStack.alpha = branch?.receiveFromShop == 1 ? 1 : 0.3
        receiveDeliveryStack.alpha = branch?.supportDelivery == 1 ? 1 : 0.3
       // cashOnDeliveryStack.alpha = branch?.cashOnDelivery == 1 ? 1 : 0.3
        creditOnDeliveryStack.alpha = branch?.creditOnDelivery == 1 ? 1 : 0.3
        creditStack.alpha = branch?.onlinePayment == 1 ? 1 : 0.3
        promoViewContainer.isHidden = branch?.acceptCoupons == 1 ? false : true
                
        CartServices.shared.getCartItems(itemId: "-1", branch: branch!.id) { (items) in
            if let items = items{
                self.items = items
                for item in items{
                    let variations = item.variations?.getDecodedObject(from: [Variation].self)
                    print("here vars", variations)
                    print("here vars count", variations?.count)
                }
            }
        }
    }
    
    @objc func dismissPaymentSheet(sender: NSNotification){
        
        self.bottomSheetTopCnst.constant = self.view.frame.height
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: []) {
            self.view.layoutIfNeeded()
        } completion: { (_) in
            self.blockView.isHidden = true
        }
        
        self.paymentContainerView.subviews.forEach({ $0.removeFromSuperview() })
        
        guard let userInfo = sender.userInfo as? [String: String] else { return }
        if let success = userInfo["success"],
           let transactionId = userInfo["transactionId"],
           success == "1"{
            showToast("Transaction success")
        }else{
            showToast("Transaction failed, please make sure you entered correct card information and the card is valid")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        acitvityIndicator.startAnimating()
        presenter?.getAddresses()
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showAddresses(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) { [self] in
            switch sender.tag {
            case 0:
                self.addressesView.isHidden = false
                sender.tag = 1
                expandAddressImg.transform = CGAffineTransform(rotationAngle: .pi)
            case 1:
                self.addressesView.isHidden = true
                sender.tag = 0
                expandAddressImg.transform = CGAffineTransform(rotationAngle: .pi*2)
            default:
                break
            }
        }
    }
    
    @IBAction func toAddAddress(_ sender: Any) {
        Router.toAddAddress(self)
    }
    
    @IBAction func chooseReceiveOption(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            guard branch?.supportDelivery == 1 else { return }
            UIView.animate(withDuration: 0.2) {
                self.addressStack.isHidden = false
            }
            deliveryBtn.setImage(UIImage(named: "radio_selected"), for: .normal)
            receiveFromShopBtn.setImage(UIImage(named: "radio_unselected"), for: .normal)
        case 1:
            guard branch?.receiveFromShop == 1 else { return }
            UIView.animate(withDuration: 0.2) {
                self.addressStack.isHidden = true
            }
            deliveryBtn.setImage(UIImage(named: "radio_unselected"), for: .normal)
            receiveFromShopBtn.setImage(UIImage(named: "radio_selected"), for: .normal)
        default:
            break
        }
        
        self.selectedReceiveOption = sender.tag
    }
    
    @IBAction func choosePaymentOption(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            guard branch?.cashOnDelivery == 1 else { return }
            cashOnDeliveryBtn.setImage(UIImage(named: "radio_selected"), for: .normal)
            creditOnDeliveryBtn.setImage(UIImage(named: "radio_unselected"), for: .normal)
            creditBtn.setImage(UIImage(named: "radio_unselected"), for: .normal)
        case 1:
            guard branch?.creditOnDelivery == 1 else { return }
            creditOnDeliveryBtn.setImage(UIImage(named: "radio_selected"), for: .normal)
            cashOnDeliveryBtn.setImage(UIImage(named: "radio_unselected"), for: .normal)
            creditBtn.setImage(UIImage(named: "radio_unselected"), for: .normal)
        case 2:
            guard branch?.onlinePayment == 1 else { return }
            creditBtn.setImage(UIImage(named: "radio_selected"), for: .normal)
            cashOnDeliveryBtn.setImage(UIImage(named: "radio_unselected"), for: .normal)
            creditOnDeliveryBtn.setImage(UIImage(named: "radio_unselected"), for: .normal)
        default:
            break
        }
        
        self.selectedPayment = sender.tag
        
    }
    
    
    
    @IBAction func expandReceive(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            self.receiveViewHeight.constant = 140
            self.receiveOptionView.isHidden = false
            sender.tag = 1
            UIView.animate(withDuration: 0.2) {
                sender.transform = CGAffineTransform(rotationAngle: .pi)
            }
        case 1:
            self.receiveViewHeight.constant = 60
            self.receiveOptionView.isHidden = true
            sender.tag = 0
            UIView.animate(withDuration: 0.2) {
                sender.transform = CGAffineTransform(rotationAngle: .pi*2)
            }
        default:
            break
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func expandPayment(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            self.paymentViewHeight.constant = 160
            self.paymentOptionView.isHidden = false
            sender.tag = 1
            UIView.animate(withDuration: 0.2) {
                sender.transform = CGAffineTransform(rotationAngle: .pi)
            }
        case 1:
            self.paymentViewHeight.constant = 60
            self.paymentOptionView.isHidden = true
            sender.tag = 0
            UIView.animate(withDuration: 0.2) {
                sender.transform = CGAffineTransform(rotationAngle: .pi*2)
            }
        default:
            break
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    @IBAction func expandCoupon(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            self.promoViewHeight.constant = 110
            self.promoView.isHidden = false
            sender.tag = 1
            UIView.animate(withDuration: 0.2) {
                sender.transform = CGAffineTransform(rotationAngle: .pi)
            }
        case 1:
            self.promoViewHeight.constant = 60
            self.promoView.isHidden = true
            sender.tag = 0
            UIView.animate(withDuration: 0.2) {
                sender.transform = CGAffineTransform(rotationAngle: .pi*2)
            }
        default:
            break
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func openNotes(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            self.notesHeight.constant = 100
            sender.tag = 1
            notesView.isHidden = false
            UIView.animate(withDuration: 0.2) {
                sender.transform = CGAffineTransform(rotationAngle: .pi)
            }
        case 1:
            self.notesHeight.constant = 0
            sender.tag = 0
            notesView.isHidden = true
            UIView.animate(withDuration: 0.2) {
                sender.transform = CGAffineTransform(rotationAngle: .pi*2)
            }
        default:
            break
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        self.view.endEditing(true)
    }
    
    func showPaySheet(){
        Shared.transaction = Transaction()
        Shared.transaction?.amount = 0.5
        Shared.transaction?.currency = "EGP"
        self.replaceView(containerView: paymentContainerView, identifier: "PaymentVC", storyboard: .orders)
        self.blockView.isHidden = false
        self.bottomSheetTopCnst.constant = 300
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: []) {
            self.view.layoutIfNeeded()
        } completion: { (_) in
            
        }
    }
    
    func dismissPaySheet(){
        
        self.view.endEditing(true)
        let alert = UIAlertController(title: "Cancel Payment", message: "cancelling payment session will clear off your card details", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.blockView.isHidden = true
            self.bottomSheetTopCnst.constant = self.view.frame.height
            self.view.layoutIfNeeded()
            self.paymentContainerView.subviews.forEach({ $0.removeFromSuperview() })
            self.creditBtn.setImage(UIImage(named: "radio_unselected"), for: .normal)
            self.selectedPayment = nil
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func dismissPaySheetAction(_ sender: Any) {
        dismissPaySheet()
    }
    
    @IBAction func placeOrderAction(_ sender: Any) {
        
        if selectedPayment == 2{
            showPaySheet()
            return
        }
        
        var lineItems = [LineItem]()
        
        for item in self.items!{
            guard let itemVariations = item.variations?.getDecodedObject(from: [Variation].self) else { continue }
            var variations = [LineItemVariation]()
            for variation in itemVariations{
//                var selectedOtps = [Int]()
//                variation.options?.filter({ return $0.selected == true }).forEach({ (option) in
//                    selectedOtps.append(option.id!)
//                })
//                var checkedOtps = [Int]()
//                checkedOtps = variation.options!.map({ $0.id! })
//                variation.options?.filter({ return $0.checked == true }).forEach({ (option) in
//                    checkedOtps.append(option.id!)
//                })
                variations.append(
                    LineItemVariation(
                        id: variation.id,
                        options: variation.options!.map({ $0.id! })))//variation.isAddition == 0 ? selectedOtps : checkedOtps))
            }
            
            lineItems.append(
                LineItem(branchProductID: Int(item.product_id),
                         quantity: Int(item.quantity),
                         lineNotes: item.notes,
                         variations: variations))
        }
        
        let order = Order(
            deliveryMethod: selectedReceiveOption ?? 0,
            paymentMethod: selectedPayment ?? 0,
            addressID: ((addresses?.filter({ return $0.selected == 1 }))?.first?.id)!,
            customerNote: notesTV.text!,
            couponID: 123,
            branchID: branch!.id,
            lineItems: lineItems)
        
        self.presenter?.placeOrder(order)
        
    }
    
    
}

extension CheckoutVC: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            
        let y: CGFloat = scrollView.contentOffset.y
 
        let newHeaderViewHeight: CGFloat = topViewHeight.constant - y
        if newHeaderViewHeight > maxHeaderViewHeight {
            topViewHeight.constant = maxHeaderViewHeight
        } else if newHeaderViewHeight < minHeaderViewHeight {
            topViewHeight.constant = minHeaderViewHeight
        } else {
            topViewHeight.constant = newHeaderViewHeight
            scrollView.contentOffset.y = 0
        }
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        topViewHeight.constant = maxHeaderViewHeight
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}

