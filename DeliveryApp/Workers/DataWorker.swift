//
//  DataWorker.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 12.12.2021.
//

import UIKit
import CoreData

protocol DataWorkerForAddToCartProtocol: AnyObject{
    
    func addMealToCart(byIndex: Int, handler: @escaping () -> ())
}

protocol DataWorkerForMainMenueProtocol: AnyObject, DataWorkerForAddToCartProtocol{
    
    var delegate: DataWorkerDelegate? { get set }
    
    func requestCategories()
    
    func requestMeals(for category: String)
    
    func addMealToCart(byIndex: Int, handler: @escaping () -> ())
}

protocol DataWorkerForCartProtocol: AnyObject{
    
    func requestCartContent(withCondition condition: String?, handler: @escaping () -> ())
    
    func requestClearCart(withCondition condition: String?, handler: @escaping () -> ())
    
    func changeMealValue(mealID: String, increaseOrDecrease: Bool, handler: @escaping () -> ())
}

protocol DataWorkerCollectedDataForCartProtocol: AnyObject{
    
    var cartContent: [CartContentModel] { get }
}

protocol DataWorkerCollectedDataProtocol: AnyObject{
    
    var categoryModels: [CategoryModel] { get } //Массив с категориями
    
    var mealModels: [MealModel] { get } //Массив для хранения блюд текущей категории
}

protocol DataWorkerDelegate: AnyObject {
    
    func updateCategories()
    
    func updateMeals()
}



final class DataWorker: DataWorkerForMainMenueProtocol, DataWorkerForCartProtocol, DataWorkerCollectedDataProtocol, DataWorkerCollectedDataForCartProtocol{
    
    weak var delegate: DataWorkerDelegate? //Заменить на множественное делегирование
    
    
    
    var coreDataWorker: CoreDataWorkerProtocol!
    var jsonDecoderWorker: JSONDecoderWorkerProtocol!
    var jsonEncoderWorker: JSONEncoderWorkerProtocol!
    var networkWorker: NetworkWorkerProtocol!
    
    //АПИ для получения категорий
    private let categoriesURL = "https://www.themealdb.com/api/json/v1/1/categories.php"
    
    //АПИ для получения блюд для категории
    private let mealsURL = "https://www.themealdb.com/api/json/v1/1/filter.php?c="
    
    //Массив с категориями
    var categoryModels: [CategoryModel] = [CategoryModel]()
    
    //Массив для хранения блюд текущей категории
    var mealModels: [MealModel] = [MealModel]()
    
    // Массив с содержимым корзины
    var cartContent: [CartContentModel] = [CartContentModel]()
    
    
    func requestCategories() {
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let sortingBy = ["categoryID"]
            
            let categoriesFormCD = self.coreDataWorker.get(type: CDCategory.self, sortingBy: sortingBy, withCondition: nil, withLimit: nil, offset: nil).map{ CategoryModel(idCategory: String($0.categoryID), strCategory: $0.categoryName ?? "") }
            
            
            if !categoriesFormCD.isEmpty{
                
                self.categoryModels = categoriesFormCD
                
                DispatchQueue.main.async {
                    
                    print("Categ from CD")
                    self.delegate?.updateCategories()
                }
            }
            //
            
            self.networkWorker.getData(from: self.categoriesURL) { result in
                
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let data):
                    
                    guard let categories = self.jsonDecoderWorker.decode(type: CategoriesModel.self, data: data)?.categories else { return }
                    
                    
                    var coreDataNeedToUpdate = false
                    if categories.count != self.categoryModels.count{
                        
                        coreDataNeedToUpdate = true
                        self.categoryModels = categories
                        
                        DispatchQueue.main.async {
                            self.delegate?.updateCategories()
                        }
                    }
                    
                    if coreDataNeedToUpdate{
                        
                        self.coreDataWorker.delete(type: CDCategory.self, withCondition: nil) {
                            
                            self.coreDataWorker.add { context in
                                
                                for category in categories {
                                    
                                    let cdCategory = CDCategory(context: context)
                                    
                                    cdCategory.categoryName = category.strCategory
                                    cdCategory.categoryID = Int32(category.idCategory) ?? -1
                                }
                            } hanlder: {}
                        }
                    }
                }
            }
        }
    }
    
    
    func requestMeals(for category: String) {
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let condition = "categoryName=\(category)"
            let sortedBy = ["mealName", "mealID"]
            
            //Если присваивать прямо, появляется ошибка
            //self.mealModels = []
            let mealsFromCD = self.coreDataWorker.get(type: CDMeal.self, sortingBy: sortedBy, withCondition: condition, withLimit: nil, offset: nil).map{ MealModel(strMeal: $0.mealName ?? "", strMealThumb: $0.mealImageURL ?? "", idMeal: String($0.mealID), price: Int($0.price)) }
            
            
            if !mealsFromCD.isEmpty{
                
                self.mealModels = mealsFromCD
                
                DispatchQueue.main.async {
                    
                    print("Meals from CORE DATA")
                    self.delegate?.updateMeals()
                }
            }
            //
            
            self.networkWorker.getData(from: self.mealsURL + category) { result in
                
                switch result {
                case .failure(let error):
                    
                    print(error.localizedDescription)
                case .success(let data):
                    
                    guard var meals = self.jsonDecoderWorker.decode(type: MealsModel.self, data: data)?.meals else { return }
                    
                    for i in 0..<meals.count{
                        meals[i].price = (Int.random(in: 100...4000))
                    }

                    var coreDataNeedToUpdate = false
                    if meals.count != self.mealModels.count{
                        
                        if !self.mealModels.isEmpty{
                            coreDataNeedToUpdate = true
                        }
                        
                        self.mealModels = meals
                        
                        //self.coreDataWorker.delete(type: CDCartContent.self, withCondition: nil, hanlder: {})
                        
                        DispatchQueue.main.async {
                            print("Meal from net")
                            self.delegate?.updateMeals()
                        }
                    }
                    
                    if coreDataNeedToUpdate{
                        print("Create cache in CD")
                        self.coreDataWorker.delete(type: CDMeal.self, withCondition: condition) {
                            
                            self.coreDataWorker.add { context in
                                for meal in meals {
                                    
                                    let cdMeal = CDMeal(context: context)
                                    
                                    cdMeal.mealID = Int32(meal.idMeal) ?? -1
                                    cdMeal.mealImageURL = meal.strMealThumb
                                    cdMeal.mealName = meal.strMeal
                                    cdMeal.categoryName = category
                                    cdMeal.price = Int32(meal.price)
                                }
                            } hanlder: {}
                        }
                    }
                }
            }
        }
    }
    
    func addMealToCart(byIndex: Int, handler: @escaping () -> ()){
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let condition = "mealID=\(self.mealModels[byIndex].idMeal)"
            
            if self.coreDataWorker.count(type: CDCartContent.self, withCondition: condition, withLimit: nil, offset: nil) != 0 {
                
                self.coreDataWorker.changeIntegerValue(type: CDCartContent.self, withCondition: condition, key: "count", increaseOrDecrease: true) {
                    
                    print("Add another meal to cart")
                    handler()
                }
            }
            
            else{
                
                let meal = self.mealModels[byIndex]
                
                self.coreDataWorker.add { context in
                    
                    let cdModel = CDCartContent(context: context)
                    
                    cdModel.imageURL = meal.strMealThumb
                    cdModel.price = Int32(meal.price)
                    cdModel.name = meal.strMeal
                    cdModel.count = 1
                    cdModel.mealID = Int32(meal.idMeal) ?? -1
                    
                } hanlder: {
                    print("Add to cart")
                    handler()
                }
            }
        }
    }
    
    func requestCartContent(withCondition condition: String?, handler: @escaping () -> ()){
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            self.cartContent = self.coreDataWorker.get(type: CDCartContent.self, sortingBy: nil, withCondition: condition, withLimit: nil, offset: nil).map{ CartContentModel(name: $0.name ?? "", price: Int($0.price), count: Int($0.count), imageURL: $0.imageURL ?? "", mealID: Int($0.mealID)) }
            
            DispatchQueue.main.async {
                handler()
            }
        }
    }
    
    func requestClearCart(withCondition condition: String?, handler: @escaping () -> ()) {
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            self.coreDataWorker.delete(type: CDCartContent.self, withCondition: condition) {
                
                DispatchQueue.main.async {
                    handler()
                }
            }
        }
    }
    
    func changeMealValue(mealID: String, increaseOrDecrease: Bool, handler: @escaping () -> ()){
        
        let condition = "mealID=\(mealID)"
        
        if self.coreDataWorker.count(type: CDCartContent.self, withCondition: condition, withLimit: nil, offset: nil) != 0 {
            
            self.coreDataWorker.changeIntegerValue(type: CDCartContent.self, withCondition: condition, key: "count", increaseOrDecrease: increaseOrDecrease) {
                
                handler()
            }
        }
    }
}

