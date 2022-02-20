//
//  CDCartContent+CoreDataProperties.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 15.02.2022.
//
//

import Foundation
import CoreData


extension CDCartContent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCartContent> {
        return NSFetchRequest<CDCartContent>(entityName: "CDCartContent")
    }

    @NSManaged public var name: String?
    @NSManaged public var price: Int32
    @NSManaged public var count: Int32
    @NSManaged public var imageURL: String?
    @NSManaged public var mealID: Int32

}

extension CDCartContent : Identifiable {

}
