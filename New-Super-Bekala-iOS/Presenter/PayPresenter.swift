//
//  PayPresenter.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 06/06/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import MPGSDK
import SwiftyJSON

enum ApiOperations: String{
    case initiateAuthentication = "INITIATE_AUTHENTICATION"
    case authenticatePayer = "AUTHENTICATE_PAYER"
    case pay = "PAY"
}

protocol PayDelegate {
    func didCompleteCreateSession(_ session: String?)
    func didCompleteUpdateSessionWithOrder(_ success: Bool)
    func didCompleteUpdateSessionWithPayerData(_ success: Bool)
    func didCompleteCheck3DSEnrollment(_ proceed: Bool,_ redirectURL: String?)
    func didCompleteAuthPayerWith(_ redirectHtml: String?, _ redirectUrl: String?)
    func didCompleteVerifyPayerWith(_ authToken: String?,_ transactionId: String?,_ enrolled: String?)
    func didCompletePerformPay(_ success: Bool,_ transactionId: String?)
}

class PayPresenter{
    
    var delegate: PayDelegate?
    
    init(delegate: PayDelegate) {
        self.delegate = delegate
    }
    
    func createSession(){
        APIServices.shared.call(.createSession) { data in
            print("createSession ",JSON(data))
            if let data = data,
               let json = try? JSON(data: data),
               json["result"].stringValue == "SUCCESS"{
                self.delegate?.didCompleteCreateSession(json["session"]["id"].stringValue)
            }else{
                self.delegate?.didCompleteCreateSession(nil)
            }
        }
    }
    
    func updateSessionWithOrder(){
        
        var payload = GatewayMap()
        payload[at: "order.currency"] = Shared.transaction?.currency
        payload[at: "order.amount"] = Shared.transaction?.amount
        payload[at: "order.id"] = Shared.transaction?.orderId
        
        APIServices.shared.call(.updateSession((Shared.transaction?.session!)!, payload)) { data in
            print("updateSessionWithOrder ",JSON(data))
            if let data = data,
               let json = try? JSON(data: data),
               json["session"]["updateStatus"].string == "SUCCESS"{
                self.delegate?.didCompleteUpdateSessionWithOrder(true)
            }else{
                self.delegate?.didCompleteUpdateSessionWithOrder(false)
            }
        }
    }
    
    func updateSessionWithPayerData(){
        
        var payload = GatewayMap()
        payload[at: "sourceOfFunds.provided.card.nameOnCard"] = Shared.transaction?.nameOnCard
        payload[at: "sourceOfFunds.provided.card.number"] = Shared.transaction?.cardNumber
        payload[at: "sourceOfFunds.provided.card.securityCode"] = Shared.transaction?.cvv
        payload[at: "sourceOfFunds.provided.card.expiry.month"] = Shared.transaction?.expiryMM
        payload[at: "sourceOfFunds.provided.card.expiry.year"] = Shared.transaction?.expiryYY
        payload[at: "sourceOfFunds.type"] = "CARD"
        
        APIServices.shared.call(.updateSession((Shared.transaction?.session!)!, payload)) { data in
            print("updateSessionWithPayerData ", JSON(data))
            if let data = data,
               let json = try? JSON(data: data),
               json["session"]["updateStatus"].string == "SUCCESS"{
                self.delegate?.didCompleteUpdateSessionWithPayerData(true)
            }else{
                self.delegate?.didCompleteUpdateSessionWithPayerData(false)
            }
        }
    }
    
    func check3DSEnrollment(){
        
        var payload = GatewayMap(["apiOperation": ApiOperations.initiateAuthentication.rawValue])
        
       // payload[at: "order.amount"] = "1.0"
        payload[at: "order.currency"] = Shared.transaction?.currency
        payload[at: "session.id"] = Shared.transaction?.session
      //  payload[at: "3DSecure.authenticationRedirect.responseUrl"] = redirectURL
        
        payload[at: "authentication.acceptVersions"] = "3DS1,3DS2"
        payload[at: "authentication.channel"] = "PAYER_BROWSER"
        payload[at: "authentication.purpose"] = "PAYMENT_TRANSACTION"
        
        APIServices.shared.call(.updateTransaction(Shared.transaction!.orderId, payload, "6")) { data in
            print("check3DSEnrollment ",JSON(data))
            if let data = data,
               let json = try? JSON(data: data),
               json["response"]["gatewayRecommendation"].string == "PROCEED"{
                self.delegate?.didCompleteCheck3DSEnrollment(true, json["authentication"]["redirect"]["customized"]["3DS"]["methodUrl"].stringValue)
            }else{
                self.delegate?.didCompleteCheck3DSEnrollment(false, nil)
            }
        }
        
    }
    
    func authPayer(_ redirectURL: String){
        
        var payload = GatewayMap(["apiOperation": ApiOperations.authenticatePayer.rawValue])
        
        payload[at: "order.amount"] = Shared.transaction?.amount
        payload[at: "order.currency"] = Shared.transaction?.currency
        payload[at: "session.id"] = Shared.transaction?.session
      //  payload[at: "3DSecure.authenticationRedirect.responseUrl"] = redirectURL
        payload[at: "authentication.redirectResponseUrl"] = redirectURL
        payload[at: "customer.firstName"] = "sherif"
        payload[at: "customer.email"] = "sherifdarwish900@gmail.com"
        payload[at: "customer.lastName"] = "darwish"
        payload[at: "device.browserDetails.javaEnabled"] = "true"
        payload[at: "device.browserDetails.language"] = "json"
        payload[at: "device.browserDetails.screenHeight"] = "200"
        payload[at: "device.browserDetails.screenWidth"] = "200"
        payload[at: "device.browserDetails.timeZone"] = "+200"
        payload[at: "device.browserDetails.colorDepth"] = "20"
        payload[at: "device.browserDetails.acceptHeaders"] = "512"
        payload[at: "device.browserDetails.3DSecureChallengeWindowSize"] = "FULL_SCREEN"
        payload[at: "device.browser"] = "Chrome"
        payload[at: "device.ipAddress"] = "192.0.1.1"
        
        APIServices.shared.call(.updateTransaction(Shared.transaction!.orderId, payload, "6")) { data in
            print("authPayer ",JSON(data))
            if let data = data,
               let json = try? JSON(data: data){
                if let authToken = json["authentication"]["3ds"]["authenticationToken"].string,
                   let transactionId = json["authentication"]["3ds"]["transactionId"].string,
                   let enrolled = json["authentication"]["3ds1"]["veResEnrolled"].string{
                    self.delegate?.didCompleteVerifyPayerWith(authToken, transactionId, enrolled)
                }else if let redirectHtml = json["authentication"]["redirectHtml"].string{
                    self.delegate?.didCompleteAuthPayerWith(redirectHtml, redirectURL)
                }
            }else{
                self.delegate?.didCompleteAuthPayerWith(nil, nil)
            }
        }
        
    }
    
    func performPay(_ authToken: String,_ transactionId: String,_ veResEnrolled: String){
        
        var payload = GatewayMap(["apiOperation": ApiOperations.pay.rawValue])
        payload[at: "session.id"] = Shared.transaction?.session
        payload[at: "order.amount"] = Shared.transaction?.amount
        payload[at: "order.currency"] = Shared.transaction?.currency
        payload[at: "sourceOfFunds.type"] = "CARD"
        payload[at: "authentication.3ds.acsEci"] = "05"
        payload[at: "authentication.3ds.authenticationToken"] = authToken
        payload[at: "authentication.3ds.transactionId"] = transactionId
        payload[at: "authentication.3ds1.veResEnrolled"] = veResEnrolled
        payload[at: "authentication.3ds1.paResStatus"] = "Y"
        
        APIServices.shared.call(.updateTransaction(Shared.transaction!.orderId, payload, "7")) { data in
            print("performPay", JSON(data))
            if let data = data,
               let json = try? JSON(data: data),
               json["result"].string == "SUCCESS"{
                self.delegate?.didCompletePerformPay(true, json["authentication"]["3ds"]["transactionId"].stringValue)
            }else{
                self.delegate?.didCompletePerformPay(false, nil)
            }
        }
    }
    
}
