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
import UIKit

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
    func didCompleteUpdateProfile()
    func didCompleteWithProfile(_ error: String?)
    func didCompleteWithSetting(_ data: Setting?)
    func didCompleteLogout(_ error: String?)
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
    func didCompleteUpdateProfile(){}
    func didCompleteWithProfile(_ error: String?){}
    func didCompleteWithSetting(_ data: Setting?){}
    func didCompleteLogout(_ error: String?){}
}

class LoginViewPresenter{
    
    private var loginViewDelegate: LoginViewDelegate?
    
    init(loginViewDelegate: LoginViewDelegate) {
        self.loginViewDelegate = loginViewDelegate
    }
    
    func logout(){
        loginViewDelegate?.showSVProgress()
        APIServices.shared.call(.logout) { [self] data in
            loginViewDelegate?.dismissSVProgress()
            if let data = data, let json = try? JSON(data: data), json["status"].intValue == 1 {
                loginViewDelegate?.didCompleteLogout(nil)
            }else{
                loginViewDelegate?.didCompleteLogout(Shared.errorMsg)
            }
        }
    }
    
    func getSetting(){
        APIServices.shared.call(.setting) { [self] data in
            if let data = data, let response = data.getDecodedObject(from: SettingResponse.self){
                loginViewDelegate?.didCompleteWithSetting(response.data)
            }else{
                loginViewDelegate?.didCompleteWithSetting(nil)
            }
        }
    }
    
    func getProfile(){
        loginViewDelegate?.showSVProgress()
        APIServices.shared.call(.getProfile) { data in
            self.loginViewDelegate?.dismissSVProgress()
            print(JSON(data))
            if let data = data,
               let response = data.getDecodedObject(from: LoginResponse.self){
                APIServices.shared.user = response.data
                self.loginViewDelegate?.didCompleteWithProfile(nil)
            }else{
                self.loginViewDelegate?.didCompleteWithProfile(Shared.errorMsg)
            }
        }
    }
    
    func updateProfile(_ prms: [String: String]){
       // guard let user = APIServices.shared.user else { return }
        //guard user.notificationsLang != "lang".localized else { return }
        APIServices.shared.call(.updateProfile(prms)) { data in
            print(JSON(data))
            if let data = data,
               let response = data.getDecodedObject(from: LoginResponse.self){
                APIServices.shared.user = response.data
                self.loginViewDelegate?.didCompleteUpdateProfile()
            }
        }
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
            self.loginViewDelegate?.dismissSVProgress()
            if let data = data,
               let model = data.getDecodedObject(from: LoginResponse.self){
                if model.status == 0, let message = model.message{
                    let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok".localized, style: .default, handler: nil))
                    UIApplication.getTopViewController()!.present(alert, animated: true, completion: nil)
                }else{
                    APIServices.shared.isLogged = true
                    APIServices.shared.skipFromLogin = true
                    APIServices.shared.user = model.data
                    UserDefaults.init().setValue((APIServices.shared.user?.token ?? ""), forKey: "token")
                    Shared.headers.updateValue("Bearer " + (APIServices.shared.user?.token ?? ""), forKey: "Authorization")
                    self.loginViewDelegate?.didCompleteSignToApi()
                }
            }else{
                self.loginViewDelegate?.didCompleteSignToApiWithError()
            }
        }
    }
    
}
