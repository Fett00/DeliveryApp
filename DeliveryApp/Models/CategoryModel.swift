//
//  ItemModel.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 05.12.2021.
//

import Foundation

//Модель всех категорий
struct CategoriesModel: Decodable{
    
    let categories: [CategoryModel]
}

//Модель одной категории
struct CategoryModel: Decodable{
    
    let idCategory: String
    let strCategory: String
    
    //var meals: [MealModel] = []
}


