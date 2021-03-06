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
    
    func addToCart(_ item: Product, completed: @escaping (Bool)->Void){
        
        self.getCartBranches(id: item.branch?.id) { (branches) in
            if let _ = branches{
                if branches!.isEmpty{
                    
                    self.addCartItemWith(item, nil)
                    completed(true)
                    
                }else{
                    
                    let cartItem = CartItem(context: CartServices.managedObjectContext)
                    self.getCartBranches(id: nil) { branches in
                        guard let branches = branches else {
                            return
                        }
                        for i in 0...branches.count-1{
                            branches[i].selected = false
                        }
                    }
                    branches![0].selected = true
                    
                    if let _ = item.photos{
                        
                        cartItem.photos = try! JSONEncoder.init().encode(item.photos!.map({ $0.jpegData(compressionQuality: 0.5)! }))
                        cartItem.cart_id = UUID().uuidString
                        cartItem.branch = branches?.first
                        cartItem.is_media = true
                        
                        do {
                            try CartServices.managedObjectContext.save()
                            print("add to cart success")
                            completed(true)
                        }catch let error{
                            completed(false)
                            print("context error",error)
                        }
                        
                    }else if let _ = item.voice{
                        
                        cartItem.voice = item.voice
                        cartItem.cart_id = UUID().uuidString
                        cartItem.branch = branches?.first
                        cartItem.is_media = true
                        
                        do {
                            try CartServices.managedObjectContext.save()
                            print("add to cart success")
                            completed(true)
                        }catch let error{
                            completed(false)
                            print("context error",error)
                        }
                        
                    }else if let _ = item.text{
                        
                        cartItem.text = item.text
                        cartItem.cart_id = UUID().uuidString
                        cartItem.branch = branches?.first
                        cartItem.is_media = true
                        
                        do {
                            try CartServices.managedObjectContext.save()
                            print("add to cart success")
                            completed(true)
                        }catch let error{
                            completed(false)
                            print("context error",error)
                        }
                        
                    }else{
                        
                        var cartId = "\(item.id!)"
                        item.variations?.forEach({ (variation) in
                            cartId += variation.options!.map({String($0.id!)}).joined()
                        })
                        print("cartId",cartId)
                        self.getCartItems(itemId: cartId, branch: -1) { (items) in
                            if let items = items{
                                if items.isEmpty{
                                    cartItem.product_id = "\(item.id!)"
                                    cartItem.name_en = item.name?.en
                                    cartItem.name_ar = item.name?.ar
                                    cartItem.logo = item.logo
                                    cartItem.notes = item.notes
                                    cartItem.price = Double(item.price!).roundToDecimal(2)
                                    cartItem.quantity = Int16(item.quantity)
                                    cartItem.cart_id = cartId
                                    cartItem.desc = item.desc
                                    cartItem.min_qty = Int16(item.minQty ?? 0)
                                    cartItem.max_qty = Int16(item.maxQty ?? 0)
                                    if let variations = item.variations{
                                        let data = try! JSONEncoder.init().encode(variations)
                                        cartItem.variations = data
                                    }
                                    cartItem.branch = branches?.first
                                    
                                    do {
                                        try CartServices.managedObjectContext.save()
                                        print("add to cart success")
                                        completed(true)
                                    }catch let error{
                                        completed(false)
                                        print("context error",error)
                                    }
                                }else{
                                    self.updateQuantity(newValue: Int(items.first!.quantity) + item.quantity, id: (items.first?.cart_id)!, nil)
                                    completed(true)
                                }
                            }
                        }
                    }
                                        
                    
                }
            }else{
                completed(false)
            }
        }

        
    }
    
    func addCartItemWith(_ item: Product,_ completed: ((Bool)->Void)?){
        let cartItem = CartItem(context: CartServices.managedObjectContext)
        if let _ = item.photos{
            
            //let cartItem = CartItem(context: CartServices.managedObjectContext)
            cartItem.photos = try! JSONEncoder.init().encode(item.photos!.map({ $0.jpegData(compressionQuality: 0.5)! }))
            cartItem.cart_id = UUID().uuidString
            cartItem.is_media = true
            
        }else if let _ = item.voice{
            
            cartItem.voice = item.voice
            cartItem.cart_id = UUID().uuidString
            cartItem.is_media = true
            
        }else if let _ = item.text{
            
            cartItem.text = item.text
            cartItem.cart_id = UUID().uuidString
            cartItem.is_media = true
            
        }else{
            cartItem.product_id = "\(item.id!)"
            cartItem.name_en = item.name?.en
            cartItem.name_ar = item.name?.ar
            cartItem.logo = item.logo
            cartItem.notes = item.notes
            cartItem.price = Double(item.price!).roundToDecimal(2)
            cartItem.quantity = Int16(item.quantity)
            cartItem.desc = item.desc
            cartItem.min_qty = Int16(item.minQty ?? 0)
            cartItem.max_qty = Int16(item.maxQty ?? 0)
            var cartId = "\(item.id!)"
            item.variations?.forEach({ (variation) in
                cartId += variation.options!.map({String($0.id!)}).joined()
            })
            cartItem.cart_id = cartId
            
            if let variations = item.variations{
                let data = try! JSONEncoder.init().encode(variations)
                cartItem.variations = data
            }
        }
        self.getCartBranches(id: nil) { branches in
            guard let branches = branches, !branches.isEmpty else {
                return
            }
            for i in 0...branches.count-1{
                branches[i].selected = false
            }
        }
        let cartBranch = CartBranch(context: CartServices.managedObjectContext)
        cartBranch.id = Int32(item.branch!.id)
        cartBranch.logo = item.branch?.logo
        cartBranch.name_en = item.branch?.name?.en
        cartBranch.name_ar = item.branch?.name?.ar
        cartBranch.selected = true
        cartBranch.taxes = item.branch?.taxes ?? 0.0
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
    
    func getCartItems(itemId: String, branch: Int, completedWith items: @escaping ([CartItem]?)->Void){
        let fetchRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        if branch != -1{
            fetchRequest.predicate = itemId != "-1" ? NSPredicate(format: "ANY branch.id == %i && cart_id == %@", branch, itemId) : NSPredicate(format: "ANY branch.id == %i", branch)
        }
        if itemId != "-1"{
            fetchRequest.predicate = branch != -1 ? NSPredicate(format: "ANY branch.id == %i && cart_id == %@", branch, itemId) : NSPredicate(format: "cart_id == %@", itemId)
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
        fetchRequest.predicate = NSPredicate(format: "cart_id == %@", item.cart_id!)
        let temp = item.branch?.id
        do{
            let fetchResult = try CartServices.managedObjectContext.fetch(fetchRequest)
            print(fetchResult)
            CartServices.managedObjectContext.delete(fetchResult.first!)
            CartServices.shared.getCartItems(itemId: "-1", branch: Int(temp!)) { (items) in
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
    
    func removeBranchWithItems(_ id: Int,_ removed: ((Bool)->Void)?){
        let branchFetchRequest = NSFetchRequest<NSManagedObject>(entityName: Entity.cartBranch.rawValue)
        branchFetchRequest.predicate = NSPredicate(format: "id == %i", id)
        let itemFetchRequest = NSFetchRequest<NSManagedObject>(entityName: Entity.cartItem.rawValue)
        itemFetchRequest.predicate = NSPredicate(format: "ANY branch.id = %i", id)
        do{
            let branchFetchResult = try CartServices.managedObjectContext.fetch(branchFetchRequest)
            let itemsFetchResult = try CartServices.managedObjectContext.fetch(itemFetchRequest)
            for i in 0...branchFetchResult.count-1{
                CartServices.managedObjectContext.delete(branchFetchResult[i])
            }
            for i in 0...itemsFetchResult.count-1{
                CartServices.managedObjectContext.delete(itemsFetchResult[i])
            }
            try CartServices.managedObjectContext.save()
            removed?(true)
        }catch{
            removed?(false)
        }
    }
    
    func updateQuantity(newValue: Int, id: String,_ completed: ((Bool)->Void)?){
        let fetchRequest: NSFetchRequest<CartItem> = CartItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "cart_id == %@", id)
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
