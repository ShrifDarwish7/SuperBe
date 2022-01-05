//
//  RegisterVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 02/09/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
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
import SwiftyGif
import SVProgressHUD
import AuthenticationServices
import CryptoKit
import AVFoundation

protocol LoginDelegate {
    func onLogin()
    func onLogout()
}

class RegisterVC: UIViewController {
    
    @IBOutlet weak var introImageView: UIImageView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    
    var loginViewPresenter: LoginViewPresenter?
    var currentNonce: String?
    var loginDelegate: LoginDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginViewPresenter = LoginViewPresenter(loginViewDelegate: self)

        let path = Bundle.main.path(forResource: "intro", ofType: "mp4")!
        let url = URL(fileURLWithPath: path)
        let avPlayer = AVPlayer(playerItem: AVPlayerItem(url: url))
        avPlayer.play()
        let avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.frame = introImageView.bounds
        avPlayerLayer.videoGravity = .resizeAspectFill
        introImageView.layer.insertSublayer(avPlayerLayer, at: 0)
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem, queue: .main) { _ in
            avPlayer.seek(to: CMTime.zero)
            avPlayer.play()
        }
        
      //  NotificationCenter.default.addObserver(self, selector: #selector(didReceiveGoogleCredential(sender:)), name: NSNotification.Name("GoogleCredential"), object: nil)
        
        if let _ = self.navigationController{
            closeBtn.isHidden = true
        }else{
            skipBtn.isHidden = true
            introImageView.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {
                self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
            }
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        loginViewPresenter = nil
    }
    
    @IBAction func skipAction(_ sender: Any) {
        APIServices.shared.isLogged = false
        APIServices.shared.skipFromLogin = true
        if Shared.userSelectLocation == false{
            Router.toAskLocation(self)
        }else{
            Router.toHome(self, true)
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.view.backgroundColor = .clear
        self.dismiss(animated: true, completion: nil)
    }
    
//    @objc func didReceiveGoogleCredential(sender: NSNotification){
//        if let credential = sender.userInfo!["GoogleCredential"]{
//            print(credential)
//            self.loginViewPresenter?.signWithCredential(credential: credential as! AuthCredential)
//        }
//    }
    
    @IBAction func googleAction(_ sender: Any) {
//        GIDSignIn.sharedInstance()?.presentingViewController = self
//        GIDSignIn.sharedInstance().signIn()
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in

          if let error = error {
              showAlert(title: nil, message: error.localizedDescription)
            return
          }

          guard
            let authentication = user?.authentication,
            let idToken = authentication.idToken
          else {
            return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: authentication.accessToken)

            self.loginViewPresenter?.signWithCredential(credential: credential)
        }
    }
    
    @IBAction func facebookAction(_ sender: Any) {
        let fbLoginManager = LoginManager()
        fbLoginManager.logOut()
        fbLoginManager.logIn(permissions: [], viewController: self) { (result) in
            guard let token = AccessToken.current?.tokenString else { return }
            let credential = FacebookAuthProvider
              .credential(withAccessToken: token)
            self.loginViewPresenter?.signWithCredential(credential: credential)
        }
    }
    
    @IBAction func phoneAction(_ sender: Any) {
    }
    
    @IBAction func appleAction(_ sender: Any) {
        if #available(iOS 13.0, *) {
            
            let request = ASAuthorizationAppleIDProvider().createRequest()
            request.requestedScopes = [.email]
            let controller = ASAuthorizationController(authorizationRequests: [request])
            
            self.currentNonce = randomNonceString()
            
            request.nonce = sha256(currentNonce!)
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
            
        }
    }
    
    
    @IBAction func toPHone(_ sender: Any) {
        Router.toPhone(self)
    }
    
}

extension RegisterVC: LoginViewDelegate{
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
        if self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)!-2].isKind(of: SplashVC.self) == true{
        
            if Shared.userSelectLocation == false{
                Router.toAskLocation(self)
            }else{
                Router.toHome(self,true)
            }            
        }else{
            self.view.backgroundColor = .clear
            self.dismiss(animated: true, completion: nil)
            self.loginDelegate?.onLogin()
        }
    }
}

extension RegisterVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIdCredential as ASAuthorizationAppleIDCredential:
            guard let appleIDToken = appleIdCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            guard let nonce = currentNonce else {
                return
            }
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                              idToken: idTokenString,
                                                              rawNonce: nonce)
            self.loginViewPresenter?.signWithCredential(credential: credential)
        default: break
        }
    }
    
    func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
}
