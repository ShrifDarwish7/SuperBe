//
//  FiltersVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 16/05/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class FiltersVC: UIViewController {
    
    @IBOutlet weak var visaYes: UIButton!
    @IBOutlet weak var visaNo: UIButton!
    @IBOutlet weak var couponsYes: UIButton!
    @IBOutlet weak var couponsNo: UIButton!
    @IBOutlet weak var open: UIButton!
    @IBOutlet weak var close: UIButton!
    @IBOutlet weak var hold: UIButton!
    @IBOutlet weak var deliveryTimeValue: UILabel!
    @IBOutlet weak var deliveryFeesValue: UILabel!
    
    var visa: Bool?
    var coupons: Bool?
    var status: Int?
    var time = 0
    var fees = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func byVISA(_ sender: UIButton) {
        visaYes.setImage(UIImage(named: "unchecked-1"), for: .normal)
        visaNo.setImage(UIImage(named: "unchecked-1"), for: .normal)
        sender.setImage(UIImage(named: "checked-1"), for: .normal)
        visa = sender.tag == 1 ? false : true
    }
    
    @IBAction func byCoupons(_ sender: UIButton) {
        couponsYes.setImage(UIImage(named: "unchecked-1"), for: .normal)
        couponsNo.setImage(UIImage(named: "unchecked-1"), for: .normal)
        sender.setImage(UIImage(named: "checked-1"), for: .normal)
        coupons = sender.tag == 1 ? false : true
    }
    
    @IBAction func byStatus(_ sender: UIButton) {
        open.setImage(UIImage(named: "unchecked-1"), for: .normal)
        close.setImage(UIImage(named: "unchecked-1"), for: .normal)
        hold.setImage(UIImage(named: "unchecked-1"), for: .normal)
        sender.setImage(UIImage(named: "checked-1"), for: .normal)
        status = sender.tag
    }
    
    @IBAction func newVendors(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            sender.tag = 1
            sender.setImage(UIImage(named: "true-1"), for: .normal)
        case 1:
            sender.tag = 0
            sender.setImage(UIImage(named: "unchecked-2"), for: .normal)
        default:
            break
        }
    }
    
    @IBAction func deliveryFeesDidSlide(_ sender: UISlider) {
        fees = Int(sender.value)
        deliveryFeesValue.text = "\(Int(sender.value)) EGP"
    }
    
    @IBAction func deliveryTimeDidSlide(_ sender: UISlider) {
        time = Int(sender.value)
        deliveryTimeValue.text = "\(Int(sender.value)) min"
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func generateQuery(_ sender: Any) {
        
        var query = ""
        
        if visa ?? false{
            query += "online_payment=1"
        }else if !(visa ?? true){
            query = query.replacingOccurrences(of: "online_payment=1", with: "")
            query += "online_payment=0"
        }else{
            query = query.replacingOccurrences(of: "online_payment=1", with: "")
            query = query.replacingOccurrences(of: "online_payment=0", with: "")
        }
        
        if coupons ?? false{
            query += ",accept_coupons=1"
        }else if !(coupons ?? true){
            query = query.replacingOccurrences(of: ",accept_coupons=1", with: "")
            query += ",accept_coupons=0"
        }else{
            query = query.replacingOccurrences(of: ",accept_coupons=1", with: "")
            query = query.replacingOccurrences(of: ",accept_coupons=0", with: "")
        }
        
        query += ",delivery_duration<=\(time)"
        query += ",delivery_fees<=\(fees)"
        
        query = query.replacingOccurrences(of: ",is_open=1", with: "")
        query = query.replacingOccurrences(of: ",is_open=0", with: "")
        query = query.replacingOccurrences(of: ",is_onhold=1", with: "")
        
        if let status = status{
            switch status {
            case 0:
                query += ",is_open=1"
            case 1:
                query += ",is_open=0"
            case 2:
                query += ",is_onhold=1"
            default:
                break
            }
        }
        
        if let index = query.firstIndex(char: ","),
           index == 0{
            query.remove(at: query.firstIndex(of: ",")!)
        }
        
        print(query)
        
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name("QUERY"), object: nil, userInfo: ["query": query])
    }
    
    
}
