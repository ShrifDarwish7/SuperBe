//
//  Router.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 8/9/20.
//  Copyright © 2020 Super Bekala. All rights reserved.
//

import Foundation
import UIKit
import MapKit

enum AppStoryboard: String {
    case main = "Main"
    case home = "Home"
    case orders = "Orders"
    case profile = "Profile"
    case services = "Services"
    case other = "Other"
}

class Router {
    
    static func instantiate<T: UIViewController>(appStoryboard: AppStoryboard, identifier: String) -> T {
        let storyboard = UIStoryboard(name: appStoryboard.rawValue, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    
    static func toMainNav(_ sender: UIViewController){
        let nv = self.instantiate(appStoryboard: .main, identifier: "NavHome") as! UINavigationController
        nv.modalPresentationStyle = .fullScreen
        sender.present(nv, animated: true, completion: nil)
    }
    
    static func toHome(_ sender: UIViewController,_ shouldShowCats: Bool){
        // guard !(sender.navigationController?.topViewController?.isKind(of: HomeContainerVC.self))! else { return }
        if let _ = sender.navigationController{
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HomeContainerVC") as! HomeContainerVC
            Shared.shouldShowCategories = shouldShowCats
            sender.navigationController?.pushViewController(vc, animated: true)
        }else{
            let nav = self.instantiate(appStoryboard: .home, identifier: "HomeContNav") as! UINavigationController
            nav.modalPresentationStyle = .fullScreen
            sender.present(nav, animated: true, completion: nil)
        }
    }
    
    static func toMaps(_ sender: UIViewController){
        let vc = self.instantiate(appStoryboard: .home, identifier: "MapVC") as! MapVC
        Shared.mapState = .fetchLocation
        sender.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func toEditAddreess(_ sender: UIViewController,_ editableAddress: Address){
        let vc = self.instantiate(appStoryboard: .home, identifier: "MapVC") as! MapVC
        Shared.mapState = .editAddress
        vc.editableAddress = editableAddress
        sender.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func toPhone(_ sender: UIViewController){
        let vc = self.instantiate(appStoryboard: .main, identifier: "PhoneVC") as! PhoneVC
        if let _ = sender.navigationController{
            sender.navigationController?.pushViewController(vc, animated: true)
        }else{
            let nav = self.instantiate(appStoryboard: .main, identifier: "PhoneNav") as! UINavigationController
            nav.modalPresentationStyle = .fullScreen
            sender.present(nav, animated: true, completion: nil)
        }
    }
    
    static func toAddAddress(_ sender: UIViewController,_ path: [MKPolyline]?,_ polygon: [MKPolygon]?){
        let vc = self.instantiate(appStoryboard: .home, identifier: "MapVC") as! MapVC
        Shared.mapState = .addAddress
        vc.path = path
        vc.polygone = polygon
        sender.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func toLogin(_ sender: UIViewController){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        //vc.modalPresentationStyle = .fullScreen
        sender.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func toAboutUs(_ sender: UIViewController){
        guard !(sender.navigationController?.topViewController?.isKind(of: AboutUsViewController.self))! else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        sender.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func toAskLocation(_ sender: UIViewController){
        guard !(sender.navigationController?.topViewController?.isKind(of: AskLocationVC.self))! else { return }
        let vc = self.instantiate(appStoryboard: .home, identifier: "AskLocationVC") as! AskLocationVC
        sender.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func toCities(_ sender: UIViewController, _ cities: [City]){
        let vc = self.instantiate(appStoryboard: .home, identifier: "CitiesVC") as! CitiesVC
        vc.cities = cities
        sender.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func toRegions(_ sender: UIViewController, _ regions: [Region]){
        let vc = self.instantiate(appStoryboard: .home, identifier: "RegionsVC") as! RegionsVC
        vc.regions = regions
        sender.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func toBranch(_ sender: UIViewController,_ branch: Branch){
        let vc = self.instantiate(appStoryboard: .home, identifier: "BranchVC") as! BranchVC
        vc.branch = branch
        sender.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func toProduct(_ sender: UIViewController,_ product: Product?){
        let vc = self.instantiate(appStoryboard: .home, identifier: "ProductVC") as! ProductVC
        vc.product = product
        sender.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func toCart(_ sender: UIViewController){
        let vc = self.instantiate(appStoryboard: .home, identifier: "CartVC") as! CartVC
        sender.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func toCheckout(_ sender: UIViewController, _ branch: Branch?,_ lineItemsTotal: Double){
        let vc = self.instantiate(appStoryboard: .orders, identifier: "CheckoutVC") as! CheckoutVC
        vc.branch = branch
        vc.lineItemsTotal = lineItemsTotal
        sender.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func toOrder(_ sender: UIViewController, _ order: LastOrder){
        let vc = self.instantiate(appStoryboard: .orders, identifier: "OrderVC") as! OrderVC
        vc.order = order
        vc.modalPresentationStyle = .overCurrentContext
        if sender.isKind(of: LastOrderVC.self){
            vc.delegate = sender as? OrderUpdatedDelegate
        }
        sender.present(vc, animated: true, completion: nil)
    }
    
    static func toImagesOrder(_ sender: UIViewController,_ branch: Branch?){
        let vc = self.instantiate(appStoryboard: .orders, identifier: "ImagesOrderVC") as! ImagesOrderVC
        vc.branch = branch
        sender.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func toVoiceOrder(_ sender: UIViewController,_ branch: Branch?){
        let vc = self.instantiate(appStoryboard: .orders, identifier: "VoiceOrderVC") as! VoiceOrderVC
        vc.branch = branch
        sender.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func toTextOrder(_ sender: UIViewController,_ branch: Branch?){
        let vc = self.instantiate(appStoryboard: .orders, identifier: "TextOrderVC") as! TextOrderVC
        vc.branch = branch
        sender.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func toSearch(_ sender: UIViewController,_ branchId: Int? = nil){
        let vc = self.instantiate(appStoryboard: .home, identifier: "SearchVC") as! SearchVC
        vc.branchId = branchId
        sender.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func toFilters(_ sender: UIViewController){
        let vc = self.instantiate(appStoryboard: .home, identifier: "FiltersVC") as! FiltersVC
        sender.present(vc, animated: true, completion: nil)
    }
    
    static func toProfile(_ sender: UIViewController){
        let vc = self.instantiate(appStoryboard: .profile, identifier: "ProfileVC") as! ProfileVC
        vc.loginDelegate = (sender as! LoginDelegate)
        sender.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func toPointsContainer(_ sender: UIViewController){
        let vc = self.instantiate(appStoryboard: .profile, identifier: "PointsContainerVC") as! PointsContainerVC
        sender.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func toShareLocation(_ sender: UIViewController){
        let vc = self.instantiate(appStoryboard: .services, identifier: "ServicesNav") as! UINavigationController
        vc.modalPresentationStyle = .overCurrentContext
        sender.present(vc, animated: true, completion: nil)
        
    }
    
    static func toPickLocation(_ sender: UIViewController,_ state: LocationState){
        let vc = self.instantiate(appStoryboard: .services, identifier: "PickLocationVC") as! PickLocationVC
        vc.locationState = state
        sender.present(vc, animated: true, completion: nil)
    }
    
    static func toViewAllFeatured(_ sender: UIViewController,_ branches: [Branch]?){
        let vc = self.instantiate(appStoryboard: .home, identifier: "AllFeaturedVC") as! AllFeaturedVC
        vc.branches = branches
        sender.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func toSuperServicesCheckout(_ sender: UIViewController,_ service: SuperService?){
        let vc = self.instantiate(appStoryboard: .services, identifier: "ServicesCheckoutVC") as! ServicesCheckoutVC
        vc.superService = service
        sender.navigationController?.pushViewController(vc, animated: true)
//        vc.modalPresentationStyle = .overCurrentContext
//        sender.present(vc, animated: true, completion: nil)
    }
    
    static func toSuperServicesSummary(_ sender: UIViewController,_ service: SuperService?){
        let vc = self.instantiate(appStoryboard: .services, identifier: "ServicesCheckoutVC") as! ServicesCheckoutVC
        vc.superService = service
        vc.serviceType = .summary
        vc.modalPresentationStyle = .overCurrentContext
        if sender.isKind(of: LastOrderVC.self){
            vc.delegate = sender as? OrderUpdatedDelegate
        }
        sender.present(vc, animated: true, completion: nil)
    }
    
    static func toChooser(_ sender: UIViewController,_ list: [String]?){
        let vc = self.instantiate(appStoryboard: .home, identifier: "ChooserVC") as! ChooserVC
        vc.list = list
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = sender as? ChooserDelegate
        sender.present(vc, animated: true, completion: nil)
    }
    
    static func toContactUs(_ sender: UIViewController){
        let vc = self.instantiate(appStoryboard: .other, identifier: "ContactUsVC") as! ContactUsVC
        vc.modalPresentationStyle = .overCurrentContext
        sender.present(vc, animated: false, completion: nil)
    }
    
    static func toPayContainer(_ sender: UIViewController){
        let vc = self.instantiate(appStoryboard: .orders, identifier: "PaymentVC") as! PaymentVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = (sender as! CompletedPaymentDelegate)
        sender.present(vc, animated: true, completion: nil)
    }
    
    static func toChangeLocation(_ sender: UIViewController){
        let vc = self.instantiate(appStoryboard: .profile, identifier: "ChangeLocationNav") as! UINavigationController
        vc.modalPresentationStyle = .overCurrentContext
        sender.present(vc, animated: true, completion: nil)
    }
    
    static func toNoConnection(_ sender: UIViewController?){
        let vc = Router.instantiate(appStoryboard: .main, identifier: "NoConnectionVC") as! NoConnectionVC
        vc.modalPresentationStyle = .overCurrentContext
        sender?.present(vc, animated: true, completion: nil)
    }
    
    static func toChat(_ sender: UIViewController){
        let vc = Router.instantiate(appStoryboard: .other, identifier: "ChatVC") as! ChatVC
        vc.modalPresentationStyle = .overCurrentContext
        sender.present(vc, animated: true, completion: nil)
    }
    
    static func toRateBranch(_ sender: UIViewController,_ branch: Branch){
        let vc = self.instantiate(appStoryboard: .other, identifier: "RateBranchVC") as! RateBranchVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.branch = branch
        sender.present(vc, animated: true, completion: nil)
    }
    
    static func toRateOrder(_ sender: UIViewController,_ branchId: Int,_ orderId: Int){
        let vc = self.instantiate(appStoryboard: .other, identifier: "RateOrderVC") as! RateOrderVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.branchId = branchId
        vc.orderId = orderId
        sender.present(vc, animated: true, completion: nil)
    }
    
    static func toOrderPlaced(_ sender: UIViewController,_ id: Int){
        let nav = Router.instantiate(appStoryboard: .main, identifier: "OrderPlacedNav") as! UINavigationController
        nav.modalTransitionStyle = .crossDissolve
        nav.modalPresentationStyle = .fullScreen
        (nav.viewControllers.first as! OrderPlacedVC).orderID = id
        sender.present(nav, animated: true, completion: nil)
    }
    
    static func toRegister(_ sender: UIViewController){
        let vc = Router.instantiate(appStoryboard: .main, identifier: "RegisterVC") as! RegisterVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.loginDelegate = (sender as? LoginDelegate)
        sender.present(vc, animated: true, completion: nil)
    }
    
    static func toAllAddress(_ sender: UIViewController,_ addresses: [Address]?){
        let nav = Router.instantiate(appStoryboard: .profile, identifier: "AllAddressesNav") as! UINavigationController
        nav.modalPresentationStyle = .overCurrentContext
        (nav.viewControllers.first as! AllAddressesVC).addresses = addresses
        sender.present(nav, animated: true, completion: nil)
    }
    
    static func toOrderAddress(_ sender: UIViewController,
                               _ address: Address,
                               _ userPhone: String){
        let vc = Router.instantiate(appStoryboard: .orders, identifier: "OrderAddressVC") as! OrderAddressVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.address = address
        vc.userPhone = userPhone
        sender.present(vc, animated: true, completion: nil)
    }
    
    static func toOrderTracking(_ sender: UIViewController,
                                _ userAddress: Address?,
                                _ captainCoords: String?,
                                _ captainName: String?,
                                _ captainPhone: String?,
                                _ orderId: String?){
        let vc = Router.instantiate(appStoryboard: .orders, identifier: "TrackingVC") as! TrackingVC
        vc.userAddress = userAddress
        vc.captainCoords = captainCoords
        vc.captainName = captainName
        vc.captainPhone = captainPhone
        vc.orderId = orderId
        vc.delegate = sender as? OrderUpdatedDelegate
        sender.present(vc, animated: true, completion: nil)
    }
    
    static func toVerifyPhone(_ sender: UIViewController,
                              _ phone: String){
        let vc = self.instantiate(appStoryboard: .other, identifier: "VerifyPhoneVC") as! VerifyPhoneVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = sender as? PhoneVerifyDelegate
        vc.phone = phone
        sender.present(vc, animated: true, completion: nil)
    }
    
    static func toVerifyPhoneFromFirebase(_ sender: UIViewController,
                              _ phone: String){
        let vc = self.instantiate(appStoryboard: .other, identifier: "VerifyPhoneVC") as! VerifyPhoneVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = sender as? PhoneVerifyDelegate
        vc.phone = phone
        vc.provider = .firebase
        sender.present(vc, animated: true, completion: nil)
    }
    
    static func toChooseCategory(_ delegate: ChooserDelegate,_ sender: UIViewController,_ categories: [Category]){
        let vc = self.instantiate(appStoryboard: .home, identifier: "CategoriesVC") as! CategoriesVC
        vc.categories = categories
        vc.delegate = delegate
        //vc.modalPresentationStyle = .overCurrentContext
        sender.navigationController?.pushViewController(vc, animated: false)
    }
    
    static func toTags(_ sender: UIViewController,_ tags: [Tag]){
        let vc = self.instantiate(appStoryboard: .other, identifier: "TagsVC") as! TagsVC
        vc.delegate = sender as? TagsDelegate
        vc.receivedTags = tags
       // vc.modalPresentationStyle = .overCurrentContext
        sender.present(vc, animated: true, completion: nil)
    }
    
}
