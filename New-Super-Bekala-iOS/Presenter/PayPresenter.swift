//
//  PayPresenter.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 06/06/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
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
        
        let payload = TransactionPayload(
            apiOperation: nil,
            order: TransactionOrder(id: nil,
                                    amount: String((Shared.transaction?.amount)!),
                                    currency: Shared.transaction?.currency),
            session: nil,
            authentication: nil,
            customer: nil,
            device: nil, sourceOfFunds: nil)
        
        APIServices.shared.call(.updateSession((Shared.transaction?.session!)!, try! JSONEncoder.init().encode(payload))) { data in
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
        
        let payload = CardPayload(
            sourceOfFunds:
                SourceOfFunds(
                    provided: Provided(
                        card: Card(
                            expiry: Expiry(
                                month: (Shared.transaction?.expiryMM)!,
                                year: (Shared.transaction?.expiryYY)!),
                            number: (Shared.transaction?.cardNumber)!,
                            securityCode: String((Shared.transaction?.cvv)!),
                            storedOnFile: "TO_BE_STORED",
                            nameOnCard: (Shared.transaction?.nameOnCard)!)),
                    type: "CARD"))
        
        APIServices.shared.call(.updateSession((Shared.transaction?.session!)!, try! JSONEncoder.init().encode(payload))) { data in
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
        
        let payload = TransactionPayload(
            apiOperation: ApiOperations.initiateAuthentication.rawValue,
            order: TransactionOrder(id: nil, amount: nil, currency: Shared.transaction?.currency),
            session: Session(id: (Shared.transaction?.session)!),
            authentication: Authentication(
                redirectResponseURL: nil,
                acceptVersions: "3DS1,3DS2",
                channel: "PAYER_BROWSER",
                purpose: "PAYMENT_TRANSACTION",
                the3Ds: nil,
                the3Ds1: nil),
            customer: nil,
            device: nil, sourceOfFunds: nil)
        
        APIServices.shared.call(.updateTransaction(Shared.transaction!.orderId,  try! JSONEncoder.init().encode(payload), "6")) { data in
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
        
        let payload = TransactionPayload(
            apiOperation: ApiOperations.authenticatePayer.rawValue,
            order: TransactionOrder(
                id: nil,
                amount: String((Shared.transaction?.amount)!),
                currency: String((Shared.transaction?.currency)!)),
            session: Session(id: (Shared.transaction?.session)!),
            authentication: Authentication(
                redirectResponseURL: redirectURL,
                acceptVersions: nil,
                channel: nil,
                purpose: nil,
                the3Ds: nil,
                the3Ds1: nil),
            customer: Customer(
                firstName: "name",
                email: "info@sb.com",
                lastName: "_"),
            device: Device(
                browserDetails: BrowserDetails(
                    javaEnabled: "true",
                    language: "json",
                    screenHeight: "200",
                    screenWidth: "200",
                    timeZone: "+200",
                    colorDepth: "20",
                    acceptHeaders: "512",
                    the3DSecureChallengeWindowSize: "FULL_SCREEN"),
                browser: "Chrome",
                ipAddress: "192.0.1.1"), sourceOfFunds: nil)
        
        APIServices.shared.call(.updateTransaction(Shared.transaction!.orderId,  try! JSONEncoder.init().encode(payload), "6")) { data in
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
        
        let payload = TransactionPayload(
            apiOperation: ApiOperations.pay.rawValue,
            order: TransactionOrder(
                id: nil,
                amount: String((Shared.transaction?.amount)!),
                currency: String((Shared.transaction?.currency)!)),
            session: Session(id: (Shared.transaction?.session!)!),
            authentication: Authentication(
                redirectResponseURL: nil,
                acceptVersions: nil,
                channel: nil,
                purpose: nil,
                the3Ds: The3Ds(
                    acsEci: "05",
                    authenticationToken: authToken,
                    transactionID: transactionId),
                the3Ds1: The3Ds1(
                    paResStatus: "Y",
                    veResEnrolled: veResEnrolled)),
            customer: nil,
            device: nil,
            sourceOfFunds: SourceOfFunds(provided: nil, type: "CARD"))
        
        APIServices.shared.call(.updateTransaction(Shared.transaction!.orderId,  try! JSONEncoder.init().encode(payload), "7")) { data in
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
