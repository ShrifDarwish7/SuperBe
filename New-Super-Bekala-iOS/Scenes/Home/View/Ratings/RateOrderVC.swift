//
//  RateOrderVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 26/07/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import Cosmos

class RateOrderVC: UIViewController {
    
    @IBOutlet weak var packagingRate: CosmosView!
    @IBOutlet weak var valueForPriceRate: CosmosView!
    @IBOutlet weak var timingRate: CosmosView!
    @IBOutlet weak var qualityRate: CosmosView!
    @IBOutlet weak var comment: UITextView!
    @IBOutlet weak var orderTitle: UILabel!
    
    var presenter: MainPresenter?
    var branchId: Int?
    var orderId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {
            self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        }
        presenter = MainPresenter(self)
        orderTitle.text = "Rate Order ".localized + "#\(orderId!)"
    }

    @IBAction func dismissAction(_ sender: Any) {
        self.view.backgroundColor = .clear
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rateAction(_ sender: Any) {
        
        let prms = [
            "model_id": self.branchId!,
            "model": "Branch",
            "comment": self.comment.text!,
            "rates[0]": self.packagingRate.rating,
            "rates[1]": self.valueForPriceRate.rating,
            "rates[2]": self.timingRate.rating,
            "rates[3]": self.qualityRate.rating
        ] as [String : Any]
        
        presenter?.postRate(prms)
        
    }
    
}

extension RateOrderVC: MainViewDelegate{
    func didCompleteRate(_ error: String?) {
        if let error = error{
            showToast(error)
        }else{
            self.view.backgroundColor = .clear
            self.dismiss(animated: true, completion: nil)
        }
    }
}
