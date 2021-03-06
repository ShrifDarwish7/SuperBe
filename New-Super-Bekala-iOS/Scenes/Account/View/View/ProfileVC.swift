//
//  ProfileVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 17/05/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import DropDown
import SVProgressHUD
import PayButton

class ProfileVC: UIViewController {
    
    @IBOutlet weak var menuContainer: UIView!
    @IBOutlet weak var menuContainerAr: UIView!
    @IBOutlet weak var profileTab: ViewCorners!
    @IBOutlet weak var dashboardTab: ViewCorners!
    @IBOutlet weak var addressesTableView: UITableView!
    @IBOutlet weak var acitvityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addressesView: ViewCorners!
    @IBOutlet weak var selectedAddressTF: UITextField!
    @IBOutlet weak var expandAddressImg: UIImageView!
    @IBOutlet weak var profileDataStack: UIStackView!
    @IBOutlet weak var dashboardContainer: UIView!
    @IBOutlet weak var draggableView: UIView!
    @IBOutlet weak var bottomSheetTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var blockView: UIView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var profileImg: CircluarImage!
    @IBOutlet weak var emailStack: UIStackView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var updateBtn: RoundedButton!
    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var profileHintView: UIView!
    @IBOutlet weak var profileHintTopCnst: NSLayoutConstraint!
    @IBOutlet weak var addressTableHeight: NSLayoutConstraint!
    @IBOutlet weak var showAllBtn: LocalizedBtn!
    
    var bottomSheetPanStartingTopConstant : CGFloat = 30.0
    var loginDelegate: LoginDelegate?
    var presenter: MainPresenter?
    var addresses: [Address]?
    let menu: DropDown = {
        let menu = DropDown()
        menu.dataSource = [
            "My account".localized,
            "Contact us".localized,
            "Langauge".localized,
            "Notifications".localized,
            "Logout".localized
        ]
        let icons: [String] = [
            "profile_icon",
            "contact",
            "global",
            "notification-bell",
            "logout_icon"
        ]
        menu.cellNib = UINib(nibName: "DropDownCell", bundle: nil)
        menu.customCellConfiguration = {
            index , title , cell in
            guard let cell = cell as? DDCell else { return }
            cell.icon.image = UIImage(named: icons[index])
        }
        return menu
    }()
    var amountToBbAdd: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.isNavigationBarHidden = true
        
        version.text = "Version ".localized + (Bundle.main.releaseVersionNumber ?? "0.0")
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissBtmSheetNotify), name: NSNotification.Name("DISMISS_BOTTOM_SHEET"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startPaymentNotify), name: NSNotification.Name("START_PAYMENT"), object: nil)
        
        name.text = APIServices.shared.user?.name ?? ""
        
      //  if let _ = APIServices.shared.user?.phoneVerifiedAt,
          if let phone = APIServices.shared.user?.phone{
            self.phone.text = phone.replacingOccurrences(of: "+2", with: "")
        }else{
            self.phone.text = ""
        }
        email.text = APIServices.shared.user?.email ?? ""
        emailStack.isHidden = email.text!.isEmpty ? true : false
        profileImg.kf.indicatorType = .activity
        profileImg.kf.setImage(with: URL(string: Shared.storageBase + (APIServices.shared.user?.avatar ?? "")))
        
        acitvityIndicator.startAnimating()
        presenter = MainPresenter(self)
        presenter?.getAddresses()
        
        phone.isUserInteractionEnabled = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomSheetTopConstraint.constant = self.view.frame.height
        
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        self.draggableView.addGestureRecognizer(viewPan)
        
        menu.anchorView = "lang".localized == "en" ? menuContainer : menuContainerAr
        dashboardTab.layer.cornerRadius = dashboardTab.frame.height/2
        dashboardTab.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        dashboardTab.alpha = 0.5
        
        menu.selectionAction = { [unowned self] (index: Int, item: String) in
            self.menu.deselectRow(at: self.menu.indexForSelectedRow)
            switch index{
            case 0:
                self.replaceView(containerView: containerView, identifier: "PointsContainerVC", storyboard: .profile)
                self.menu.hide()
                self.blockView.isHidden = false
                self.bottomSheetTopConstraint.constant = 350
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: []) {
                    self.view.layoutIfNeeded()
                } completion: { (_) in
                    
                }
            case 1:
                Router.toContactUs(self)
            case 2,3:
                if let _ = Bundle.main.bundleIdentifier,
                    let url = URL(string: "\(UIApplication.openSettingsURLString)") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            case 4:
                SVProgressHUD.show()
                let loginPresenter = LoginViewPresenter(loginViewDelegate: self)
                loginPresenter.logout()
            default:
                break
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) { [self] in
            if !Shared.didGetProfileInsideHint{
                shakeProfileHint()
                profileHintView.isHidden = false
            }else{
                profileHintView.isHidden = true
            }
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        addressTableHeight.constant = addressesTableView.contentSize.height
        view.layoutIfNeeded()
    }
    
    func shakeProfileHint(){
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
            UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction]) { [self] in
                profileHintTopCnst.constant = 30
                view.layoutIfNeeded()
            } completion: { [self] _ in
                UIView.animate(withDuration: 0.5, delay: 0, options: [.allowUserInteraction]) {
                    profileHintTopCnst.constant = 15
                    view.layoutIfNeeded()
                }
            }
        }
    }
    
    @IBAction func dismissProfileHint(_ sender: Any) {
        Shared.didGetProfileInsideHint = true
        UIView.animate(withDuration: 0.2) { [self] in
            profileHintView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        } completion: { [self] _ in
            profileHintView.isHidden = true
        }
    }
    
    @IBAction func updateName(_ sender: Any) {
        guard !name.text!.isEmpty else { return }
        let loginPresenter = LoginViewPresenter(loginViewDelegate: self)
        SVProgressHUD.show()
        loginPresenter.updateProfile(["name": name.text!])
    }
    
    @IBAction func updatePhone(_ sender: Any) {
        guard !phone.text!.isEmpty else { return }
        let loginPresenter = LoginViewPresenter(loginViewDelegate: self)
        SVProgressHUD.show()
        loginPresenter.updateProfile(["phone": phone.text!])
    }
    
    
    @IBAction func shareAction(_ sender: Any) {
        let textToShare = [ "Download Super Be from : http://onelink.to/super-be" ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [.airDrop, .postToFacebook, .postToTwitter, .mail, .message]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func viewPanned(_ panRecognizer: UIPanGestureRecognizer){
        let translation = panRecognizer.translation(in: self.view)
        _ = panRecognizer.velocity(in: self.view)
        switch panRecognizer.state {
        case .began:
            bottomSheetPanStartingTopConstant = self.bottomSheetTopConstraint.constant
        case .changed:
            
            self.bottomSheetTopConstraint.constant = self.bottomSheetPanStartingTopConstant + translation.y

        case .ended:
            
            if translation.y < 0 {
                self.bottomSheetTopConstraint.constant = UIApplication.shared.statusBarFrame.height + 20
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: []) {
                    self.view.layoutIfNeeded()
                } completion: { (_) in
                    
                }

            }else{
                self.dismissBottomSheet(self)
            }
            
        default:
            break
        }
    }
    
    @IBAction func dismissBottomSheet(_ sender: Any) {
        self.bottomSheetTopConstraint.constant = self.view.frame.height
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        } completion: { (_) in
            self.blockView.isHidden = true
        }

    }
    
    @objc func startPaymentNotify(){
        
        dismissBottomSheet(self)
//        Router.toPayContainer(self)
        
        showInputAlert(title: "Add Balance".localized, subtitle: "Please enter your amount".localized, actionTitle: "Proceed".localized, cancelTitle: "Cancel".localized, secureTF: false, inputPlaceholder: "amount".localized, inputKeyboardType: .numberPad, cancelHandler: nil) { (amount, alert) in
            self.amountToBbAdd = amount
            let paymentViewController = PaymentViewController()
            paymentViewController.amount =  String(amount!)
            paymentViewController.delegate = self
            paymentViewController.refnumber =  "5236975231"
            paymentViewController.mId = "10253847133"
            paymentViewController.tId = "57547386"
            paymentViewController.Currency = "818"
            paymentViewController.isProduction = true
            paymentViewController.AppStatus = .Production
            paymentViewController.Key = "37353137326166332D326561322D343665652D383461612D353630383335653231396638"
            paymentViewController.pushViewController()
        }
        
    }
    
    @objc func dismissBtmSheetNotify(){
        dismissBottomSheet(self)
    }
    
    @IBAction func showMenu(_ sender: Any) {
        menu.show()
    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTab(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) { [self] in
            switch sender.tag{
            case 0:
                profileTab.transform = CGAffineTransform(scaleX: 1, y: 1)
                dashboardTab.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                dashboardTab.alpha = 0.5
                profileTab.alpha = 1
                profileDataStack.isHidden = false
                dashboardContainer.isHidden = true
            case 1:
                profileTab.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                dashboardTab.transform = CGAffineTransform(scaleX: 1, y: 1)
                dashboardTab.alpha = 1
                profileTab.alpha = 0.5
                profileDataStack.isHidden = true
                dashboardContainer.isHidden = false
            default:
                break
            }
        }
    }
    
    @IBAction func toAddAddress(_ sender: Any) {
        Router.toAddAddress(self, nil, nil)
    }
    
    @IBAction func showAddresses(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) { [self] in
            switch sender.tag {
            case 0:
                self.addressesView.isHidden = false
                sender.tag = 1
                expandAddressImg.transform = CGAffineTransform(rotationAngle: .pi)
            case 1:
                self.addressesView.isHidden = true
                sender.tag = 0
                expandAddressImg.transform = CGAffineTransform(rotationAngle: .pi*2)
            default:
                break
            }
        }
    }
    
    @IBAction func showAllAction(_ sender: Any) {
        Router.toAllAddress(self, addresses)
    }
    
    
}

extension ProfileVC: CompletedPaymentDelegate{
    func onPayment(_ success: Bool, _ transactionId: String) {
        if success {
            self.presenter?.addToWallet((Shared.transaction?.amount)!)
        }else{
            showToast("Transaction failed, please make sure you entered correct card information and the card is valid".localized)
        }
    }
    
    func onCancelPaymentSession() {
        
    }
    
}

extension ProfileVC: PaymentDelegate{
    func finishSdkPayment(_ receipt: TransactionStatusResponse) {
        if receipt.Success {
            self.presenter?.addToWallet(Double(self.amountToBbAdd ?? "0.0")!)
        }else {
            
        }
    }
}
