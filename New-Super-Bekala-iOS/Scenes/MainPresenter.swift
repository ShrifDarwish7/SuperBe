//
//  MainPresenter.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 23/01/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import SwiftyJSON
import SVProgressHUD

protocol MainViewDelegate {
    func showProgress()
    func dismissProgress()
    func showSkeleton()
    func hideSkeleton()
    func didCompleteWithGoogleAddress(_ data: GoogleMapAddress?)
    func didCompleteWithCities(_ cities: [City]?)
    func didCompleteWithCategories(_ data: [Category]?)
    func didCompleteWithBranches(_ data: [Branch]?)
    func didCompleteWithFeaturedBranches(_ data: [Branch]?)
    func didCompleteWithBranchCats(_ data: [BranchCategory]?)
    func didCompleteWithBranchProducts(_ data: [Product]?)
    func didCompleteWithBranchById(_ data: Branch?)
    func didCompleteWithAddresses(_ data: [Address]?)
    func didCompleteAddAddress(_ error: String?)
    func didCompleteUpdateAddress(_ error: String?)
    func didCompleteDeleteAddress(_ error: String?)
    func didCompletePlaceOrder(_ error: String?)
    func didCompleteWithMyOrders(_ data: [LastOrder]?)
    func didCompeleteBranchesSearch(_ data: [Branch]?,_ error: String?)
    func didCompeleteProductsSearch(_ data: [Product]?,_ error: String?)
    func didCompleteWithPoints(_ data: PointsData?,_ error: String?)
}

extension MainViewDelegate{
    func showProgress(){ SVProgressHUD.show() }
    func dismissProgress(){ SVProgressHUD.dismiss() }
    func showSkeleton(){}
    func hideSkeleton(){}
    func didCompleteWithGoogleAddress(_ data: GoogleMapAddress?){}
    func didCompleteWithCities(_ cities: [City]?){}
    func didCompleteWithCategories(_ data: [Category]?){}
    func didCompleteWithBranches(_ data: [Branch]?){}
    func didCompleteWithFeaturedBranches(_ data: [Branch]?){}
    func didCompleteWithBranchCats(_ data: [BranchCategory]?){}
    func didCompleteWithBranchProducts(_ data: [Product]?){}
    func didCompleteWithBranchById(_ data: Branch?){}
    func didCompleteWithAddresses(_ data: [Address]?){}
    func didCompleteAddAddress(_ error: String?){}
    func didCompleteUpdateAddress(_ error: String?){}
    func didCompleteDeleteAddress(_ error: String?){}
    func didCompletePlaceOrder(_ error: String?){}
    func didCompleteWithMyOrders(_ data: [LastOrder]?){}
    func didCompeleteBranchesSearch(_ data: [Branch]?,_ error: String?){}
    func didCompeleteProductsSearch(_ data: [Product]?,_ error: String?){}
    func didCompleteWithPoints(_ data: PointsData?,_ error: String?){}
}

class MainPresenter{
    
    var delegate: MainViewDelegate?
    
    init(_ delegate: MainViewDelegate) {
        self.delegate = delegate
    }
    
    func getPoints(){
        APIServices.shared.call(.points) { (data) in
            if let data = data,
               let dataModel = data.getDecodedObject(from: PointsResponse.self),
               let pointsData = dataModel.data{
                self.delegate?.didCompleteWithPoints(pointsData, nil)
            }else{
                self.delegate?.didCompleteWithPoints(nil, Shared.errorMsg)
            }
        }
    }
    
    func searchWith( query prms: inout [String: String],_ context: Context){
        prms.updateValue(context.rawValue, forKey: "context")
        switch context {
        case .products:
            prms.updateValue("branch.branchLanguage,variations.options", forKey: "with")
        default:
            break
        }
        print(prms)
        APIServices.shared.call(.search(prms)) { (data) in
            print(JSON(data))
            if let data = data{
                switch context {
                case .vendors:
                    guard let dataModel = data.getDecodedObject(from: BranchesResponse.self) else {
                        self.delegate?.didCompeleteBranchesSearch(nil, Shared.errorMsg)
                        return
                    }
                    self.delegate?.didCompeleteBranchesSearch(dataModel.data, nil)
                case .products:
                    guard let dataModel = data.getDecodedObject(from: ProductsResponse.self) else {
                        self.delegate?.didCompeleteProductsSearch(nil, Shared.errorMsg)
                        return
                    }
                    self.delegate?.didCompeleteProductsSearch(dataModel.data, nil)
                }
            }
        }
    }
    
    func getMyOrders(){
       // let prms = ["filter": "user_id=\(APIServices.shared.user?.user.id ?? 0)"]
        let prms = ["filter": "user_id=1"]
        APIServices.shared.call(.getMyOrders(prms)) { (data) in
            print(JSON(data))
            if let data = data,
               let dataModel = data.getDecodedObject(from: LastOrdersResponse.self){
                self.delegate?.didCompleteWithMyOrders(dataModel.data)
            }else{
                self.delegate?.didCompleteWithMyOrders(nil)
            }
        }
    }
    
    func placeOrder(_ order: Order){
        self.delegate?.showProgress()
        let data = try! JSONEncoder.init().encode(order)
        print("order prms",JSON(data))
        APIServices.shared.call(.placeOrder(data)) { (data) in
            self.delegate?.dismissProgress()
            if let data = data{
                let json = JSON(data)
                print("place order response",json)
                if json["status"].intValue == 0{
                    self.delegate?.didCompletePlaceOrder(json["message"].stringValue)
                }else{
                    self.delegate?.didCompletePlaceOrder(nil)
                }
            }else{
                self.delegate?.didCompletePlaceOrder(Shared.errorMsg)
            }
        }
    }
    
    func deleteAddress(_ id: Int){
        APIServices.shared.call(.deleteAddress(id)) { (data) in
            if let data = data{
                let json = JSON(data)
                if json["status"].intValue == 0{
                    self.delegate?.didCompleteDeleteAddress(json["message"].stringValue)
                }else{
                    self.delegate?.didCompleteDeleteAddress(nil)
                }
            }
        }
    }
    
    func updateAddress(_ id: Int,_ prms: [String: String]){
        APIServices.shared.call(.updateAddress(id,prms)) { (data) in
            if let data = data{
                let json = JSON(data)
                if json["status"].intValue == 0{
                    self.delegate?.didCompleteUpdateAddress(json["message"].stringValue)
                }else{
                    self.delegate?.didCompleteUpdateAddress(nil)
                }
            }
        }
    }
    
    func addAddress(_ prms: [String: String]){
        self.delegate?.showProgress()
        APIServices.shared.call(.postAddress(prms)) { (data) in
            self.delegate?.dismissProgress()
            if let data = data{
                let json = JSON(data)
                if json["status"].intValue == 0{
                    self.delegate?.didCompleteAddAddress(json["message"].stringValue)
                }else{
                    self.delegate?.didCompleteAddAddress(nil)
                }
            }
        }
    }
    
    func getAddresses(){
        APIServices.shared.call(.getAddresses) { (data) in
            print(JSON(data))
            if let data = data,
               let dataModel = data.getDecodedObject(from: AddressesResponse.self){
                self.delegate?.didCompleteWithAddresses(dataModel.data)
            }else{
                self.delegate?.didCompleteWithAddresses(nil)
            }
        }
    }
    
    func getBranchBy(_ id: Int){
        self.delegate?.showProgress()
        APIServices.shared.call(.getBranchBy(id)) { (data) in
            self.delegate?.dismissProgress()
            if let data = data{
                let json = JSON(data)
                print(json)
                if json["status"].int == 1,
                   let dataModel = try! json["data"].rawData().getDecodedObject(from: Branch.self){
                    self.delegate?.didCompleteWithBranchById(dataModel)
                }else{
                    self.delegate?.didCompleteWithBranchById(nil)
                }
            }else{
                self.delegate?.didCompleteWithBranchById(nil)
            }
        }
    }
    
    func getBranchProduct(id: Int, prms: [String: String]){
        APIServices.shared.call(.getBranchProducts(prms, id)) { (data) in
            if let data = data,
               let dataModel = data.getDecodedObject(from: ProductsResponse.self){
                self.delegate?.didCompleteWithBranchProducts(dataModel.data)
            }else{
                self.delegate?.didCompleteWithBranchProducts(nil)
            }
        }
    }
    
    func getBranchCats(prms: [String: String], id: Int){
       // self.delegate?.showProgress()
        APIServices.shared.call(.getBranchCats(id, prms)) { (data) in
         //   self.delegate?.dismissProgress()
            if let data = data,
               let dataModel = data.getDecodedObject(from: BranchCatsResponse.self){
                self.delegate?.didCompleteWithBranchCats(dataModel.data)
            }else{
                self.delegate?.didCompleteWithBranchCats(nil)
            }
        }
    }
    
    func getGeocode(_ parms: [String:String]){
        delegate?.showProgress()
        APIServices.shared.call(.getGeocode(parms)) { [self] (data) in
            delegate?.dismissProgress()
            if let data = data,
               let result = JSON(data)["results"].array,
               result.count > 0{
                let dataModel = GoogleMapAddress(JSON(data)["results"])
                delegate?.didCompleteWithGoogleAddress(dataModel)
            }else{
                delegate?.didCompleteWithGoogleAddress(nil)
            }
        }
    }
    
    func getCities(_ prms: [String: String]){
        delegate?.showProgress()
        APIServices.shared.call(.getCities(prms)) { [self] (data) in
            delegate?.dismissProgress()
            if let data = data,
               let dataModel = data.getDecodedObject(from: CitiesResponse.self){
                delegate?.didCompleteWithCities(dataModel.data)
            }else{
                delegate?.didCompleteWithCities(nil)
            }
        }
    }
    
    func getCategories(_ prms: [String: String]){
        delegate?.showSkeleton()
        APIServices.shared.call(.getCategories(prms)) { [self] (data) in
            print(JSON(data))
            delegate?.hideSkeleton()
            if let data = data,
               let dataModel = data.getDecodedObject(from: CategoriesResponse.self){
                delegate?.didCompleteWithCategories(dataModel.data)
            }else{
                delegate?.didCompleteWithCategories(nil)
            }
        }
    }
    
    func getBranches(_ prms: [String:String]){
        APIServices.shared.call(.getBranches(prms)) { [self] (data) in
            print(JSON(data))
            if let data = data,
               let dataModel = data.getDecodedObject(from: BranchesResponse.self){
                delegate?.didCompleteWithBranches(dataModel.data)
            }else{
                delegate?.didCompleteWithBranches(nil)
            }
        }
    }
    
    func getFeaturedBranches(_ prms: [String:String]){
//        var prms = prms
//        prms.updateValue("is_featured=1", forKey: "filter")
        APIServices.shared.call(.getBranches(prms)) { [self] (data) in
            if let data = data,
               let dataModel = data.getDecodedObject(from: BranchesResponse.self){
                delegate?.didCompleteWithFeaturedBranches(dataModel.data)
            }else{
                delegate?.didCompleteWithFeaturedBranches(nil)
            }
        }
    }
}

