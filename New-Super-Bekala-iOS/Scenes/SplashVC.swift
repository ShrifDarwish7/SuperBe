//
//  SplashVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 09/03/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import Reachability
import FirebaseFirestore

class SplashVC: UIViewController {

    let reachability = try! Reachability()
    var presenter: LoginViewPresenter?
    private var observer: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         initView()
        
    }
    
    func initView(){
        
        presenter = LoginViewPresenter(loginViewDelegate: self)
        
        if let _ = APIServices.shared.user{
            presenter?.updateProfile([
                "device_token": UserDefaults.init().string(forKey: "FCM_Token") ?? "",
                "notification_lang": "lang".localized,
                "app_version": Bundle.main.releaseVersionNumber ?? "",
                "app": "ios_user",
                "device": "\(UIDevice.current.name) - \(UIDevice().type) - \(UIDevice.current.systemName): \(UIDevice.current.systemVersion)",
            ])
        }
              
        if let window = UIWindow.key{
            let chatMinimizeView = ChatMinimizeView()
            window.addSubview(chatMinimizeView)
            chatMinimizeView.translatesAutoresizingMaskIntoConstraints = false
            let trailingConstraint = NSLayoutConstraint(item: chatMinimizeView, attribute: .trailing, relatedBy: .equal, toItem: window.rootViewController?.view, attribute: .trailing, multiplier: 1, constant: -10)
            let verticalConstraint = NSLayoutConstraint(item: chatMinimizeView, attribute: .centerY, relatedBy: .equal, toItem: window.rootViewController?.view, attribute: .centerY, multiplier: 1, constant: 0)
            let widthConstraint = NSLayoutConstraint(item: chatMinimizeView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
            let heightConstraint = NSLayoutConstraint(item: chatMinimizeView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 160)
            window.addConstraints([trailingConstraint, verticalConstraint, widthConstraint, heightConstraint])
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("is_chatting"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("RELOAD"), object: nil)
        
        if ConnectionManager.shared.hasConnectivity(){
            presenter?.getSetting()
        }else{  
            Router.toNoConnection(self)
        }
        
        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [unowned self] notification in
            self.viewDidLoad()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if let _ = observer {
            NotificationCenter.default.removeObserver(observer!)
        }
    }
    
    @objc func reload(){
        guard (self.navigationController?.topViewController?.isKind(of: SplashVC.self))! else { return }
        self.viewDidLoad()
    }
    
    func goNext(){
        NotificationCenter.default.removeObserver(observer!)
        if APIServices.shared.skipFromLogin {
            if Shared.userSelectLocation{
                Router.toHome(self,true)
                
            }else{
                Router.toAskLocation(self)
            }
        }else{
            Router.toAboutUs(self)
        }
    }

}

extension SplashVC: LoginViewDelegate{
    func didCompleteWithSetting(_ data: Setting?) {
        guard let setting = data else { return }
        let updateAction = UIAlertAction(title: "Update".localized, style: .default, handler: { _ in
            if let url = URL(string: "itms-apps://apple.com/app/id1462578286") {
                UIApplication.shared.open(url)
            }
        })
        
        if Double(setting.iosUserLastAllowedVersion!)! > Double(Bundle.main.releaseVersionNumber ?? "0.0")!{
            let alert = UIAlertController(title: "Update Required".localized, message: "Please update now to enjoy new look and features".localized, preferredStyle: .alert)
            alert.addAction(updateAction)
            present(alert, animated: true, completion: nil)
        }
        else if Double(setting.iosUserLatestVersion!)! > Double(Bundle.main.releaseVersionNumber ?? "0.0")!{
            let alert = UIAlertController(title: "New Version Available".localized, message: "Do you want to update?".localized, preferredStyle: .alert)
            alert.addAction(updateAction)
            alert.addAction(UIAlertAction(title: "Skip".localized, style: .default, handler: { _ in
                self.goNext()
            }))
            present(alert, animated: true, completion: nil)
        }
        else if setting.appClosed == 1, let message = setting.appCloseMessage, let image = setting.appCloseImage{
            let alert = UIAlertController(title: "Super Be is closed at the moment".localized, message: message, preferredStyle: .alert)
            let imageView = UIImageView(frame: CGRect(x: -10, y: 100, width: 250, height: 250))
            imageView.contentMode = .scaleAspectFit
            imageView.kf.setImage(with: URL(string: image))
            let height = NSLayoutConstraint(item: alert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 400)
            let width = NSLayoutConstraint(item: alert.view!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)  
            alert.view.addConstraint(height)
            alert.view.addConstraint(width)
            alert.addAction(UIAlertAction(title: "Continue".localized, style: .default, handler: { _ in
                self.goNext()
            }))
            present(alert, animated: true, completion: nil)
        }
        else{
            self.goNext()
        }
        
    }
}
