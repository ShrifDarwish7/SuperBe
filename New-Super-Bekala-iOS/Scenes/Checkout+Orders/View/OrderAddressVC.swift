//
//  OrderAddressVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 06/09/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class OrderAddressVC: UIViewController {
    
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var districct: UILabel!
    @IBOutlet weak var street: UILabel!
    @IBOutlet weak var building: UILabel!
    @IBOutlet weak var floor: UILabel!
    @IBOutlet weak var flat: UILabel!
    @IBOutlet weak var userPhoneNum: UILabel!
    @IBOutlet weak var altPhoneNum: UILabel!
    @IBOutlet weak var notes: UILabel!

    var address: Address?
    var userPhone: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.4) { self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5) }
        city.text = address?.city == "" ? "-" : address?.city
        districct.text = address?.dist == "" ? "-" : address?.dist
        street.text = address?.street == "" ? "-" : address?.street
        building.text = address?.building == "" ? "-" : address?.building
        floor.text = address?.floor == "" ? "-" : address?.floor
        flat.text = address?.flat == "" ? "-" : address?.flat
        userPhoneNum.text = userPhone == "" ? "-" : userPhone
        altPhoneNum.text = address?.phone == "" ? "-" : address?.phone
        notes.text = address?.notes == "" ? "-" : address?.notes
    }
    
    @IBAction func openInMapsAction(_ sender: Any) {
        self.openInMaps(coordinates: (address?.coordinates)!)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.view.backgroundColor = .clear
        self.dismiss(animated: true, completion: nil)
    }
    
}
