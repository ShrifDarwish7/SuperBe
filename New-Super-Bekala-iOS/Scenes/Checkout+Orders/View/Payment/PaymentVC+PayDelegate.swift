//
//  PaymentVC+PayDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 06/06/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

extension PaymentVC: PayDelegate{
    
    
    func didCompleteCreateSession(_ session: String?) {
        guard let session = session else {
            SVProgressHUD.dismiss()
            return
        }
       
        Shared.transaction?.session = session
       // transaction.orderId = "order17"
//        transaction.amount = 1.0
//        transaction.currency = "EGP"
        payPresenter?.updateSessionWithOrder()
    }
    
    func didCompleteUpdateSessionWithOrder(_ success: Bool) {
        guard success == true else {
            SVProgressHUD.dismiss()
            return
        }
        guard !cardNumberTF.text!.isEmpty else {
            SVProgressHUD.dismiss()
            showToast("Enter card number")
            return
        }
        guard !expiryTF.text!.isEmpty else {
            SVProgressHUD.dismiss()
            showToast("Enter expiry date")
            return
        }
        guard !cvvTF.text!.isEmpty else {
            SVProgressHUD.dismiss()
            showToast("Enter security code")
            return
        }
        guard cvvTF.text!.count == 3 else {
            SVProgressHUD.dismiss()
            showToast("Enter correct security code")
            return
        }
        
        Shared.transaction?.nameOnCard = cardHolderTF.text!
        Shared.transaction?.cardNumber = cardNumberTF.text!.replacingOccurrences(of: " ", with: "")
        Shared.transaction?.expiryMM = String(expiryTF.text!.split(separator: "/").first!)
        Shared.transaction?.expiryYY = String(expiryTF.text!.split(separator: "/")[1])
        Shared.transaction?.cvv = cvvTF.text!
        
        payPresenter?.updateSessionWithPayerData()
        
    }
    
    func didCompleteUpdateSessionWithPayerData(_ success: Bool) {
        if success{
            payPresenter?.check3DSEnrollment()
        }else{
            SVProgressHUD.dismiss()
        }
    }
    
    func didCompleteCheck3DSEnrollment(_ proceed: Bool,_ redirectURL: String?) {
        guard let redirectURL = redirectURL else { return }
        self.redirectURL = redirectURL
        if proceed{
            payPresenter?.authPayer(redirectURL)
        }else{
            SVProgressHUD.dismiss()
        }
    }
    
    func didCompleteAuthPayerWith(_ redirectHtml: String?, _ redirectUrl: String?) {
        
        if let redirectHtml = redirectHtml,
           let redirectUrl = redirectUrl{
            SVProgressHUD.dismiss()
            
            let nav = Router.instantiate(appStoryboard: .orders, identifier: "ThreeDSecureNav") as! UINavigationController
            
            let threeDSecureVC = nav.viewControllers.first as! ThreeDSecureVC
            threeDSecureVC.html = redirectHtml
            threeDSecureVC.url = redirectUrl
            self.present(nav, animated: true, completion: nil)
           
        }else{
            SVProgressHUD.dismiss()
        }
    }
    
    func didCompleteVerifyPayerWith(_ authToken: String?, _ transactionId: String?, _ enrolled: String?) {
        SVProgressHUD.dismiss()
        if let authToken = authToken,
           let transactionId = transactionId,
           let enrolled = enrolled{
            SVProgressHUD.show()
            self.payPresenter?.performPay(authToken, transactionId, enrolled)
        }else{
            showToast("Transaction failed, please make sure you entered correct card information and the card is valid".localized)
        }
    }
    
    func didCompletePerformPay(_ success: Bool, _ transactionId: String?) {
        
        SVProgressHUD.dismiss()
        self.parent?.dismiss(animated: true, completion: nil)
        self.delegate?.onPayment(success, transactionId ?? "")
      
    }
    
}
