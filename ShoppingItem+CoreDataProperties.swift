//
//  ShoppingItem+CoreDataProperties.swift
//  pantrixx
//
//  Created by MacBook Pro on 05/12/24.
//
//

import Foundation
import CoreData


extension ShoppingItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShoppingItem> {
        return NSFetchRequest<ShoppingItem>(entityName: "ShoppingItem")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var quantity: String?
    @NSManaged public var purchased: Bool

}

extension ShoppingItem : Identifiable {

}
