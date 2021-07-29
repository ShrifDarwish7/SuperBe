//
//  OrderPlacedVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 22/07/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class OrderPlacedVC: UIViewController {

    var orderID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {
            self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7)
        }
    }

    @IBAction func homeAction(_ sender: Any) {
        Router.toHome(self)
    }
    
    @IBAction func cancelOrder(_ sender: Any) {
        let presenter = MainPresenter(self)
        presenter.updateOrder(id: orderID!, prms: ["status": "cancelled"])
    }
    
}

extension OrderPlacedVC: MainViewDelegate{
    func didCompleteUpdateOrder(_ data: LastOrder?, _ error: String?) {
        if let _ = data{
            Router.toHome(self)
        }else{
            showToast(error!)
        }
    }
}
