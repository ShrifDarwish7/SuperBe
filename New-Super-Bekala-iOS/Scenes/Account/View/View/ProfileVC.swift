//
//  ProfileVC.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 17/05/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import UIKit
import DropDown

class ProfileVC: UIViewController {
    
    @IBOutlet weak var menuContainer: UIView!
    @IBOutlet weak var profileTab: ViewCorners!
    @IBOutlet weak var dashboardTab: ViewCorners!
    @IBOutlet weak var addressesTableView: UITableView!
    @IBOutlet weak var acitvityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addressesView: ViewCorners!
    @IBOutlet weak var selectedAddressLbl: UILabel!
    @IBOutlet weak var expandAddressImg: UIImageView!
    @IBOutlet weak var profileDataStack: UIStackView!
    @IBOutlet weak var dashboardContainer: UIView!
    @IBOutlet weak var draggableView: UIView!
    @IBOutlet weak var bottomSheetTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var blockView: UIView!
    
    var bottomSheetPanStartingTopConstant : CGFloat = 30.0
    var presenter: MainPresenter?
    var addresses: [Address]?
    let menu: DropDown = {
        let menu = DropDown()
        menu.dataSource = [
            "My account",
            "My promocodes",
            "Logout"
        ]
        let icons: [String] = [
            "profile_icon",
            "promo",
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        acitvityIndicator.startAnimating()
        presenter = MainPresenter(self)
        presenter?.getAddresses()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomSheetTopConstraint.constant = self.view.frame.height
        
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        self.draggableView.addGestureRecognizer(viewPan)
        
        menu.anchorView = menuContainer
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
            case 2:
                APIServices.shared.isLogged = false
                Router.toMainNav(self)
            default:
                break
            }
        }
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
        Router.toAddAddress(self)
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
    
}
