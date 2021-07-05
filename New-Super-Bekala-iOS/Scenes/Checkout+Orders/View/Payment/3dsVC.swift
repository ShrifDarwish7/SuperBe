//
//  3dsVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 15/06/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class ThreeDSecureVC: UIViewController {
    
    var webView: WKWebView?
    var html = ""
    var url = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        configuration.userContentController.add(self, name: "")
        
        webView = WKWebView()
        
        webView!.navigationDelegate = self
        
        view = webView
        
        webView?.loadHTMLString(self.html, baseURL: nil)

    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    

}

extension ThreeDSecureVC: WKNavigationDelegate, WKScriptMessageHandler{
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if #available(iOS 14.0, *) { webView.pageZoom = 2 }
        
        guard self.url == navigationAction.request.url?.absoluteString else {
            decisionHandler(.allow)
            return
        }
       
        decisionHandler(.cancel)
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name("DID_FINISH_3DS"), object: nil, userInfo: nil)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
        
            
    }
    
    
}
