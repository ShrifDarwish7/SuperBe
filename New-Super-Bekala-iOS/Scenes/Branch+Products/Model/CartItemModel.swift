//
//  CartItemModel.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 04/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import CoreData

//class CartItemModel{
//
//    var id: Int?
//    var nameEn: String?
//    var nameAr: String?
//    var notes: String?
//    var price: Double?
//    var quantity: Int?
//    var branchId: CartBranch?
//    var logo: String?
//    
//    init(id: Int?, nameEn: String?, nameAr: String?, notes: String?, price: Double?, quantity: Int?, branchId: CartBranch?, logo: String?) {
//        self.id = id
//        self.nameEn = nameEn
//        self.nameAr = nameAr
//        self.notes = notes
//        self.price = price
//        self.quantity = quantity
//        self.branchId = branchId
//        self.logo = logo
//    }
//
//    init(data : NSManagedObject) {
//        self.id = (data.value(forKey: "id") as! Int)
//        self.nameAr = (data.value(forKey: "name_ar") as! String)
//        self.nameEn = (data.value(forKey: "name_en") as! String)
//        self.notes = (data.value(forKey: "notes") as! String)
//        self.price = (data.value(forKey: "price") as! Double)
//        self.quantity = (data.value(forKey: "quantity") as! Int)
//        self.branchId = ((data.value(forKey: "branch_id")!) as! CartBranch)
//        self.logo = (data.value(forKey: "logo") as! String)
//    }
//
//}
