//
//  CartBranch+CoreDataProperties.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 14/02/2022.
//  Copyright © 2022 Super Bekala. All rights reserved.
//
//

import Foundation
import CoreData


extension CartBranch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartBranch> {
        return NSFetchRequest<CartBranch>(entityName: "CartBranch")
    }

    @NSManaged public var id: Int32
    @NSManaged public var logo: String?
    @NSManaged public var name_ar: String?
    @NSManaged public var name_en: String?
    @NSManaged public var selected: Bool
    @NSManaged public var taxes: Double
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

extension CartBranch : Identifiable {

}
