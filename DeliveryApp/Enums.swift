//
//  Enums.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 06.12.2021.
//

import UIKit

enum Images{
    
    static let emptyMeal = UIImage(named: "food-delivery")!
    static let avatar = UIImage(named: "AvatarImage")!
    static let cart = UIImage(systemName: "cart")!
    static let menu = UIImage(systemName: "bag")!
    static let profile = UIImage(systemName: "person")!
    static let backArrow = UIImage(systemName: "arrow.backward")!
    static let downArrow = UIImage(systemName: "arrow.down")!
    static let trash = UIImage(systemName: "trash")!
}

enum URLs{
    
    //АПИ для получения категорий
    static let categoriesURL = "https://www.themealdb.com/api/json/v1/1/categories.php"
    
    //АПИ для получения блюд для категории
    static let mealsURL = "https://www.themealdb.com/api/json/v1/1/filter.php?c="
}

enum Colors{
    
    static let mainColor = UIColor(named: "MainColor")!
}
