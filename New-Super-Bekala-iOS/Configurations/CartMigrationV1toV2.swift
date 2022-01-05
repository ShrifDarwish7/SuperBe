//
//  CartMigrationV1toV2.swift
//  New-Super-Bekala-iOS
//
//  Created by Sherif Darwish on 13/12/2021.
//  Copyright © 2021 Super Bekala. All rights reserved.
//

import Foundation
import CoreData

class CartMigrationV1toV2: NSEntityMigrationPolicy{
    override func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        try super.createDestinationInstances(forSource: sInstance, in: mapping, manager: manager)

    }
    @objc func productIdFromInt16to32(id: Int16) -> Int32 {
         return Int32(id)
     }
    @objc func productIdFromInt16toString(product_id: Int16) -> String {
         return String(product_id)
     }
}
