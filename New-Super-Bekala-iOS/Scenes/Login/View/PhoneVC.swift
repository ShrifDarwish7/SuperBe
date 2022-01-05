//
//  PhoneVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 10/11/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD

class PhoneVC: UIViewController, PhoneVerifyDelegate {
    
    func onVerify() {
        if Shared.userSelectLocation == false{
            Router.toAskLocation(self)
        }else{
            Router.toHome(self,true)
        }
    }
    
    func onCancelVerify() {
        
    }
    
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var tfBottomCnst: NSLayoutConstraint!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        phoneTF.becomeFirstResponder()
        Auth.auth().languageCode = "lang".localized
    }
    @IBAction func back(_ sender: Any) {
        if let _ = navigationController{
            if (navigationController?.viewControllers.count)! > 1{
                navigationController?.popViewController(animated: true)
            }else{
                navigationController?.dismiss(animated: true, completion: nil)
            }
        }else{
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func next(_ sender: Any) {
        guard let phoneNumber = phoneTF.text!.arToEnDigits else { return }
        print(phoneNumber)
        SVProgressHUD.show()
        PhoneAuthProvider.provider()
            .verifyPhoneNumber("+2" + phoneNumber.replacingOccurrences(of: "+2", with: ""), uiDelegate: nil) { verificationID, error in
                SVProgressHUD.dismiss()
                if let error = error {
                    print(error.localizedDescription)
                    self.showAlert(title: nil, message: error.localizedDescription)
                    return
                }
                // Sign in using the verificationID and the code sent to the user
                // ...
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                Router.toVerifyPhoneFromFirebase(self, phoneNumber)
            }
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue) {
            let keyboardRectangle = keyboardSize.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            UIView.animate(withDuration: 0.1) {
                self.tfBottomCnst.constant = keyboardHeight
                self.view.layoutIfNeeded()
            }
        }
    }
    
}
