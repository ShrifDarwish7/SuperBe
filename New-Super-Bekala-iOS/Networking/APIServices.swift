//
//  APIServices.swift
//  DFVendors
//
//  Created by Sherif Darwish on 29/12/2020.
//

import Foundation
import Moya
import Firebase

extension Data {
    func getDecodedObject<T>(from object : T.Type)->T? where T : Decodable {
        do {
            return try JSONDecoder().decode(object, from: self)
        } catch let error {
            print("Error Decoding Object ", error)
            return nil
        }
    }
}

class APIServices{
    
    static let shared = APIServices()
    let googleProvider = MoyaProvider<Google>()
    let superbeProvider = MoyaProvider<SuperBe>()
    let nbeProvider = MoyaProvider<NBE>()
    var user: LoginResult?{
        set{
            UserDefaults.init().setValue(try! JSONEncoder.init().encode(newValue), forKey: "user")
        }
        get{
            let data = UserDefaults.init().data(forKey: "user")
            return (data?.getDecodedObject(from: LoginResult.self)) ?? nil
        }
    }
    var isLogged: Bool{
        set{
            UserDefaults.init().setValue(newValue, forKey: "isLogged")
        }
        get{
            return UserDefaults.init().bool(forKey: "isLogged")
        }
    }
    
    func call(_ target: Google , _ completed: @escaping (Data?)->Void){
        self.googleProvider.request(target) {
            [weak self] result in
            guard self != nil else { return }
            switch result{
            case .success(let response):
                completed(response.data)
            case .failure(let err):
                print(err)
                completed(nil)
            }
        }
    }
    
    func call(_ target: SuperBe , _ completed: @escaping (Data?)->Void){
        self.superbeProvider.request(target) {
            [weak self] result in
            guard self != nil else { return }
            switch result{
            case .success(let response):
                completed(response.data)
            case .failure(let err):
                print(err)
                completed(nil)
            }
        }
    }
    
    func call(_ target: NBE , _ completed: @escaping (Data?)->Void){
        self.nbeProvider.request(target) {
            [weak self] result in
            guard self != nil else { return }
            switch result{
            case .success(let response):
                completed(response.data)
            case .failure(let err):
                print(err)
                completed(nil)
            }
        }
    }
    
    func signinWith(credential: AuthCredential, _ completed: @escaping (_ uid: String?)->Void){
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error != nil {
                print("err auth",error)
                completed(nil)
                return
            }
            print(authResult?.user.uid)
            completed(authResult?.user.uid)
            
//            authResult?.user.getIDToken(completion: { (token, error) in
//
//                if let token = token {
//
//                    print("Token",token)
//                    completed(token)
//
//                }else{
//                    print("token fail")
//                    completed(nil)
//                }
//
//            })
        }
    }
    
}
