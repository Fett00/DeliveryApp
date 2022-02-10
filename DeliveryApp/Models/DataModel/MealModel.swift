//
//  ItemModel.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 05.12.2021.
//

import Foundation


struct MealsModel: Decodable{
    
    let meals: [MealModel]
}

//Модель блюда
struct MealModel: Codable{
    
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
}

extension MealModel: Comparable{
    
    static func < (lhs: MealModel, rhs: MealModel) -> Bool {
        
        lhs.idMeal < rhs.idMeal || lhs.strMealThumb < rhs.strMealThumb || lhs.strMeal < rhs.strMeal
    }
    
    static func == (lhs: MealModel, rhs: MealModel) -> Bool {
        
        lhs.idMeal == rhs.idMeal && lhs.strMealThumb == rhs.strMealThumb && lhs.strMeal == rhs.strMeal
    }
}
