//
//  LoginVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Super Bekala on 7/12/20.
//  Copyright © 2020 Super Bekala. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftyJSON
import FacebookCore
import FacebookLogin
import Alamofire

class LoginVC: UIViewController {
    
    @IBOutlet weak var backBtn1: UIButton!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var loginWithPhoneView: UIView!
    @IBOutlet weak var phoneContainer: UIView!
    @IBOutlet weak var backBtn2: UIButton!
    @IBOutlet weak var sendCodeBtn: UIView!
    @IBOutlet weak var titleHeader: UILabel!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var code1: UITextField!
    @IBOutlet weak var code2: UITextField!
    @IBOutlet weak var code3: UITextField!
    @IBOutlet weak var code4: UITextField!
    @IBOutlet weak var code5: UITextField!
    @IBOutlet weak var code6: UITextField!
    @IBOutlet weak var codeView: UIView!
    @IBOutlet weak var resendBtn: UIButton!
    @IBOutlet weak var blurBlockView: UIVisualEffectView!
    
    @IBOutlet weak var googleLogin: UIView!
    @IBOutlet weak var fbLogin: UIView!
    @IBOutlet weak var phoneLogin: UIView!
    
    var loginViewPresenter: LoginViewPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveGoogleCredential(sender:)), name: NSNotification.Name("GoogleCredential"), object: nil)
        
        loginViewPresenter = LoginViewPresenter(loginViewDelegate: self)
        
        code1.addTarget(self, action: #selector(beginEnterCode(textField:)), for: .editingChanged)
        code2.addTarget(self, action: #selector(beginEnterCode(textField:)), for: .editingChanged)
        code3.addTarget(self, action: #selector(beginEnterCode(textField:)), for: .editingChanged)
        code4.addTarget(self, action: #selector(beginEnterCode(textField:)), for: .editingChanged)
        code5.addTarget(self, action: #selector(beginEnterCode(textField:)), for: .editingChanged)
        code6.addTarget(self, action: #selector(beginEnterCode(textField:)), for: .editingChanged)
        
        loadUI()
        loadActions()
    }
    
    func loadUI(){
        
        gradientView.setGradientBackground(color: UIColor.black, color: UIColor.red)
        
        sendCodeBtn.layer.cornerRadius = 15
        sendCodeBtn.setupShadow()
        
        phoneContainer.layer.cornerRadius = 15
        phoneContainer.setupShadow()
        
        blurBlockView.alpha = 0
        blurBlockView.isHidden = true
        loginWithPhoneView.alpha = 0
        loginWithPhoneView.isHidden = true
        
        googleLogin.layer.cornerRadius = 15
        fbLogin.layer.cornerRadius = 15
        phoneLogin.layer.cornerRadius = 15
        
    }
    
    func loadActions(){
        
        backBtn2.onTap {
            
            self.view.endEditing(true)
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.blurBlockView.alpha = 0
                self.loginWithPhoneView.alpha = 0
                
            }) { (_) in
                
                self.blurBlockView.isHidden = true
                self.phoneContainer.isHidden = true
                
            }
            
        }
        
        phoneLogin.addTapGesture { (_) in
            
            self.blurBlockView.isHidden = false
            self.loginWithPhoneView.isHidden = false
            self.phoneContainer.isHidden = false
            self.sendCodeBtn.isHidden = false
            self.titleHeader.text = "Please enter your number to login"
            self.code1.text = ""
            self.code2.text = ""
            self.code3.text = ""
            self.code4.text = ""
            self.code5.text = ""
            self.code6.text = ""
            
            UIView.animate(withDuration: 0.5, animations: {
                self.blurBlockView.alpha = 0.9
                self.loginWithPhoneView.alpha = 1
                self.phoneContainer.alpha = 1
                self.codeView.alpha = 0
                self.sendCodeBtn.alpha = 1
            }) { (_) in
                self.codeView.isHidden = true
            }
            
        }
        
        sendCodeBtn.addTapGesture { (_) in
            
            guard !self.phoneTF.text!.isEmpty else {return}
            
            if (self.phoneTF.text?.starts(with: "1"))! && self.phoneTF.text?.count == 10 {
                self.loginViewPresenter?.sendCodeTo("+20" + self.phoneTF.text!)
            }
            
        }
        
    }
    
    @objc func didReceiveGoogleCredential(sender: NSNotification){
        if let credential = sender.userInfo!["GoogleCredential"]{
            print(credential)
            self.loginViewPresenter?.signWithCredential(credential: credential as! AuthCredential)
        }
    }
    
    @IBAction func signinWithGoogleAction(_ sender: Any) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    @IBAction func signinWithFacebookAction(_ sender: Any) {
        let fbLoginManager = LoginManager()
        fbLoginManager.logOut()
        fbLoginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (result) in
            let accessToken = AccessToken.current?.authenticationToken
            GraphRequest(graphPath: "me", parameters: ["fields":"email,name"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: .defaultVersion).start { (res, result) in
              
                let json = JSON(result)
                print(json)
                UserDefaults.init().set(accessToken, forKey: "token")
                UserDefaults.init().set("facebook", forKey: "type")
                UserDefaults.init().set(json["name"].stringValue, forKey: "name")
                UserDefaults.init().set(json["email"].stringValue, forKey: "email")
                UserDefaults.init().set("http://graph.facebook.com/\(json["id"].stringValue)/picture?type=large&width=240&height=240", forKey: "image")
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken!)
                self.loginViewPresenter?.signWithCredential(credential: credential)
            }
            
            
        }
        
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
        self.loginViewPresenter?.signInWith(code: code + self.code6.text!)
        
    }
    
}
