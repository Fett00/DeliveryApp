//
//  ItemModel.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 05.12.2021.
//

import Foundation

struct CategoryModel: Decodable{
    
    let idCategory: String
    let strCategory: String
    
    let meals: [MealModel]
}
