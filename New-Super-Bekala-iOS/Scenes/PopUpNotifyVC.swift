//
//  PopUpNotifyVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 02/02/2022.
//  Copyright © 2022 Super Bekala. All rights reserved.
//

import UIKit

class PopUpNotifyVC: UIViewController {
    
    @IBOutlet weak var popupImage: UIImageView!

    var image: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7)
        }
        popupImage.kf.setImage(with: URL(string: image)!)
    }

    @IBAction func close(_ sender: UIButton){
        view.backgroundColor = .clear
        dismiss(animated: true, completion: nil)
    }

}
