//
//  CheckoutVC+PayButtonDelegate.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 14/11/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import PayButton

extension CheckoutVC: PaymentDelegate{
    func finishSdkPayment(_ receipt: TransactionStatusResponse) {        
        if receipt.Success {
            let order = Order(deliveryMethod: selectedReceiveOption!,
                              paymentMethod: selectedPayment!,
                              addressID: (addresses?.filter({ return $0.selected == 1 }))?.first?.id ?? 0,
                              customerNote: notesTV.text!,
                              couponID: coupons ?? [],
                              branchID: branch!.id,
                              bankOrderId: receipt.ReceiptNumber,
                              phone: verifiedPhoneNumber ?? phoneNumber.text?.arToEnDigits!,
                              lineItems: lineItems)
            
            self.presenter?.placeOrder(order)
        }else {
            self.creditBtn.setImage(UIImage(named: "radio_unselected"), for: .normal)
            self.selectedPayment = nil
        }
    }
}
