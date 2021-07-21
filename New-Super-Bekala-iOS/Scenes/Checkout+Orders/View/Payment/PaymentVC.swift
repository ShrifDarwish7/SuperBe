//
//  PaymentVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 08/06/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import SVProgressHUD

class PaymentVC: UIViewController {
    
    @IBOutlet weak var cardHolderTF: UITextField!
    @IBOutlet weak var cardNumberTF: UITextField!
    @IBOutlet weak var expiryTF: UITextField!
    @IBOutlet weak var cvvTF: UITextField!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var amountStack: UIStackView!
    
    var payPresenter: PayPresenter?
    var redirectURL: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishthreeDSecure), name: NSNotification.Name("DID_FINISH_3DS"), object: nil)
        
        if Shared.transaction?.amount == nil{
            amountStack.isHidden = false
        }else{
            amountStack.isHidden = true
        }
        
    }
    
    @IBAction func cardNameTFdidChange(_ sender: UITextField) {
        sender.text = sender.text!.arToEnDigits
    }
    
    
    @IBAction func cardNumberTFdidChange(_ sender: UITextField) {
        guard sender.text!.count <= 19 else {
            sender.text = String(sender.text!.dropLast(1))
            return
        }
        sender.text = sender.text!.arToEnDigits
        if sender.text!.count == 4 || sender.text!.count == 9 || sender.text!.count == 14{
            sender.text = sender.text! + " "
        }
    }
    
    @IBAction func expiryTFdidChange(_ sender: UITextField) {
        guard sender.text!.count <= 5 else {
            sender.text = String(sender.text!.dropLast(1))
            return
        }
        
        sender.text = sender.text!.arToEnDigits
        
        if !(sender.text?.starts(with: "1"))! && sender.text!.count < 2{
            let temp = sender.text
            sender.text = ""
            sender.text = "0" + temp! + "/"
        }else if sender.text!.starts(with: "1") && sender.text!.count == 2{
            let index = sender.text!.index(sender.text!.startIndex, offsetBy: 1)
            let secondDigit = sender.text![index]
            guard Int(String(secondDigit).arToEnDigits!)! < 3 else {
                sender.text = String(sender.text!.dropLast(1))
                return
            }
            sender.text = sender.text! + "/"
        }else if sender.text!.count == 2{
            sender.text = sender.text! + "/"
        }
    }
    
    @IBAction func cvvTFdidChange(_ sender: UITextField) {
        sender.text = sender.text!.arToEnDigits
    }

    @IBAction func makePayment(_ sender: Any) {
        
        if Shared.transaction?.amount == nil{
            guard !amountTF.text!.isEmpty else{
                showToast("Enter amount")
                return
            }
            Shared.transaction = Transaction()
            Shared.transaction?.amount = Double(amountTF.text!)!
            Shared.transaction?.currency = "EGP"
        }
        
        payPresenter = PayPresenter(delegate: self)
        payPresenter?.createSession()
        SVProgressHUD.show()
    }
    
    @objc func didFinishthreeDSecure(){
        SVProgressHUD.show()
        payPresenter?.authPayer(self.redirectURL!)
        
    }
    
}

extension PaymentVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            if textField === expiryTF{
                if expiryTF.text!.count == 5{
                    expiryTF.text = String(expiryTF.text!.dropLast(2))
                }else{
                    expiryTF.text = ""
                }
            }else if textField == cardNumberTF{
                if cardNumberTF.text!.count == 5 || cardNumberTF.text!.count == 10 || cardNumberTF.text!.count == 15{
                    cardNumberTF.text = String(cardNumberTF.text!.dropLast(1))
                }
            }
        }
        
        
        return true
    }
}
