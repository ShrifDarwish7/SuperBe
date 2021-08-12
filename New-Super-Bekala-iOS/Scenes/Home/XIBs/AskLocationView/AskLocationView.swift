//
//  AskLocationView.swift
//  Super Bekala iOS
//
//  Created by Sherif Darwish on 11/11/20.
//  Copyright © 2020 mobidevlabs. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class AskLocationView: UIView{
    
    @IBOutlet weak var shareMsgLbl: UILabel!
    @IBOutlet weak var shareHintLbl: UILabel!
    @IBOutlet weak var shareStep1Lbl: UILabel!
    @IBOutlet weak var shareStep2: UILabel!
    @IBOutlet weak var askLocationAlertView: UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var goSettingBtn: UIButton!
    
    let nibName = "AskLocationView"
    var contentView: UIView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
        
        shareMsgLbl.text = "Share your location".localized
        shareHintLbl.text = "By allowing SuperBe to detect your location we can show you nearby categories and restaurants".localized
        shareStep1Lbl.text = "1. Select Location".localized
        shareStep2.text = "2. Choose \"Always\"".localized
        cancelBtn.setTitle("Cancel".localized, for: .normal)
        goSettingBtn.setTitle("Go to setting".localized, for: .normal)
        askLocationAlertView.layer.cornerRadius = 10
        goSettingBtn.layer.cornerRadius = 10
        cancelBtn.layer.cornerRadius = 10
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    @IBAction func goSettingAction(_ sender: Any) {
        if let BUNDLE_IDENTIFIER = Bundle.main.bundleIdentifier,
            let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(BUNDLE_IDENTIFIER)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        self.isHidden = true
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.isHidden = true
    }
    
}
