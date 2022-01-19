//
//  CartContent+CoreDataProperties.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 19.01.2022.
//
//

import Foundation
import CoreData


extension CartContent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartContent> {
        return NSFetchRequest<CartContent>(entityName: "CartContent")
    }

    @NSManaged public var data: Data?
    @NSManaged public var name: String?

}

extension CartContent : Identifiable {

}
