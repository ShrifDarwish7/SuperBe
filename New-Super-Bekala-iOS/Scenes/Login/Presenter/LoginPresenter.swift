//
//  LoginPresenter.swift
//  TheBest-iOS
//
//  Created by Sherif Darwish on 7/21/20.
//  Copyright © 2020 Sherif Darwish. All rights reserved.
//

import Foundation
import FirebaseAuth
import SwiftyJSON

protocol LoginViewDelegate {
    
    func showSVProgress()
    func dismissSVProgress()
    func didSuccessSendingCode()
    func didSuccessLogin(uid: String)
    func didFailSendingCode()
    func didFailLogin()
    func didCompleteWithNewUser()
    func didCompleteSignToApi()
    func didCompleteSignToApiWithError()
    
}

extension LoginViewDelegate{
    func showSVProgress(){}
    func dismissSVProgress(){}
    func didSuccessSendingCode(){}
    func didSuccessLogin(uid: String){}
    func didFailSendingCode(){}
    func didFailLogin(){}
    func didCompleteWithNewUser(){}
    func didCompleteSignToApi(){}
    func didCompleteSignToApiWithError(){}
}

class LoginViewPresenter{
    
    private var loginViewDelegate: LoginViewDelegate?
    
    init(loginViewDelegate: LoginViewDelegate) {
        self.loginViewDelegate = loginViewDelegate
    }
    
    func sendCodeTo(_ phone: String){
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { (verificationID, error) in
            if error != nil {
                self.loginViewDelegate?.didFailSendingCode()
                print(error)
                return
            }

            UserDefaults.init().set(verificationID, forKey: "authVerificationID")
            self.loginViewDelegate?.didSuccessSendingCode()
            
        }
        
    }
    
    func signInWith(code: String){
        
        loginViewDelegate?.showSVProgress()
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: UserDefaults.init().string(forKey: "authVerificationID")!,
            verificationCode: code)
        
        APIServices.shared.signinWith(credential: credential) { (uid) in
            self.loginViewDelegate?.dismissSVProgress()
            if let uid = uid{
                self.loginViewDelegate?.didSuccessLogin(uid: uid)
            }else{
                self.loginViewDelegate?.didFailLogin()
            }
        }
                
    }
    
    func signWithCredential(credential: AuthCredential){
        self.loginViewDelegate?.showSVProgress()
        APIServices.shared.signinWith(credential: credential) { (uid) in
            self.loginViewDelegate?.dismissSVProgress()
            if let uid = uid{
                self.loginViewDelegate?.didSuccessLogin(uid: uid)
            }else{
                self.loginViewDelegate?.didFailLogin()
            }
        }
    }
    
    func signinToApi(prms: [String: String]){
        self.loginViewDelegate?.showSVProgress()
        APIServices.shared.call(.login(prms)) { (data) in
            print(JSON(data!))
            self.loginViewDelegate?.dismissSVProgress()
            if let data = data,
               let model = data.getDecodedObject(from: LoginResponse.self){
                APIServices.shared.isLogged = true
                APIServices.shared.user = model.data
                self.loginViewDelegate?.didCompleteSignToApi()
            }else{
                self.loginViewDelegate?.didCompleteSignToApiWithError()
            }
        }
    }
    
}
