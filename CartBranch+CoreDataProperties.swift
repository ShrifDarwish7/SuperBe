//
//  CartBranch+CoreDataProperties.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 11/05/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//
//

import Foundation
import CoreData


extension CartBranch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartBranch> {
        return NSFetchRequest<CartBranch>(entityName: "CartBranch")
    }

    @NSManaged public var id: Int16
    @NSManaged public var logo: String?
    @NSManaged public var name_ar: String?
    @NSManaged public var name_en: String?
    @NSManaged public var selected: Bool
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension CartBranch {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: CartItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: CartItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}
