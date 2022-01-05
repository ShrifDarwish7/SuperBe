//
//  ContactUsVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 14/08/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class ContactUsVC: UIViewController {

    @IBOutlet weak var whatsappNumber: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }
    
    @IBAction func dismiiss(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func openFb(_ sender: Any) {
        let faceHooks = "fb://profile/733295540207770"
        let faceUrl = NSURL(string: faceHooks)
        if UIApplication.shared.canOpenURL(faceUrl! as URL) {
            UIApplication.shared.open(faceUrl! as URL, options: [:], completionHandler: nil)
        } else {
            //redirect to safari because the user doesn't have facebook
            UIApplication.shared.open(NSURL(string: "https://www.facebook.com/SuperBekala")! as URL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func openInstagram(_ sender: Any) {
        let instaHooks = "instgram://user?username=superbekala"
        let instaUrl = NSURL(string: instaHooks)
        if UIApplication.shared.canOpenURL(instaUrl! as URL) {
            UIApplication.shared.open(NSURL(string: instaHooks)! as URL, options: [:], completionHandler: nil)
        } else {
            //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.open(NSURL(string: "http://instgram.com/superbekala")! as URL, options: [:], completionHandler: nil)

        }
    }
    
    @IBAction func openWhats(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://api.whatsapp.com/send?phone=\(whatsappNumber.text!)")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func call(_ sender: Any) {
        Shared.call(phoneNumber: phoneNumber.text!)
    }
    
    @IBAction func toChat(_ sender: Any) {
        guard Shared.isChatting == false else {
            showAlert(title: "", message: "Please first close your current conversation session to start new one".localized)
            return
        }
        let presenter = MainPresenter(self)
        presenter.startConversation()
    }
    
}

extension ContactUsVC: MainViewDelegate{
    func didCompleteStartConversation(_ Id: Int?) {
        if let id = Id{
            Shared.currentConversationId = id
            Router.toChat(self)
        }
    }
}
