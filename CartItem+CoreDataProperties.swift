//
//  CartItem+CoreDataProperties.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 19/04/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//
//

import Foundation
import CoreData


extension CartItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartItem> {
        return NSFetchRequest<CartItem>(entityName: "CartItem")
    }

    @NSManaged public var cart_id: Int64
    @NSManaged public var desc: String?
    @NSManaged public var logo: String?
    @NSManaged public var name_ar: String?
    @NSManaged public var name_en: String?
    @NSManaged public var notes: String?
    @NSManaged public var price: Double
    @NSManaged public var product_id: Int16
    @NSManaged public var quantity: Int16
    @NSManaged public var variations: Data?
    @NSManaged public var branch: CartBranch?

}

extension CartItem : Identifiable {

}
