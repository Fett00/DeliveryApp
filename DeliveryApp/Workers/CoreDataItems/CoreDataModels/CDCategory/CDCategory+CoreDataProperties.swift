//
//  CDCategory+CoreDataProperties.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 28.01.2022.
//
//

import Foundation
import CoreData


extension CDCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCategory> {
        return NSFetchRequest<CDCategory>(entityName: "CDCategory")
    }

    @NSManaged public var categoryID: String?
    @NSManaged public var categoryName: String?

}

extension CDCategory : Identifiable {

}
