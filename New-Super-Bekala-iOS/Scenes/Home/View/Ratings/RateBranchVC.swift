//
//  RateBranchVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 25/07/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import Cosmos

class RateBranchVC: UIViewController {

    @IBOutlet weak var rateView: CosmosView!
    @IBOutlet weak var branchName: UILabel!
    @IBOutlet weak var comment: UITextView!
    
    var presenter: MainPresenter?
    var branch: Branch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {
            self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        }
        
        presenter = MainPresenter(self)
        
        branchName.text = "Rate " + (("lang".localized == "en" ? branch?.name?.en : branch?.name?.ar)!)
        
    }
    
    
    @IBAction func rateAction(_ sender: Any) {
        
        let prms = [
            "model_id": self.branch!.id,
            "model": "Branch",
            "comment": self.comment.text!,
            "rates[0]": self.rateView.rating
        ] as [String : Any]
                
        self.presenter?.postRate(prms)
    }
    
    @IBAction func dismissACtion(_ sender: Any) {
        self.view.backgroundColor = .clear
        self.dismiss(animated: true, completion: nil)
    }
}

extension RateBranchVC: MainViewDelegate{
    func didCompleteRate(_ error: String?) {
        if let error = error{
            showToast(error)
        }else{
            self.view.backgroundColor = .clear
            self.dismiss(animated: true, completion: nil)
        }
    }
}
