//
//  VerifyPhoneVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 15/09/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import SVProgressHUD
import FirebaseAuth

protocol PhoneVerifyDelegate {
    func onVerify()
    func onCancelVerify()
}

class VerifyPhoneVC: UIViewController {

    @IBOutlet weak var code1: UITextField!
    @IBOutlet weak var code2: UITextField!
    @IBOutlet weak var code3: UITextField!
    @IBOutlet weak var code4: UITextField!
    @IBOutlet weak var code5: UITextField!
    @IBOutlet weak var code6: UITextField!
    
    var delegate: PhoneVerifyDelegate?
    var phone: String?
    var presenter: MainPresenter?
    var provider = SmsProvider.smsegy
    var loginViewPresenter: LoginViewPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MainPresenter(self)
        loginViewPresenter = LoginViewPresenter(loginViewDelegate: self)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {
            self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        }
        
        code1.becomeFirstResponder()
        
        code1.addTarget(self, action: #selector(beginEnterCode(textField:)), for: .editingChanged)
        code2.addTarget(self, action: #selector(beginEnterCode(textField:)), for: .editingChanged)
        code3.addTarget(self, action: #selector(beginEnterCode(textField:)), for: .editingChanged)
        code4.addTarget(self, action: #selector(beginEnterCode(textField:)), for: .editingChanged)
        code5.addTarget(self, action: #selector(beginEnterCode(textField:)), for: .editingChanged)
        code6.addTarget(self, action: #selector(beginEnterCode(textField:)), for: .editingChanged)

    }
    
    @objc func beginEnterCode(textField: UITextField){
        
        let  char = textField.text!.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        switch textField.tag{
        case 1:
            if (isBackSpace == -92) {
                break
            }
            code2.becomeFirstResponder()
        case 2:
            if (isBackSpace == -92) {
                code1.becomeFirstResponder()
                break
            }
            code3.becomeFirstResponder()
        case 3:
            if (isBackSpace == -92) {
                code2.becomeFirstResponder()
                break
            }
            code4.becomeFirstResponder()
        case 4:
            if (isBackSpace == -92) {
                code3.becomeFirstResponder()
                break
            }
            code5.becomeFirstResponder()
        case 5:
            if (isBackSpace == -92) {
                code4.becomeFirstResponder()
                break
            }
            code6.becomeFirstResponder()
        case 6:
            if (isBackSpace == -92) {
                code5.becomeFirstResponder()
                break
            }
            code6.becomeFirstResponder()
        default:
            break
        }
        
        guard !(self.code1.text?.isEmpty)!,!(self.code2.text?.isEmpty)!,!(self.code3.text?.isEmpty)!,!(self.code4.text?.isEmpty)!,!(self.code5.text?.isEmpty)!, !(self.code6.text?.isEmpty)! else {
            return
        }
        let code = (self.code1.text! + self.code2.text! + self.code3.text! + self.code4.text! + self.code5.text!)
        
        view.endEditing(true)
        switch provider {
        case .smsegy:
            presenter!.verifyOTP(code + self.code6.text!)
        case .firebase:
            let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID!,
              verificationCode: code + self.code6.text!
            )
            self.loginViewPresenter?.signWithCredential(credential: credential)
        }
    }

    @IBAction func closeAction(_ sender: Any) {
        switch provider {
        case .smsegy:
            SVProgressHUD.show()
            loginViewPresenter!.getProfile()
        default:
            self.view.backgroundColor = .clear
            self.dismiss(animated: true, completion: nil)
            delegate?.onCancelVerify()
        }
    }
    
    @IBAction func requestOtp(_ sender: Any) {
        presenter!.requestOTP(phone!)
    }
}

extension VerifyPhoneVC: MainViewDelegate, LoginViewDelegate{
    func didCompleteWithProfile(_ error: String?) {
        SVProgressHUD.dismiss()
        self.view.backgroundColor = .clear
        self.dismiss(animated: true, completion: nil)
        delegate?.onCancelVerify()
    }
    func didCompletedRequestOtp(_ error: String?) {
        if let error = error{
            showToast(error)
        }
    }
    func didCompleteVerifyPhoneNumber(_ error: String?) {
        if let error = error{
            showToast(error)
        }else{
            view.backgroundColor = .clear
            dismiss(animated: true, completion: nil)
            delegate?.onVerify()
        }
    }
    func showSVProgress() {
        self.view.endEditing(true)
        SVProgressHUD.show()
    }
    
    func dismissSVProgress() {
        SVProgressHUD.dismiss()
    }
    
    func didSuccessLogin(uid: String) {
        let prms: [String: String] = [
            "uid": uid,
            "device_token": UserDefaults.init().string(forKey: "FCM_Token") ?? "",
            "notification_lang": "lang".localized
        ]
        loginViewPresenter?.signinToApi(prms: prms)
    }
    func didFailLogin() {
        self.showAlert(title: "", message: Shared.errorMsg)
    }
    func didCompleteSignToApi() {
        view.backgroundColor = .clear
        dismiss(animated: true, completion: nil)
        delegate?.onVerify()
        
//        if self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)!-3].isKind(of: SplashVC.self) == true{
//
//            if Shared.userSelectLocation == false{
//                Router.toAskLocation(self)
//            }else{
//                Router.toHome(self,true)
//            }
//        }else{
//            self.view.backgroundColor = .clear
//            self.dismiss(animated: true, completion: nil)
//            //self.loginDelegate?.onLogin()
//        }
    }
}

enum SmsProvider{
    case firebase
    case smsegy
}
