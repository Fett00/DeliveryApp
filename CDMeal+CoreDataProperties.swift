//
//  CDMeal+CoreDataProperties.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 07.02.2022.
//
//

import Foundation
import CoreData


extension CDMeal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDMeal> {
        return NSFetchRequest<CDMeal>(entityName: "CDMeal")
    }

    @NSManaged public var categoryName: String?
    @NSManaged public var mealID: Int32
    @NSManaged public var mealImageURL: String?
    @NSManaged public var mealName: String?

}

extension CDMeal : Identifiable {

}
