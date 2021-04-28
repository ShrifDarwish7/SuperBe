//
//  CartServices.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 03/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import CoreData
import UIKit

enum Entity: String{
    case cartItem = "CartItem"
    case cartBranch = "CartBranch"
}

class CartServices{
    
    static let shared = CartServices()
    static let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func addToCart(_ branch: Branch, _ item: Product, completed: @escaping (Bool)->Void, exist: @escaping (Bool)->Void){
        
        self.getCartBranches(id: branch.id) { (branches) in
            if let branches = branches{
                if branches.isEmpty{
                    self.addCartItemWith(branch, item, nil)
                    completed(true)
                }else{
                    let cartItem = CartItem(context: CartServices.managedObjectContext)
                    if let _ = item.photos{
                        
                        cartItem.photos = try! JSONEncoder.init().encode(item.photos!.map({ $0.jpegData(compressionQuality: 0.5)! }))
                        
                    }else if let _ = item.voice{
                        
                        cartItem.voice = item.voice
                        
                    }else{
                        
                        var cartId = "\(item.id!)"
                        item.variations?.forEach({ (variation) in
                            cartId += variation.options!.map({String($0.id!)}).joined()
                        })
                        print("cartId",cartId)
                        self.getCartItems(itemId: Int(cartId)!, branch: -1/*Int(branches.first!.id)*/) { (items) in
                            if let items = items{
                                if items.isEmpty{
                                    cartItem.product_id = Int16(Int(item.id!))
                                    cartItem.name_en = item.branchProductLanguage?.first?.name
                                    cartItem.name_ar = item.branchProductLanguage?[0].name
                                    cartItem.logo = item.images?.first
                                    cartItem.notes = item.notes
                                    cartItem.price = Double(item.price!)
                                    cartItem.quantity = Int16(item.quantity)
                                    cartItem.cart_id = Int64(cartId)!
                                    cartItem.desc = item.desc
                                    if let variations = item.variations{
                                        let data = try! JSONEncoder.init().encode(variations)
                                        cartItem.variations = data
                                    }
                                }else{
                                    exist(true)
                                }
                            }
                        }
                    }
                    
                    cartItem.branch = branches.first
                    
                    do {
                        try CartServices.managedObjectContext.save()
                        print("add to cart success")
                        completed(true)
                    }catch let error{
                        completed(false)
                        print("context error",error)
                    }
                }
            }else{
                completed(false)
            }
        }

        
    }
    
    func addCartItemWith(_ branch: Branch, _ item: Product,_ completed: ((Bool)->Void)?){
        let cartItem = CartItem(context: CartServices.managedObjectContext)
        if let _ = item.photos{
            let cartItem = CartItem(context: CartServices.managedObjectContext)
            cartItem.photos = try! JSONEncoder.init().encode(item.photos!.map({ $0.jpegData(compressionQuality: 0.5)! }))
        }else{
            cartItem.product_id = Int16(item.id!)
            cartItem.name_en = item.branchProductLanguage?.first?.name
            cartItem.name_ar = item.branchProductLanguage?[0].name
            cartItem.logo = item.images?.first
            cartItem.notes = item.notes
            cartItem.price = Double(item.price!)
            cartItem.quantity = Int16(item.quantity)
            cartItem.desc = item.desc
            var cartId = "\(item.id!)"
            item.variations?.forEach({ (variation) in
                cartId += variation.options!.map({String($0.id!)}).joined()
            })
            print("cartId",cartId)
            cartItem.cart_id = Int64(cartId)!
            
            if let variations = item.variations{
                let data = try! JSONEncoder.init().encode(variations)
                cartItem.variations = data
            }
        }
        let cartBranch = CartBranch(context: CartServices.managedObjectContext)
        cartBranch.id = Int16(branch.id)
        cartBranch.logo = branch.logo
        cartBranch.name_en = branch.branchLanguage?.first?.name
        cartBranch.name_ar = branch.branchLanguage![0].name
        cartItem.branch = cartBranch
        
        do{
            try CartServices.managedObjectContext.save()
            print("cart item added")
            completed?(true)
        }catch let error{
            completed?(false)
            print("contextSave",error)
        }
    }
    func getCartItems(itemId: Int, branch: Int, completedWith items: @escaping ([CartItem]?)->Void){
        let fetchRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        if branch != -1{
            fetchRequest.predicate = itemId != -1 ? NSPredicate(format: "ANY branch.id == %i && cart_id == %i", branch, itemId) : NSPredicate(format: "ANY branch.id == %i", branch)
        }
        if itemId != -1{
            fetchRequest.predicate = branch != -1 ? NSPredicate(format: "ANY branch.id == %i && cart_id == %i", branch, itemId) : NSPredicate(format: "cart_id == %i", itemId)
        }
        do {
            let cartItems = try CartServices.managedObjectContext.fetch(fetchRequest)
            print("getCartItems", cartItems)
            items(cartItems)
        } catch let error as NSError {
            items(nil)
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func getCartBranches(id: Int?, completedWith branches: @escaping ([CartBranch]?)->Void){
        let fetchRequest: NSFetchRequest<CartBranch> = CartBranch.fetchRequest()
        if let id = id{
            let predicate = NSPredicate(format: "id == %i", id)
            fetchRequest.predicate = predicate
        }
        do {
            let cartBranches = try CartServices.managedObjectContext.fetch(fetchRequest)
            branches(cartBranches)
        } catch let error as NSError {
            branches(nil)
            print("Could not fetch. \(error), \(error.userInfo)")
        }

    }
    
    func removeItemAt(_ item: CartItem,_ removed: ((Bool)->Void)?){
        let fetchRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "cart_id == %i", item.cart_id)
        let temp = item.branch?.id
        do{
            let fetchResult = try CartServices.managedObjectContext.fetch(fetchRequest)
            print(fetchResult)
            CartServices.managedObjectContext.delete(fetchResult.first!)
            CartServices.shared.getCartItems(itemId: -1, branch: Int(temp!)) { (items) in
                if let items = items,
                   items.isEmpty{
                    CartServices.shared.removeBranchAt(Int(temp!), nil)
                }
            }
            try CartServices.managedObjectContext.save()
            removed?(true)
        }catch{
            removed?(false)
        }
    }
    
    func removeBranchAt(_ id: Int,_ removed: ((Bool)->Void)?){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Entity.cartBranch.rawValue)
        fetchRequest.predicate = NSPredicate(format: "id == %i", id)
        do{
            let fetchResult = try CartServices.managedObjectContext.fetch(fetchRequest)
            CartServices.managedObjectContext.delete(fetchResult.first!)
            try CartServices.managedObjectContext.save()
            removed?(true)
        }catch{
            removed?(false)
        }
    }
    
    func updateQuantity(newValue: Int, id: Int,_ completed: ((Bool)->Void)?){
        let fetchRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "cart_id == %i", id)
        do{
            let fetchResult = try CartServices.managedObjectContext.fetch(fetchRequest)
          //  fetchResult.first!.setValue(newValue, forKey: "quantity")
            fetchResult.first?.quantity = Int16(newValue)
           // fetchResult.first?.setValue(fetchResult.first["price"], forKey: "price")
            try CartServices.managedObjectContext.save()
            completed?(true)
        }catch let error{
            print("errorQ",error)
            completed?(false)
        }
    }
}
