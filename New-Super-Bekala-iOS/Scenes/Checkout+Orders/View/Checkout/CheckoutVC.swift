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
import MapKit

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
    @IBOutlet weak var branchLogo1: UIImageView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var selectedAddressTF: UITextField!
    @IBOutlet weak var walletBtn: UIButton!
    @IBOutlet weak var walletStack: UIStackView!
    @IBOutlet weak var shippingLbl: UILabel!
    @IBOutlet weak var couponsTF: UITextField!
    @IBOutlet weak var validateBtn: RoundedButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var verifiedCoupon: UIImageView!
    @IBOutlet weak var shippingCostActivity: UIActivityIndicatorView!
    @IBOutlet weak var nameStack: UIStackView!
    @IBOutlet weak var phoneStack: UIStackView!
    @IBOutlet weak var receiveView: UIView!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var scroller: UIScrollView!
    
    let minHeaderViewHeight: CGFloat = UIApplication.shared.statusBarFrame.height + 135
    let maxHeaderViewHeight: CGFloat = 250
    var branch: Branch?
    var selectedReceiveOption: Int?
    var selectedPayment: Int?
    var presenter: MainPresenter?
    var addresses: [Address]?
    var items: [CartItem]?
    var lineItems = [LineItem]()
    var coupons: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MainPresenter(self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(paymentDidFinish(sender:)), name: NSNotification.Name("FINISH_PAYMENT"), object: nil)
        branchName.text = "lang".localized == "en" ? branch?.name?.en : branch?.name?.ar
        branchLogo.kf.indicatorType = .activity
        branchLogo.kf.setImage(with: URL(string: Shared.storageBase + (branch?.logo)!), placeholder: nil, options: [], completionHandler: nil)
        branchLogo1.kf.setImage(with: URL(string: Shared.storageBase + (branch?.logo)!), placeholder: nil, options: [], completionHandler: nil)
        
        branchRate.rating = Double(branch?.rating ?? "0.0")!
        username.text = APIServices.shared.user?.name
        phoneNumber.text = APIServices.shared.user?.phone ?? ""
        
        blockView.isHidden = true
        bottomSheetTopCnst.constant = self.view.frame.height
        
        receiveFromShopStack.alpha = branch?.receiveFromShop == 1 ? 1 : 0.3
        receiveDeliveryStack.alpha = branch?.supportDelivery == 1 ? 1 : 0.3
        cashOnDeliveryStack.alpha = branch?.cashOnDelivery == 1 ? 1 : 0.3
        creditOnDeliveryStack.alpha = branch?.creditOnDelivery == 1 ? 1 : 0.3
        creditStack.alpha = branch?.onlinePayment == 1 ? 1 : 0.3
        walletStack.alpha = branch?.acceptWalletPayment == 1 ? 1 : 0.3
        promoViewContainer.isHidden = branch?.acceptCoupons == 1 ? false : true
                
        CartServices.shared.getCartItems(itemId: "-1", branch: branch!.id) { [self] (items) in
            if let items = items{
                
                for item in items{
                    guard let itemVariations = item.variations?.getDecodedObject(from: [Variation].self) else { continue }
                    var variations = [LineItemVariation]()
                    for variation in itemVariations{
                        variations.append(
                            LineItemVariation(
                                id: variation.id,
                                options: variation.options!.map({ $0.id! })))
                    }
                    
                    lineItems.append(
                        LineItem(variations: variations,
                                 lineNotes: item.notes,
                                 quantity: Int(item.quantity),
                                 branchProductID: Int(item.product_id)))
                }
            }
        }
    }
    
    @objc func paymentDidFinish(sender: NSNotification){
        
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
            showToast("Transaction failed, please make sure you entered correct card information and the card is valid".localized)
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
        if let deliveryRegions = branch?.deliveryRegions{
            var pathCoords: [CLLocationCoordinate2D] = []
            deliveryRegions.forEach { region in
                region.coordinates.forEach { coord in
                    pathCoords.append(CLLocationCoordinate2DMake(Double(coord.split(separator: ",")[0])!, Double(coord.split(separator: ",")[1])!))
                }
            }
            Router.toAddAddress(self, MKPolyline(coordinates: pathCoords, count: pathCoords.count), MKPolygon(coordinates: pathCoords, count: pathCoords.count))
        }else{
            Router.toAddAddress(self, nil, nil)
        }
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
            walletBtn.setImage(UIImage(named: "radio_unselected"), for: .normal)
        case 1:
            guard branch?.creditOnDelivery == 1 else { return }
            creditOnDeliveryBtn.setImage(UIImage(named: "radio_selected"), for: .normal)
            cashOnDeliveryBtn.setImage(UIImage(named: "radio_unselected"), for: .normal)
            creditBtn.setImage(UIImage(named: "radio_unselected"), for: .normal)
            walletBtn.setImage(UIImage(named: "radio_unselected"), for: .normal)
        case 2:
            guard branch?.onlinePayment == 1 else { return }
            creditBtn.setImage(UIImage(named: "radio_selected"), for: .normal)
            cashOnDeliveryBtn.setImage(UIImage(named: "radio_unselected"), for: .normal)
            creditOnDeliveryBtn.setImage(UIImage(named: "radio_unselected"), for: .normal)
            walletBtn.setImage(UIImage(named: "radio_unselected"), for: .normal)
        case 3:
            guard branch?.acceptWalletPayment == 1 else { return }
            creditBtn.setImage(UIImage(named: "radio_unselected"), for: .normal)
            cashOnDeliveryBtn.setImage(UIImage(named: "radio_unselected"), for: .normal)
            creditOnDeliveryBtn.setImage(UIImage(named: "radio_unselected"), for: .normal)
            walletBtn.setImage(UIImage(named: "radio_selected"), for: .normal)
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
                sender.transform = CGAffineTransform(rotationAngle: .pi*2)
            }
        case 1:
            self.receiveViewHeight.constant = 60
            self.receiveOptionView.isHidden = true
            sender.tag = 0
            UIView.animate(withDuration: 0.2) {
                sender.transform = CGAffineTransform(rotationAngle: .pi)
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
                sender.transform = CGAffineTransform(rotationAngle: .pi*2)
            }
        case 1:
            self.paymentViewHeight.constant = 60
            self.paymentOptionView.isHidden = true
            sender.tag = 0
            UIView.animate(withDuration: 0.2) {
                sender.transform = CGAffineTransform(rotationAngle: .pi)
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
                sender.transform = CGAffineTransform(rotationAngle: .pi*2)
            }
        case 1:
            self.promoViewHeight.constant = 60
            self.promoView.isHidden = true
            sender.tag = 0
            UIView.animate(withDuration: 0.2) {
                sender.transform = CGAffineTransform(rotationAngle: .pi)
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
                sender.transform = CGAffineTransform(rotationAngle: .pi*2)
            }
            self.notesTV.becomeFirstResponder()
        case 1:
            self.notesHeight.constant = 0
            sender.tag = 0
            notesView.isHidden = true
            UIView.animate(withDuration: 0.2) {
                sender.transform = CGAffineTransform(rotationAngle: .pi)
            }
            self.view.endEditing(true)
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
        let alert = UIAlertController(title: "Cancel Payment".localized, message: "cancelling payment session will clear off your card details".localized, preferredStyle: .alert)
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
    
    
    @IBAction func validateCouponsTFdidChange(_ sender: UITextField) {
        
        activityIndicator.stopAnimating()
        validateBtn.isHidden = false
        verifiedCoupon.isHidden = true
        
        guard !couponsTF.text!.isEmpty else {
            validateBtn.alpha = 0.5
            validateBtn.isEnabled = false
            return
        }
        validateBtn.alpha = 1
        validateBtn.isEnabled = true
    }
    
    @IBAction func validateCouponsAction(_ sender: Any) {
    
        let validatable: ValidatableCoupon?
        coupons = self.couponsTF.text?.split(separator: ",").map({String($0).replacingOccurrences(of: " ", with: "")})
        
        validatable = ValidatableCoupon(coupons: coupons!, branchId: branch!.id, lineItems: lineItems)
        
        print(validatable)
        activityIndicator.startAnimating()
        validateBtn.isHidden = true
        verifiedCoupon.isHidden = true
        view.endEditing(true)
        
        presenter?.validateCoupons(validatable!)
    }
    
    
    @IBAction func placeOrderAction(_ sender: Any) {
        
        guard branch?.isOpen == 1 else {
            showAlert(title: "", message: "lang".localized == "en" ?  "Sorry, we can`t procced your order because \(branch!.name!.en ?? "") maybe closed or busy right now, please try reorder when the vendor is available" : "عذرًا ، لا يمكننا متابعة طلبك لأنه \(branch!.name!.ar ?? "") ربما يكون مغلقًا أو مشغولاً الآن ، يرجى محاولة إعادة الطلب عندما يكون المتجر متاحًا")
            return
        }
        
        if selectedPayment == 2{
            showPaySheet()
            return
        }
        
        guard !username.text!.isEmpty else {
            nameStack.shake(.error)
            scroller.setContentOffset(nameStack.frame.origin, animated: true)
            return
        }
        
        guard !phoneNumber.text!.isEmpty else {
            phoneStack.shake(.error)
            scroller.setContentOffset(phoneStack.frame.origin, animated: true)
            return
        }
        
        guard let selectedReceiveOption = selectedReceiveOption else{
            receiveView.shake(.error)
            scroller.setContentOffset(receiveView.frame.origin, animated: true)
            return
        }
        
        guard let selectedPayment = selectedPayment else {
            paymentView.shake(.error)
            scroller.setContentOffset(paymentView.frame.origin, animated: true)
            return
        }
        
        if selectedReceiveOption == 0{
            guard let _ = (self.addresses?.filter({ return $0.selected == 1 }).first) else {
                addressStack.shake(.error)
                scroller.setContentOffset(addressStack.frame.origin, animated: true)
                return
            }
            if let deliveryRegions = branch?.deliveryRegions{
                var polygonCoords: [CLLocationCoordinate2D] = []
                deliveryRegions.forEach { region in
                    region.coordinates.forEach { coord in
                        polygonCoords.append(CLLocationCoordinate2DMake(Double(coord.split(separator: ",")[0])!, Double(coord.split(separator: ",")[1])!))
                    }
                }
                
                let polygon = MKPolygon(coordinates: polygonCoords, count: polygonCoords.count)
                let polygonRenderer = MKPolygonRenderer(polygon: polygon)
                
                guard let selectedAddress = (self.addresses?.filter({ return $0.selected == 1 }).first!) else { return }
                let coordinate = CLLocationCoordinate2D(latitude: Double(selectedAddress.coordinates!.split(separator: ",")[0])!, longitude: Double(selectedAddress.coordinates!.split(separator: ",")[1])!)
                let mapPoint: MKMapPoint = MKMapPoint(coordinate)
                let polygonViewPoint: CGPoint = polygonRenderer.point(for: mapPoint)
                
                if !polygonRenderer.path.contains(polygonViewPoint) {
                    print("Your location was inside your polygon.")
                    let alert = UIAlertController(title: "", message: "Your address is out of vendor delivery area bounds".localized, preferredStyle: .alert)
                    let addAction = UIAlertAction(title: "Add New Address".localized, style: .default) { _ in
                        Router.toAddAddress(self, MKPolyline(coordinates: polygonCoords, count: polygonCoords.count), polygon)
                    }
                    let cencel = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
                    alert.addAction(addAction)
                    alert.addAction(cencel)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
            }
        }
        
        let order = Order(deliveryMethod: selectedReceiveOption,
                          paymentMethod: selectedPayment,
                          addressID: (addresses?.filter({ return $0.selected == 1 }))?.first?.id ?? 0,
                          customerNote: notesTV.text!,
                          couponID: coupons ?? [],
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

