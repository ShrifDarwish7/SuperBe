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
import UIKit

protocol MainViewDelegate {
    func showProgress()
    func dismissProgress()
    func showSkeleton()
    func hideSkeleton()
    func didCompleteWithGoogleAddress(_ data: GoogleMapAddress?)
    func didCompleteWithCities(_ cities: [City]?)
    func didCompleteWithCategories(_ data: [Category]?)
    func didCompleteWithBranches(_ data: [Branch]?,_ meta: Meta?)
    func didCompleteWithFeaturedBranches(_ data: [Branch]?)
    func didCompleteWithBranchCats(_ data: [BranchCategory]?)
    func didCompleteWithBranchProducts(_ data: [Product]?)
    func didCompleteWithBranchById(_ data: Branch?)
    func didCompleteWithAddresses(_ data: [Address]?)
    func didCompleteAddAddress(_ error: String?)
    func didCompleteUpdateAddress(_ error: String?)
    func didCompleteDeleteAddress(_ error: String?)
    func didCompletePlaceOrder(_ error: String?,_ id: Int)
    func didCompleteWithMyOrders(_ data: [LastOrder]?,_ meta: Meta?)
    func didCompleteWithMyServices(_ data: [LastOrder]?,_ meta: Meta?)
    func didCompeleteBranchesSearch(_ data: [Branch]?,_ error: String?)
    func didCompeleteProductsSearch(_ data: [Product]?,_ error: String?)
    func didCompleteWithPoints(_ data: PointsData?,_ error: String?)
    func didCompleteWithSlider(_ data: [Slider]?,_ error: String?)
    func didCompleteAddToFavourite(_ error: String?,_ index: Int?,_ isFeatured: Bool?)
    func didCompleteRemoveFromFavourites(_ error: String?,_ index: Int?,_ isFeatured: Bool?)
    func didCompleteWithFavourites()
    func didCompleteUpdateOrder(_ data: LastOrder?,_ error: String?)
    func didCompletePlaceSuperService(_ error: String?,_ id: Int)
  //  func didCompleteWithServices(_ data: [LastOrder]?)
    func didCompleteAddToWallet(_ msg: String,_ status: Int)
    func didCompleteWithBranchRates(_ data: [Rating]?,_ error: String?)
    func didCompleteRate(_ error: String?)
    func didCompleteValidateCoupons(_ status: Int,_ message: String?,_ discountAmount: Double?)
    func didCompleteWithShippingDetails(_ data: ShippingDetails?)
    func didCompleteStartConversation(_ Id: Int?)
    func didCompleteSendMessage(_ sent: Bool,_ id: Int)
    func didCompleteWithConversation(_ data: Conversation?,_ error: String?)
    func didCompleteReopenConversation(_ error: String?)
    func didCompleteLockConversation(_ error: String?)
    func didCompleteExchangePointsToWallet(_ error: String?)
    func didCompleteWithCaptainCoords(_ coords: String?)
    func didCompleteWithOrder(_ data: LastOrder?)
    func didCompleteVerifyPhoneNumber(_ error: String?)
    func didCompletedRequestOtp(_ error: String?)
    func didCompleteUploadOrderFiles(_ error: String?)
    func didCompleteWithTags(_ data: [Tag]?,_ error: String?)
    //func didCompleteWithCoupons(_ data: [Branch]?,_ meta: Meta?)
    func didCompleteWithUserCoupns(_ data: [Coupon]?)
    func didCompleteWithRegionId(_ data: Int?)
    
}

extension MainViewDelegate{
    func showProgress(){ SVProgressHUD.show() }
    func dismissProgress(){ SVProgressHUD.dismiss() }
    func showSkeleton(){}
    func hideSkeleton(){}
    func didCompleteWithGoogleAddress(_ data: GoogleMapAddress?){}
    func didCompleteWithCities(_ cities: [City]?){}
    func didCompleteWithCategories(_ data: [Category]?){}
    func didCompleteWithBranches(_ data: [Branch]?,_ meta: Meta?){}
    func didCompleteWithFeaturedBranches(_ data: [Branch]?){}
    func didCompleteWithBranchCats(_ data: [BranchCategory]?){}
    func didCompleteWithBranchProducts(_ data: [Product]?){}
    func didCompleteWithBranchById(_ data: Branch?){}
    func didCompleteWithAddresses(_ data: [Address]?){}
    func didCompleteAddAddress(_ error: String?){}
    func didCompleteUpdateAddress(_ error: String?){}
    func didCompleteDeleteAddress(_ error: String?){}
    func didCompletePlaceOrder(_ error: String?,_ id: Int){}
    func didCompleteWithMyOrders(_ data: [LastOrder]?,_ meta: Meta?){}
    func didCompeleteBranchesSearch(_ data: [Branch]?,_ error: String?){}
    func didCompeleteProductsSearch(_ data: [Product]?,_ error: String?){}
    func didCompleteWithPoints(_ data: PointsData?,_ error: String?){}
    func didCompleteWithSlider(_ data: [Slider]?,_ error: String?){}
    func didCompleteAddToFavourite(_ error: String?,_ index: Int?,_ isFeatured: Bool?){}
    func didCompleteWithFavourites(){}
    func didCompleteRemoveFromFavourites(_ error: String?,_ index: Int?,_ isFeatured: Bool?){}
    func didCompleteUpdateOrder(_ data: LastOrder?,_ error: String?){}
    func didCompletePlaceSuperService(_ error: String?,_ id: Int){}
   // func didCompleteWithServices(_ data: [LastOrder]?){}
    func didCompleteAddToWallet(_ msg: String,_ status: Int){}
    func didCompleteWithBranchRates(_ data: [Rating]?,_ error: String?){}
    func didCompleteRate(_ error: String?){}
    func didCompleteValidateCoupons(_ status: Int,_ message: String?,_ discountAmount: Double?){}
    func didCompleteWithShippingDetails(_ data: ShippingDetails?){}
    func didCompleteStartConversation(_ Id: Int?){}
    func didCompleteSendMessage(_ sent: Bool,_ id: Int){}
    func didCompleteWithConversation(_ data: Conversation?,_ error: String?){}
    func didCompleteReopenConversation(_ error: String?){}
    func didCompleteLockConversation(_ error: String?){}
    func didCompleteExchangePointsToWallet(_ error: String?){}
    func didCompleteWithCaptainCoords(_ coords: String?){}
    func didCompleteWithOrder(_ data: LastOrder?){}
    func didCompleteVerifyPhoneNumber(_ error: String?){}
    func didCompletedRequestOtp(_ error: String?){}
    func didCompleteWithMyServices(_ data: [LastOrder]?,_ meta: Meta?){}
    func didCompleteUploadOrderFiles(_ error: String?){}
    func didCompleteWithTags(_ data: [Tag]?,_ error: String?){}
   // func didCompleteWithCoupons(_ data: [Branch]?,_ meta: Meta?){}
    func didCompleteWithUserCoupns(_ data: [Coupon]?){}
    func didCompleteWithRegionId(_ data: Int?){}
}

class MainPresenter{
    
    var delegate: MainViewDelegate?
    
    init(_ delegate: MainViewDelegate) {
        self.delegate = delegate
    }
    
    func getRegionBy(_ coords: String){
        delegate?.showProgress()
        APIServices.shared.call(.getRegion(["coordinates" : coords])) { [self] data in
            print("getRegionBy",JSON(data))
            delegate?.dismissProgress()
            if let data = data, let json = try? JSON(data: data){
                delegate?.didCompleteWithRegionId(json["data"]["id"].intValue)
            }else{
                delegate?.didCompleteWithRegionId(nil)
            }
        }
    }
    
    func getUserCoupons(_ type: CouponType){
        delegate?.showProgress()
        APIServices.shared.call(.userCoupons(["type": type.rawValue])) { [self] data in
            print(JSON(data))
            delegate?.dismissProgress()
            if let data = data, let json = try? JSON(data: data), let coupons = try? json["data"].rawData().getDecodedObject(from: [Coupon].self){
                delegate?.didCompleteWithUserCoupns(coupons)
            }else{
                delegate?.didCompleteWithUserCoupns(nil)
            }
        }
    }
    
    func getTags(){
        delegate?.showProgress()
        APIServices.shared.call(.tags) { [self] data in
            print(JSON(data))
            delegate?.dismissProgress()
            if let data = data, let response = data.getDecodedObject(from: TagsResponse.self) {
                delegate?.didCompleteWithTags(response.data, nil)
            }else{
                delegate?.didCompleteWithTags(nil, Shared.errorMsg)
            }
        }
    }
    
    func requestOTP(_ phone: String){
        delegate?.showProgress()
        APIServices.shared.call(.requestOtp(["phone": phone])) { [self] data in
            delegate?.dismissProgress()
            if let data = data,
               let json = try? JSON(data: data){
                if json["status"].intValue == 1{
                    delegate?.didCompletedRequestOtp(nil)
                }else{
                    delegate?.didCompletedRequestOtp(json["message"].stringValue)
                }
            }else{
                delegate?.didCompletedRequestOtp(Shared.errorMsg)
            }
        }
    }
    
    func verifyOTP(_ code: String){
        delegate?.showProgress()
        APIServices.shared.call(.verifyOTP(["otp": code.arToEnDigits!])) { [self] data in
            delegate?.dismissProgress()
            if let data = data,
               let json = try? JSON(data: data){
                if json["status"].intValue == 1{
                    delegate?.didCompleteVerifyPhoneNumber(nil)
                }else{
                    delegate?.didCompleteVerifyPhoneNumber(json["message"].stringValue)
                }
            }else{
                delegate?.didCompleteVerifyPhoneNumber(Shared.errorMsg)
            }
        }
    }
    
    func getOrderBy(_ id: Int){
        self.delegate?.showProgress()
        APIServices.shared.call(.getOrderBy(id, ["with": "captain.user,destinationAddress"])) { [self] data in
            self.delegate?.dismissProgress()
            if let data = data,
               let json = try? JSON(data: data),
               let order = try? json["data"].rawData().getDecodedObject(from: LastOrder.self){
                delegate?.didCompleteWithOrder(order)
            }else{
                delegate?.didCompleteWithOrder(nil)
            }
        }
    }
    
    func getCurrentCaptainCoords(_ id: Int){
        self.delegate?.showProgress()
        APIServices.shared.call(.getCaptain(id)) { data in
            print(JSON(data))
            self.delegate?.dismissProgress()
            if let data = data,
               let json = try? JSON(data: data){
                self.delegate?.didCompleteWithCaptainCoords(json["data"]["coordinates"].string ?? "")
            }else{
                self.delegate?.didCompleteWithCaptainCoords(nil)
            }
        }
    }
    
    func exchangePointsToWallet(_ amount: Int){
        self.delegate?.showProgress()
        APIServices.shared.call(.updateWallet(["points": "\(amount)"])) { data in
            print(JSON(data))
            self.delegate?.dismissProgress()
            if let data = data,
               let json = try? JSON(data: data){
                if json["status"].intValue == 1{
                    self.delegate?.didCompleteExchangePointsToWallet(nil)
                }else{
                    self.delegate?.didCompleteExchangePointsToWallet(json["message"].stringValue)
                }
            }else{
                self.delegate?.didCompleteExchangePointsToWallet(Shared.errorMsg)
            }
        }
    }
    
    func getConversation(_ id: Int){
        self.delegate?.showProgress()
        APIServices.shared.call(.getConversation(id)) { data in
            self.delegate?.dismissProgress()
            if let data = data{
                if let dataModel = data.getDecodedObject(from: ConversationResponse.self){
                    self.delegate?.didCompleteWithConversation(dataModel.data, nil)
                }else{
                    self.delegate?.didCompleteWithConversation(nil, JSON(data)["message"].stringValue)
                }
            }else{
                self.delegate?.didCompleteWithConversation(nil, Shared.errorMsg)
            }
        }
    }
    
    func getOrderConversation(_ orderId: Int){
        self.delegate?.showProgress()
        APIServices.shared.call(.getOrderConversation(["with": "messages", "filter": "order_id=\(orderId)"])) { data in
            print(JSON(data))
            self.delegate?.dismissProgress()
            if let data = data, let json = try? JSON(data: data){
                if let dataModel = try? json["data"].arrayValue.first?.rawData().getDecodedObject(from: Conversation.self){
                    Shared.currentConversationId = dataModel.id
                    self.delegate?.didCompleteWithConversation(dataModel, nil)
                }else{
                    self.delegate?.didCompleteWithConversation(nil, JSON(data)["message"].stringValue)
                }
            }else{
                self.delegate?.didCompleteWithConversation(nil, Shared.errorMsg)
            }
        }
    }
    
    func getSupportMessages(){
        self.delegate?.showProgress()
        APIServices.shared.call(.getSupportMessages(["with": "messages"])) { data in
            print(JSON(data))
            self.delegate?.dismissProgress()
            if let data = data{
                if let dataModel = data.getDecodedObject(from: ConversationResponse.self){
                    Shared.currentConversationId = dataModel.data.id
                    self.delegate?.didCompleteWithConversation(dataModel.data, nil)
                }else{
                    self.delegate?.didCompleteWithConversation(nil, JSON(data)["message"].stringValue)
                }
            }else{
                self.delegate?.didCompleteWithConversation(nil, Shared.errorMsg)
            }
        }
    }
    
    func reopenConversation(){
        APIServices.shared.call(.reopenConversation(Shared.currentConversationId!)) { data in
            print(JSON(data))
            if let _ = data{
                self.delegate?.didCompleteReopenConversation(nil)
            }else{
                self.delegate?.didCompleteReopenConversation(JSON(data!)["message"].stringValue)
            }
        }
    }
    
    func lockConversation(){
        self.delegate?.showProgress()
        APIServices.shared.call(.lockConversation(Shared.currentConversationId!)) { data in
            self.delegate?.dismissProgress()
            print(JSON(data))
            if let _ = data{
                self.delegate?.didCompleteLockConversation(nil)
            }else{
                self.delegate?.didCompleteLockConversation(JSON(data!)["message"].stringValue)
            }
        }
    }
    
    func sendMessage(_ message: String,_ id: Int,_ incrementalId: Int){
        APIServices.shared.call(.sendMessage(id, ["message": message])) { data in
            print(JSON(data))
            if let data = data,
               let json = try? JSON(data: data),
               json["status"].intValue == 1{
                self.delegate?.didCompleteSendMessage(true, incrementalId)
            }else{
                self.delegate?.didCompleteSendMessage(false, incrementalId)
            }
        }
    }
    
    func startConversation(){
        self.delegate?.showProgress()
        APIServices.shared.call(.startConversation) { data in
            self.delegate?.dismissProgress()
            if let data = data,
               let json = try? JSON(data: data),
               json["status"].intValue == 1{
                self.delegate?.didCompleteStartConversation(json["data"]["id"].intValue)
            }else{
                self.delegate?.didCompleteStartConversation(nil)
            }
        }
    }
    
    func startConversation(_ title: String,_ orderId: String){
        self.delegate?.showProgress()
        APIServices.shared.call(.startOrderIssueConveration(["title": title, "order_id": orderId])) { data in
            print(JSON(data))
            self.delegate?.dismissProgress()
            if let data = data,
               let json = try? JSON(data: data),
               json["status"].intValue == 1{
                self.delegate?.didCompleteStartConversation(json["data"]["id"].intValue)
            }else{
                self.delegate?.didCompleteStartConversation(nil)
            }
        }
    }
    
    func getShippingDetails(_ branchId: Int){
        APIServices.shared.call(.getShippingCost(["branch_id": "\(branchId)"])) { data in
            print("getShippingDetails",JSON(data))
            if let data = data,
               let dataModel = data.getDecodedObject(from: ShippingDetailsResponse.self){
                self.delegate?.didCompleteWithShippingDetails(dataModel.data)
            }else{
                self.delegate?.didCompleteWithShippingDetails(nil)
            }
        }
    }
    
    func validateCoupons(_ validatable: ValidatableCoupon){
        APIServices.shared.call(.validateCoupons(validatable)) { data in
            print("validateCoupons", JSON(data))
            if let data = data,
               let json = try? JSON(data: data){
                self.delegate?.didCompleteValidateCoupons(json["status"].intValue, json["message"].stringValue, json["data"].arrayValue.first?["discount_value"].doubleValue.roundToDecimal(1))
            }else{
                self.delegate?.didCompleteValidateCoupons(0, Shared.errorMsg, nil)
            }
        }
    }
    
    func postRate(_ prms: [String: Any]){
        self.delegate?.showProgress()
        APIServices.shared.call(.rate(prms)) { data in
            print(JSON(data))
            self.delegate?.dismissProgress()
            if let data = data,
               let json = try? JSON(data: data){
                if json["status"].intValue == 1{
                    self.delegate?.didCompleteRate(nil)
                }else{
                    self.delegate?.didCompleteRate(json["message"].stringValue)
                }
            }else{
                self.delegate?.didCompleteRate(Shared.errorMsg)
            }
        }
    }
    
    func getBranchRates(_ id: Int){
        APIServices.shared.call(.getBranchRating(id)) { data in
            print(JSON(data))
            if let data = data,
               let json = try? JSON(data: data){
                if json["status"].intValue == 1{
                    if let ratings = try? json["data"]["ratings"].rawData(),
                       var ratingsDataModel = ratings.getDecodedObject(from: [Rating].self),
                       !ratingsDataModel.isEmpty{
                        for i in 0...ratingsDataModel.count-1{
                            ratingsDataModel[i].createdAt = ratingsDataModel[i].createdAt?.getTimeAgo()
                        }
                        self.delegate?.didCompleteWithBranchRates(ratingsDataModel, nil)
                    }else{
                        self.delegate?.didCompleteWithBranchRates([], nil)
                    }
                }else{
                    self.delegate?.didCompleteWithBranchRates(nil, json["message"].stringValue)
                }
            }
        }
    }
    
    func placeSuperService(_ prms: [String: Any],_ images: [String: UIImage]?,_ voice: Data?){
        self.delegate?.showProgress()
        APIServices.shared.call(.placeSuperService(prms, images, voice)) { data in
            print(JSON(data))
            self.delegate?.dismissProgress()
            if let data = data,
               let json = try? JSON(data: data){
                if json["status"].intValue == 1{
                    self.delegate?.didCompletePlaceSuperService(nil, json["data"]["id"].intValue)
                }else{
                    self.delegate?.didCompletePlaceSuperService(json["message"].stringValue, 0)
                }
            }else{
                self.delegate?.didCompletePlaceSuperService(Shared.errorMsg, 0)
            }
        }
    }
    
    func addToWallet(_ amount: Double){
        self.delegate?.showProgress()
        APIServices.shared.call(.addToWallet(["value": amount, "transaction_id": Shared.transaction?.orderId ?? ""])) { data in
            print(JSON(data))
            self.delegate?.dismissProgress()
            if let data = data,
               let json = try? JSON(data: data){
                Shared.transaction = nil
                self.delegate?.didCompleteAddToWallet(json["message"].stringValue, json["status"].intValue)
            }
        }
    }
    
    func getPoints(){
        self.delegate?.showProgress()
        APIServices.shared.call(.points) { (data) in
            self.delegate?.dismissProgress()
            print(JSON(data))
            if let data = data,
               let dataModel = data.getDecodedObject(from: PointsResponse.self),
               let pointsData = dataModel.data{
                self.delegate?.didCompleteWithPoints(pointsData, nil)
            }else{
                self.delegate?.didCompleteWithPoints(nil, Shared.errorMsg)
            }
        }
    }
    
    func getWalletPoints(){
        APIServices.shared.call(.wallet) { (data) in
            if let data = data,
               let dataModel = data.getDecodedObject(from: PointsResponse.self),
               let pointsData = dataModel.data{
                self.delegate?.didCompleteWithPoints(pointsData, nil)
            }else{
                self.delegate?.didCompleteWithPoints(nil, Shared.errorMsg)
            }
        }
    }
    
    func searchWith(query prms: inout [String: String],_ context: Context){
        prms.updateValue(context.rawValue, forKey: "context")
        switch context {
        case .products:
            prms.updateValue("variations.options", forKey: "with")
        case .vendors:
            prms.updateValue("coupons", forKey: "with")
        }
        //print("prms here",prms)
        APIServices.shared.call(.search(prms)) { (data) in
            //print("searchWith ",JSON(data))
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
                    self.delegate?.didCompeleteProductsSearch(dataModel.data.filter({$0.branch != nil}), nil)
                }
            }
        }
    }
    
    func getMyOrders(_ prms: [String: String]){
        APIServices.shared.call(.getMyOrders(prms)) { (data) in
            print("getMyOrders",JSON(data))
            if let data = data,
               let dataModel = data.getDecodedObject(from: LastOrdersResponse.self){
                self.delegate?.didCompleteWithMyOrders(dataModel.data?.filter({ $0.branch != nil }), dataModel.meta)
            }else{
                self.delegate?.didCompleteWithMyOrders(nil, nil)
            }
        }
    }
    
    func getMyServices(_ prms: [String: String]){
//        let prms = [
//            "filter": "user_id=\(APIServices.shared.user?.id ?? 0)",
//            "with": "captain.user,destinationAddress"
//        ]
        APIServices.shared.call(.getServices(prms)) { (data) in
            print("getMyServices",JSON(data))
            if let data = data,
               let dataModel = data.getDecodedObject(from: LastOrdersResponse.self){
                self.delegate?.didCompleteWithMyServices(dataModel.data, dataModel.meta)
            }else{
                self.delegate?.didCompleteWithMyServices(nil, nil)
            }
        }
    }
    
    func placeOrder(_ order: Order){
        self.delegate?.showProgress()
        APIServices.shared.call(.placeOrder(order)) { (data) in
            self.delegate?.dismissProgress()
            if let data = data{
                let json = JSON(data)
                print("place order response",json)
                if json["status"].intValue == 0{
                    self.delegate?.didCompletePlaceOrder(json["message"].stringValue, 0)
                }else{
                    self.delegate?.didCompletePlaceOrder(nil, json["data"]["id"].intValue)
                }
            }else{
                self.delegate?.didCompletePlaceOrder(Shared.errorMsg, 0)
            }
        }
    }
    
    func uploadFilesToOrder(_ id: Int,_ items: [CartItem]){
        delegate?.showProgress()
        
        let mediaItems = items.filter({ return $0.is_media })
        
        var photos = [UIImage]()
        var voices = [Data]()
        var notes = [String]()
        
        for item in mediaItems{
            
            if let _ = item.photos{
                let photosData = try! JSONDecoder.init().decode([Data].self, from: item.photos!)
                let photosTemp = photosData.map({ UIImage(data: $0) })
                photosTemp.forEach { photo in
                    photos.append(photo!)
                }
            }
            
            if let voice = item.voice{
                voices.append(voice)
            }
            
            if let note = item.text{
                notes.append(note)
            }
        }
        
        APIServices.shared.call(.uploadFilesToOrder(id, photos, voices, notes)) { [self] data in
            delegate?.dismissProgress()
            if let data = data{
                let json = JSON(data)
                print("upload  response",json)
                if json["status"].intValue == 0{
                    self.delegate?.didCompleteUploadOrderFiles(json["message"].stringValue)
                }else{
                    self.delegate?.didCompleteUploadOrderFiles(nil)
                }
            }else{
                self.delegate?.didCompleteUploadOrderFiles(Shared.errorMsg)
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
            print("getBranchProduct", JSON(data))
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
            print(JSON(data))
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
            print(JSON(data))
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
          //  print(JSON(data))
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
          //  print("getBranches",JSON(data))
            if let data = data,
               var dataModel = data.getDecodedObject(from: BranchesResponse.self),
               !dataModel.data.isEmpty{
                for i in 0...(dataModel.data.count-1){
                    if let favBranches = Shared.favBranches,
                       !favBranches.isEmpty,
                       !favBranches.filter({ return $0.id == dataModel.data[i].id}).isEmpty{
                        dataModel.data[i].isFavourite = 1
                    }
                }
                delegate?.didCompleteWithBranches(dataModel.data, dataModel.meta)
            }else{
                delegate?.didCompleteWithBranches(nil, nil)
            }
        }
    }
    
    func getOffers(_ prms: [String:String]){
        APIServices.shared.call(.productOffers(prms)) { [self] (data) in
            print("getBranches",JSON(data))
            if let data = data,
               var dataModel = data.getDecodedObject(from: BranchesResponse.self),
               !dataModel.data.isEmpty{
                for i in 0...(dataModel.data.count-1){
                    if let favBranches = Shared.favBranches,
                       !favBranches.isEmpty,
                       !favBranches.filter({ return $0.id == dataModel.data[i].id}).isEmpty{
                        dataModel.data[i].isFavourite = 1
                    }
                }
                delegate?.didCompleteWithBranches(dataModel.data, dataModel.meta)
            }else{
                delegate?.didCompleteWithBranches(nil, nil)
            }
        }
    }
    
    func getCouponsOffers(_ prms: [String:String]){
        APIServices.shared.call(.couponsOffers(prms)) { [self] (data) in
            print("getBranches",JSON(data))
            if let data = data,
               var dataModel = data.getDecodedObject(from: BranchesResponse.self),
               !dataModel.data.isEmpty{
                for i in 0...(dataModel.data.count-1){
                    if let favBranches = Shared.favBranches,
                       !favBranches.isEmpty,
                       !favBranches.filter({ return $0.id == dataModel.data[i].id}).isEmpty{
                        dataModel.data[i].isFavourite = 1
                    }
                }
                delegate?.didCompleteWithBranches(dataModel.data, dataModel.meta)
            }else{
                delegate?.didCompleteWithBranches(nil, nil)
            }
        }
    }
    
    func getOrdinaryBranches(_ prms: [String:String]){
        var prms = prms
        prms.updateValue("is_featured=0", forKey: "filter")
        APIServices.shared.call(.getBranches(prms)) { [self] (data) in
            print("getBranches",JSON(data))
            if let data = data,
               var dataModel = data.getDecodedObject(from: BranchesResponse.self),
               !dataModel.data.isEmpty{
                for i in 0...(dataModel.data.count-1){
                    if let favBranches = Shared.favBranches,
                       !favBranches.isEmpty,
                       !favBranches.filter({ return $0.id == dataModel.data[i].id}).isEmpty{
                        dataModel.data[i].isFavourite = 1
                    }
                }
                delegate?.didCompleteWithBranches(dataModel.data, dataModel.meta)
            }else{
                delegate?.didCompleteWithBranches(nil, nil)
            }
        }
    }
    
    func getFeaturedBranches(_ prms: [String:String]){
        var prms = prms
        prms.updateValue("is_featured=1", forKey: "filter")
        APIServices.shared.call(.getBranches(prms)) { [self] (data) in
            print("is_featured branches", JSON(data))
            if let data = data,
               var dataModel = data.getDecodedObject(from: BranchesResponse.self), !dataModel.data.isEmpty{
                for i in 0...(dataModel.data.count-1){
                    if let favBranches = Shared.favBranches,
                       !favBranches.isEmpty,
                       !favBranches.filter({ return $0.id == dataModel.data[i].id}).isEmpty{
                        dataModel.data[i].isFavourite = 1
                    }
                }
                delegate?.didCompleteWithFeaturedBranches(dataModel.data)
            }else{
                delegate?.didCompleteWithFeaturedBranches(nil)
            }
        }
    }
    
    func getSlider(_ prms: [String: String]){
        APIServices.shared.call(.slider(prms)) { [self] data in
            print("getSlider",JSON(data))
            if let data = data,
               let dataModel = data.getDecodedObject(from: SliderResponse.self){
                delegate?.didCompleteWithSlider(dataModel.data, nil)
            }else{
                delegate?.didCompleteWithSlider(nil, Shared.errorMsg)
            }
        }
    }
    
    func addToFavourite(_ prms: [String: String],_ index: Int?,_ isFeatured: Bool?){
        APIServices.shared.call(.addToFavourite(prms)) { data in
            print("addToFavourite",JSON(data))
            if let data = data,
               let dataModel = data.getDecodedObject(from: FavouritesResponse.self){
                
                var branches = [Branch]()
                var products = [Product]()
                
                dataModel.data?.favouritableBranches?.filter({ $0.favouritable != nil }).forEach({ favBranch in
                    var branch: Branch = favBranch.favouritable!
                    branch.favouriteId = favBranch.id
                    branches.append(branch)
                })
                
                dataModel.data?.favouritableProducts?.filter({ $0.favouritable != nil }).forEach({ favProduct in
                    var product: Product = favProduct.favouritable!
                    product.favouriteId = favProduct.id
                    products.append(product)
                })
                
                Shared.favBranches = branches
                Shared.favProducts = products
                
                self.delegate?.didCompleteAddToFavourite(nil, index, isFeatured)
            }else{
                self.delegate?.didCompleteAddToFavourite(Shared.errorMsg, index, isFeatured)
            }
        }
    }
    
    func removeFromFavourites(_ id: Int,_ index: Int?,_ isFeatured: Bool?){
        APIServices.shared.call(.removeFromFavourtie(id)) { data in
            print("removeFromFavourites",JSON(data))
            if let data = data,
               let dataModel = data.getDecodedObject(from: FavouritesResponse.self){
                
                var branches = [Branch]()
                var products = [Product]()
                
                dataModel.data?.favouritableBranches?.filter({ $0.favouritable != nil }).forEach({ favBranch in
                    var branch: Branch = favBranch.favouritable!
                    branch.favouriteId = favBranch.id
                    branches.append(branch)
                })
                
                dataModel.data?.favouritableProducts?.filter({ $0.favouritable != nil }).forEach({ favProduct in
                    var product: Product = favProduct.favouritable!
                    product.favouriteId = favProduct.id
                    products.append(product)
                })
                
                Shared.favBranches = branches
                Shared.favProducts = products
                
                self.delegate?.didCompleteRemoveFromFavourites(nil, index, isFeatured)
            }else{
                self.delegate?.didCompleteRemoveFromFavourites(Shared.errorMsg, index, isFeatured)
            }
        }
    }
    
    func getFavourites(){
        APIServices.shared.call(.favourite) { data in
            print("getFavourites",JSON(data))
            if let data = data,
               let dataModel = data.getDecodedObject(from: FavouritesResponse.self){
                
                var branches = [Branch]()
                var products = [Product]()
                
                dataModel.data?.favouritableBranches?.filter({ $0.favouritable != nil }).forEach({ favBranch in
               //     print(favBranch.favouritable)
                    var branch: Branch = favBranch.favouritable!
                    branch.favouriteId = favBranch.id
                    branches.append(branch)
                })
                
                dataModel.data?.favouritableProducts?.filter({ $0.favouritable != nil }).forEach({ favProduct in
                    var product: Product = favProduct.favouritable!
                    product.favouriteId = favProduct.id
                    products.append(product)
                })
                
                Shared.favBranches = branches
                Shared.favProducts = products
                
                self.delegate?.didCompleteWithFavourites()
               
            }else{
                self.delegate?.didCompleteWithFavourites()
            }
        }
    }
    
//    func favouritesParser(json: JSON,_ completed: @escaping ([Branch]?,[Product]?)->Void){
//        var branches = [Branch]()
//        var products = [Product]()
//
//        if let branchesData = json["data"].array?.filter({ return $0["favouritable_type"].stringValue == "App\\Models\\Branch" }){
//            branchesData.forEach { json in
//                guard var branch = try? json["favouritable"].rawData().getDecodedObject(from: Branch.self) else { return }
//                branch.favouriteId = json["id"].intValue
//                branches.append(branch)
//            }
//        }
//
//        if let productsData = json["data"].array?.filter({ return $0["favouritable_type"].stringValue == "App\\Models\\BranchProduct" }){
//            productsData.forEach { json in
//                guard var product = try? json["favouritable"].rawData().getDecodedObject(from: Product.self) else { return }
//                product.favouriteId = json["id"].intValue
//                products.append(product)
//            }
//        }
//        Shared.favBranches = branches
//        Shared.favProducts = products
//        completed(branches,products)
//    }
    
    func updateOrder(id: Int, prms: [String: String]){
        self.delegate?.showProgress()
        APIServices.shared.call(.updateOrder(id, prms)) { data in
            self.delegate?.dismissProgress()
            if let data = data,
               let json = try? JSON(data: data){
                print("cas",json)
                if json["status"].int == 1 {
                    guard let data = try? json["data"].rawData() else { return }
                    self.delegate?.didCompleteUpdateOrder(data.getDecodedObject(from: LastOrder.self), nil)
                }else{
                    self.delegate?.didCompleteUpdateOrder(nil, json["message"].stringValue)
                }
                
            }else{
                self.delegate?.didCompleteUpdateOrder(nil, Shared.errorMsg)
            }
        }
    }
}

