//
//  CheckoutVC+PayDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 06/06/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import MPGSDK
import UIKit
import SVProgressHUD

extension CheckoutVC: PayDelegate{
    
    func didCompleteCreateSession(_ session: String?) {
        guard let session = session else {
            SVProgressHUD.dismiss()
            return
        }
        transaction = Transaction()
        transaction?.session = session
       // transaction?.orderId = "order17"
        transaction?.amount = 1.0
        transaction?.currency = "EGP"
        payPresenter?.updateSessionWithOrder(transaction: transaction!)
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
        
        transaction?.nameOnCard = cardHolderTF.text!
        transaction?.cardNumber = cardNumberTF.text!.replacingOccurrences(of: " ", with: "")
        transaction?.expiryMM = String(expiryTF.text!.split(separator: "/").first!)
        transaction?.expiryYY = String(expiryTF.text!.split(separator: "/")[1])
        transaction?.cvv = cvvTF.text!
        
        payPresenter?.updateSessionWithPayerData(transaction: transaction!)
        
    }
    
    func didCompleteUpdateSessionWithPayerData(_ success: Bool) {
        if success{
            payPresenter?.check3DSEnrollment(transaction: transaction!)
        }else{
            SVProgressHUD.dismiss()
        }
    }
    
    func didCompleteCheck3DSEnrollment(_ proceed: Bool) {
        if proceed{
            payPresenter?.authPayer(transaction: transaction!)
        }else{
            SVProgressHUD.dismiss()
        }
    }
    
    func didCompleteAuthPayerWith(_ redirectHtml: String?) {
        if let redirectHtml = redirectHtml{
            SVProgressHUD.dismiss()
            let threeDSecureView = Gateway3DSecureViewController(nibName: nil, bundle: nil)
            present(threeDSecureView, animated: true)
            
            threeDSecureView.title = ""
            threeDSecureView.navBar.tintColor = UIColor(named: "Main")
            
            threeDSecureView.authenticatePayer(htmlBodyContent: redirectHtml) {
                authView, result in
                
                print("dismiss web view ")
                
                authView.dismiss(animated: true, completion: {
                    switch result {
                    case .error(let error):
                        print("error in web view ",error)
                    case .completed(gatewayResult: let response):
                        // check for version 46 and earlier api authentication failures and then version 47+ failures
                        print("3ds response from web view",response)
//                        if Int(self.transaction.session!.apiVersion)! <= 46, let status = response[at: "3DSecure.summaryStatus"] as? String , status == "AUTHENTICATION_FAILED" {
//                        } else if let status = response[at: "response.gatewayRecommendation"] as? String, status == "DO_NOT_PROCEED"  {
//                        } else {
//                            // if authentication succeeded, continue to proceess the payment
//                           // self.prepareForProcessPayment()
//                        }
                    default:
                        break
                    }
                })
            }
        }else{
            SVProgressHUD.dismiss()
        }
    }
    
}
