//
//  CDMeal+CoreDataProperties.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 28.01.2022.
//
//

import Foundation
import CoreData


extension CDMeal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDMeal> {
        return NSFetchRequest<CDMeal>(entityName: "CDMeal")
    }

    @NSManaged public var mealID: Int32
    @NSManaged public var mealImageURL: URL?
    @NSManaged public var mealName: String?
    @NSManaged public var category: CDCategory?

}

extension CDMeal : Identifiable {

}
