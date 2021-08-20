//
//  PointsVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 19/05/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class PointsVC: UIViewController {

    @IBOutlet weak var points: UILabel!
    
    var presenter: MainPresenter?
    var pointsValue: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MainPresenter(self)
        presenter?.getPoints()
    }
    
    @IBAction func exchagne1kPoints(_ sender: UIButton) {
        guard (self.pointsValue ?? 0) >= 1000 else {
            showToast("You have no enough points to exchange".localized)
            return
        }
        switch sender.tag {
        case 0:
            presenter?.exchangePointsToWallet(1000)
        default: break
        }
    }
    
    @IBAction func exchagne2kPoints(_ sender: UIButton) {
        guard (self.pointsValue ?? 0) >= 2500 else {
            showToast("You have no enough points to exchange".localized)
            return
        }
        switch sender.tag {
        case 0:
            presenter?.exchangePointsToWallet(2500)
        default: break
        }
    }

    @IBAction func exchagne5kPoints(_ sender: UIButton) {
        guard (self.pointsValue ?? 0) >= 5000 else {
            showToast("You have no enough points to exchange".localized)
            return
        }
        switch sender.tag {
        case 0:
            presenter?.exchangePointsToWallet(5000)
        default: break
        }
    }
}

extension PointsVC: MainViewDelegate{
    func didCompleteWithPoints(_ data: PointsData?, _ error: String?) {
        if let data = data,
           let points = data.total,
           points != 0{
            self.pointsValue = points
            self.points.text = "You Collected \(points) Points"
        }else{
            self.pointsValue = 0
            self.points.text = "You have no points"
        }
    }
    
    func didCompleteExchangePointsToWallet(_ error: String?) {
        guard error == nil else {
            showToast(error!)
            return
        }
        presenter?.getPoints()
    }
}
