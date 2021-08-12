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
    func didCompleteWithMyOrders(_ data: [LastOrder]?)
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
    func didCompleteValidateCoupons(_ status: Int,_ message: String?)
    func didCompleteWithShippingDetails(_ data: ShippingDetails?)
    func didCompleteStartConversation(_ Id: Int?)
    func didCompleteSendMessage(_ sent: Bool,_ id: Int)
    func didCompleteWithConversation(_ data: Conversation?,_ error: String?)
    func didCompleteReopenConversation(_ error: String?)
    func didCompleteLockConversation(_ error: String?)
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
    func didCompleteWithMyOrders(_ data: [LastOrder]?){}
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
    func didCompleteValidateCoupons(_ status: Int,_ message: String?){}
    func didCompleteWithShippingDetails(_ data: ShippingDetails?){}
    func didCompleteStartConversation(_ Id: Int?){}
    func didCompleteSendMessage(_ sent: Bool,_ id: Int){}
    func didCompleteWithConversation(_ data: Conversation?,_ error: String?){}
    func didCompleteReopenConversation(_ error: String?){}
    func didCompleteLockConversation(_ error: String?){}
}

class MainPresenter{
    
    var delegate: MainViewDelegate?
    
    init(_ delegate: MainViewDelegate) {
        self.delegate = delegate
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
    
    func reopenConversation(){
        APIServices.shared.call(.reopenConversation(Shared.currentConversationId!)) { data in
            print(JSON(data))
            if let data = data,
               let json = try? JSON(data: data),
               json["status"].intValue == 1{
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
            if let data = data,
               let json = try? JSON(data: data),
               json["status"].intValue == 1{
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
                self.delegate?.didCompleteValidateCoupons(json["status"].intValue, json["message"].stringValue)
            }else{
                self.delegate?.didCompleteValidateCoupons(0, Shared.errorMsg)
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
        APIServices.shared.call(.addToWallet(["value": amount])) { data in
            print(JSON(data))
            self.delegate?.dismissProgress()
            if let data = data,
               let json = try? JSON(data: data){
                self.delegate?.didCompleteAddToWallet(json["message"].stringValue, json["status"].intValue)
            }
        }
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
        let prms = [
            "filter": "user_id=\(APIServices.shared.user?.id ?? 0)",
            "with": "captain.user"
        ]
        APIServices.shared.call(.getMyOrders(prms)) { (data) in
            print("getMyOrders",JSON(data))
            if let data = data,
               let dataModel = data.getDecodedObject(from: LastOrdersResponse.self){
                self.delegate?.didCompleteWithMyOrders(dataModel.data?.filter({ $0.branch != nil }))
            }else{
                self.delegate?.didCompleteWithMyOrders(nil)
            }
        }
    }
    
    func getMyServices(){
        let prms = ["filter": "user_id=\(APIServices.shared.user?.id ?? 0)"]
       // let prms = ["filter": "user_id=1"]
        APIServices.shared.call(.getMyOrders(prms)) { (data) in
            print("getMyServices",JSON(data))
            if let data = data,
               let dataModel = data.getDecodedObject(from: LastOrdersResponse.self){
                self.delegate?.didCompleteWithMyOrders(dataModel.data?.filter({ return $0.branch == nil }))
            }else{
                self.delegate?.didCompleteWithMyOrders(nil)
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
            print("getBranches",JSON(data))
            if let data = data,
               var dataModel = data.getDecodedObject(from: BranchesResponse.self){
                for i in 0...dataModel.data.count-1{
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
            //print("is_featured branches", JSON(data))
            if let data = data,
               let dataModel = data.getDecodedObject(from: BranchesResponse.self){
                delegate?.didCompleteWithFeaturedBranches(dataModel.data)
            }else{
                delegate?.didCompleteWithFeaturedBranches(nil)
            }
        }
    }
    
    func getSlider(_ prms: [String: String]){
        APIServices.shared.call(.slider(prms)) { [self] data in
            //print("getSlider",JSON(data))
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
                
                dataModel.data?.favouritableBranches?.forEach({ favBranch in
                    var branch: Branch = favBranch.favouritable!
                    branch.favouriteId = favBranch.id
                    branches.append(branch)
                })
                
                dataModel.data?.favouritableProducts?.forEach({ favProduct in
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
                
                dataModel.data?.favouritableBranches?.forEach({ favBranch in
                    var branch: Branch = favBranch.favouritable!
                    branch.favouriteId = favBranch.id
                    branches.append(branch)
                })
                
                dataModel.data?.favouritableProducts?.forEach({ favProduct in
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
                
                dataModel.data?.favouritableBranches?.forEach({ favBranch in
                    var branch: Branch = favBranch.favouritable!
                    branch.favouriteId = favBranch.id
                    branches.append(branch)
                })
                
                dataModel.data?.favouritableProducts?.forEach({ favProduct in
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

