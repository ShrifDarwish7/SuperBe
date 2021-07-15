//
//  TextOrderVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 28/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit

class TextOrderVC: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var addBtn: ViewCorners!
        
    var branch: Branch?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addToCartAction(_ sender: Any) {
        guard !textView.text.isEmpty else { return }
        var product = Product()
        product.text = textView.text
        product.branch = branch
        CartServices.shared.addToCart(product) { (completed) in
            if completed{
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

extension TextOrderVC: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty{
            addBtn.alpha = 0.5
        }else{
            addBtn.alpha = 1
        }
    }
}
