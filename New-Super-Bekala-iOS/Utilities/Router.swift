//
//  Router.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 8/9/20.
//  Copyright © 2020 Super Bekala. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

enum AppStoryboard: String {
    case main = "Main"
    case home = "Home"
    case orders = "Orders"
    case profile = "Profile"
    case services = "Services"
}

class Router {
    
    static func instantiate<T: UIViewController>(appStoryboard: AppStoryboard, identifier: String) -> T {
        let storyboard = UIStoryboard(name: appStoryboard.rawValue, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
    
    static func toMainNav(_ sender: UIViewController){
        let nv = self.instantiate(appStoryboard: .main, identifier: "NavGuide") as! UINavigationController
        nv.modalPresentationStyle = .fullScreen
        sender.present(nv, animated: true, completion: nil)
    }
    
    static func toHome(_ sender: UIViewController){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeContainerVC") as! HomeContainerVC
        sender.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func toMaps(_ sender: UIViewController){
        let vc = self.instantiate(appStoryboard: .home, identifier: "MapVC") as! MapVC
        Shared.mapState = .fetchLocation
        sender.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func toAddAddress(_ sender: UIViewController,_ path: GMSPath?){
        let vc = self.instantiate(appStoryboard: .home, identifier: "MapVC") as! MapVC
        Shared.mapState = .addAddress
        vc.path = path
        sender.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func toLogin(_ sender: UIViewController){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        //vc.modalPresentationStyle = .fullScreen
        sender.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func toAboutUs(_ sender: UIViewController){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
        sender.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func toAskLocation(_ sender: UIViewController){
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
    
    static func toCheckout(_ sender: UIViewController, _ branch: Branch?){
        let vc = self.instantiate(appStoryboard: .orders, identifier: "CheckoutVC") as! CheckoutVC
        vc.branch = branch
        sender.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func toOrder(_ sender: UIViewController, _ order: LastOrder){
        let vc = self.instantiate(appStoryboard: .orders, identifier: "OrderVC") as! OrderVC
        vc.order = order
        vc.modalPresentationStyle = .overCurrentContext
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
    
    static func toSearch(_ sender: UIViewController){
        let vc = self.instantiate(appStoryboard: .home, identifier: "SearchVC") as! SearchVC
        sender.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func toFilters(_ sender: UIViewController){
        let vc = self.instantiate(appStoryboard: .home, identifier: "FiltersVC") as! FiltersVC
        sender.present(vc, animated: true, completion: nil)
    }
    
    static func toProfile(_ sender: UIViewController){
        let vc = self.instantiate(appStoryboard: .profile, identifier: "ProfileVC") as! ProfileVC
        sender.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func toPointsContainer(_ sender: UIViewController){
        let vc = self.instantiate(appStoryboard: .profile, identifier: "PointsContainerVC") as! PointsContainerVC
        sender.navigationController?.pushViewController(vc, animated: true)
    }
    
    static func toShareLocation(_ sender: UIViewController){
        let vc = self.instantiate(appStoryboard: .services, identifier: "ServicesNav") as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
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
        vc.modalPresentationStyle = .overCurrentContext
        sender.present(vc, animated: true, completion: nil)
    }
    
    static func toSuperServicesSummary(_ sender: UIViewController,_ service: SuperService?){
        let vc = self.instantiate(appStoryboard: .services, identifier: "ServicesCheckoutVC") as! ServicesCheckoutVC
        vc.superService = service
        vc.serviceType = .summary
        vc.modalPresentationStyle = .overCurrentContext
        sender.present(vc, animated: true, completion: nil)
    }
    
    static func toChooser(_ sender: UIViewController,_ list: [String]?){
        let vc = self.instantiate(appStoryboard: .home, identifier: "ChooserVC") as! ChooserVC
        vc.list = list
        vc.modalPresentationStyle = .overCurrentContext
        sender.present(vc, animated: true, completion: nil)
    }
    
    static func toPayContainer(_ sender: UIViewController){
        let vc = self.instantiate(appStoryboard: .orders, identifier: "PayContainerVC") as! PayContainerVC
        vc.modalPresentationStyle = .overCurrentContext
        sender.present(vc, animated: true, completion: nil)
    }
}
