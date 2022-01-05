//
//  LoginVC+LoginViewDelegate.swift
//  TheBest-iOS
//
//  Created by Sherif Darwish on 7/21/20.
//  Copyright © 2020 Sherif Darwish. All rights reserved.
//

import Foundation
import SVProgressHUD

extension LoginVC: LoginViewDelegate{
    
    func showSVProgress() {
        self.view.endEditing(true)
        SVProgressHUD.show()
    }
    
    func dismissSVProgress() {
        SVProgressHUD.dismiss()
    }
    
    func didSuccessSendingCode() {
        
        self.titleHeader.text = "Enter your code"
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.sendCodeBtn.alpha = 0
            self.phoneContainer.alpha = 0
            self.codeView.alpha = 1
            
        }) { (_) in
            
            self.sendCodeBtn.isHidden = true
            self.codeView.isHidden = false
            self.phoneContainer.isHidden = true
            self.code1.becomeFirstResponder()
            
        }
        
    }
    
    func didSuccessLogin(uid: String) {
        
        let prms: [String: String] = [
            "uid": uid,
            "device_token": UserDefaults.init().string(forKey: "FCM_Token") ?? "",
            "notification_lang": "lang".localized
        ]
        loginViewPresenter?.signinToApi(prms: prms)
    }
    
    func didFailSendingCode() {
        
        SVProgressHUD.dismiss()
        self.showAlert(title: "", message: "Please make sure you entered a correct phone number")
        
    }
    
    func didFailLogin() {
        
        self.showAlert(title: "", message: "error login")
        
    }
    
    func didCompleteWithNewUser() {

    }
    
    func didCompleteSignToApi() {
        if Shared.userSelectLocation == false{
            Router.toAskLocation(self)
        }else{
            Router.toHome(self, true)
        }
        //  Router.toMaps(self)
    }
    
    func didCompleteSignToApiWithError() {
        print("didCompleteSignToApiWithError")
    }
    
    
}
