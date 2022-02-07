//
//  CDCategory+CoreDataProperties.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 07.02.2022.
//
//

import Foundation
import CoreData


extension CDCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCategory> {
        return NSFetchRequest<CDCategory>(entityName: "CDCategory")
    }

    @NSManaged public var categoryID: Int32
    @NSManaged public var categoryName: String?

}

extension CDCategory : Identifiable {

}
