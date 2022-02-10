//
//  ItemModel.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 05.12.2021.
//

import Foundation

//Модель всех категорий
struct CategoriesModel: Decodable{
    
    var categories: [CategoryModel]
}

//Модель одной категории
struct CategoryModel: Decodable{
    
    let idCategory: String
    let strCategory: String
    
    var meals: [MealModel]? //Почему не работает var meals: [MealModel] = []
}

extension CategoryModel: Comparable{
    
    static func < (lhs: CategoryModel, rhs: CategoryModel) -> Bool {
        
        lhs.idCategory < rhs.idCategory || lhs.strCategory < rhs.strCategory
    }
    
    static func == (lhs: CategoryModel, rhs: CategoryModel) -> Bool {
        
        lhs.idCategory == rhs.idCategory && lhs.strCategory == rhs.strCategory
    }
}


