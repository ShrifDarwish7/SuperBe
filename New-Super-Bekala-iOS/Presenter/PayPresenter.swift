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
    func didCompleteCheck3DSEnrollment(_ proceed: Bool)
    func didCompleteAuthPayerWith(_ redirectHtml: String?)
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
    
    func updateSessionWithOrder(transaction: Transaction){
        
        var payload = GatewayMap()
        payload[at: "order.currency"] = "EGP"
        payload[at: "order.amount"] = transaction.amount
        payload[at: "order.id"] = transaction.orderId
        
        APIServices.shared.call(.updateSession(transaction.session!, payload)) { data in
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
    
    func updateSessionWithPayerData(transaction: Transaction){
        
        var payload = GatewayMap()
        payload[at: "sourceOfFunds.provided.card.nameOnCard"] = transaction.nameOnCard
        payload[at: "sourceOfFunds.provided.card.number"] = transaction.cardNumber
        payload[at: "sourceOfFunds.provided.card.securityCode"] = transaction.cvv
        payload[at: "sourceOfFunds.provided.card.expiry.month"] = transaction.expiryMM
        payload[at: "sourceOfFunds.provided.card.expiry.year"] = transaction.expiryYY
        payload[at: "sourceOfFunds.type"] = "CARD"
        
        APIServices.shared.call(.updateSession(transaction.session!, payload)) { data in
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
    
    func check3DSEnrollment(transaction: Transaction){
        
        var payload = GatewayMap(["apiOperation": ApiOperations.initiateAuthentication.rawValue])
        
       // payload[at: "order.amount"] = "1.0"
        payload[at: "order.currency"] = "EGP"
        payload[at: "session.id"] = transaction.session
      //  payload[at: "3DSecure.authenticationRedirect.responseUrl"] = redirectURL
        
        payload[at: "authentication.acceptVersions"] = "3DS1,3DS2"
        payload[at: "authentication.channel"] = "PAYER_BROWSER"
        payload[at: "authentication.purpose"] = "PAYMENT_TRANSACTION"
        
        APIServices.shared.call(.updateTransaction(transaction.orderId, payload)) { data in
            print("check3DSEnrollment ",JSON(data))
            if let data = data,
               let json = try? JSON(data: data),
               json["response"]["gatewayRecommendation"].string == "PROCEED"{
                self.delegate?.didCompleteCheck3DSEnrollment(true)
            }else{
                self.delegate?.didCompleteCheck3DSEnrollment(false)
            }
        }
        
    }
    
    func authPayer(transaction: Transaction){
        
        var payload = GatewayMap(["apiOperation": ApiOperations.authenticatePayer.rawValue])
        
        payload[at: "order.amount"] = transaction.amount
        payload[at: "order.currency"] = transaction.currency
        payload[at: "session.id"] = transaction.session
      //  payload[at: "3DSecure.authenticationRedirect.responseUrl"] = redirectURL
        payload[at: "authentication.redirectResponseUrl"] = "https://eu.gateway.mastercard.com"
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
        
        APIServices.shared.call(.updateTransaction(transaction.orderId, payload)) { data in
            print("authPayer ",JSON(data))
            if let data = data,
               let json = try? JSON(data: data),
               let redirectHtml = json["authentication"]["redirectHtml"].string{
                self.delegate?.didCompleteAuthPayerWith(redirectHtml)
            }else{
                self.delegate?.didCompleteAuthPayerWith(nil)
            }
        }
        
    }
    
}
