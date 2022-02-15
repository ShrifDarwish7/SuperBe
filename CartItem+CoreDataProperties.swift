//
//  CartItem+CoreDataProperties.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 14/02/2022.
//  Copyright © 2022 Super Bekala. All rights reserved.
//
//

import Foundation
import CoreData


extension CartItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartItem> {
        return NSFetchRequest<CartItem>(entityName: "CartItem")
    }

    @NSManaged public var cart_id: String?
    @NSManaged public var desc: String?
    @NSManaged public var is_media: Bool
    @NSManaged public var logo: String?
    @NSManaged public var max_qty: Int16
    @NSManaged public var min_qty: Int16
    @NSManaged public var name_ar: String?
    @NSManaged public var name_en: String?
    @NSManaged public var notes: String?
    @NSManaged public var photos: Data?
    @NSManaged public var price: Double
    @NSManaged public var product_id: String?
    @NSManaged public var quantity: Int16
    @NSManaged public var text: String?
    @NSManaged public var variations: Data?
    @NSManaged public var voice: Data?
    @NSManaged public var branch: CartBranch?

}

extension CartItem : Identifiable {

}
