//
//  DataWorker.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 12.12.2021.
//

import UIKit
import CoreData

protocol DataWorkerForMainMenueProtocol: AnyObject{
    
    var delegate: DataWorkerDelegate? { get set }
    
    func requestCategories()
    
    func requestMeals(for category: String)
    
    func addMealToCart(meal: MealModel)
}

protocol DataWorkerForCartProtocol: AnyObject{
    
    var delegate: DataWorkerDelegate? { get set }
    
    func requestCartContent()
}

protocol DataWorkerCollectedDataProtocol: AnyObject{
    
    var categoryModels: [CategoryModel] { get } //Массив с категориями
    
    var mealModels: [MealModel] { get } //Массив для хранения блюд текущей категории
}

protocol DataWorkerDelegate: AnyObject {
    
    func updateCategories()
    
    func updateMeals()
}


//SOLID???
class DataWorker: DataWorkerForMainMenueProtocol, DataWorkerForCartProtocol, DataWorkerCollectedDataProtocol{
    
    weak var delegate: DataWorkerDelegate? //Заменить на множественное делегирование
    
    //Нужен ли инит
    //Как закрыть эти свойства от внешнего доступа
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
    
    //TODO: Объединить requestCategories и requestMeals в одну общую функцию
    func requestCategories() {
        
        DispatchQueue.global(qos: .userInteractive).async { //[ self ] //нужен ли weak/unowned
            
            let sortingBy = ["categoryID"]
            
            let categoriesFormCD = self.coreDataWorker.get(type: CDCategory.self, sortingBy: sortingBy, withCondition: nil, withLimit: nil, offset: nil).map{ CategoryModel(idCategory: String($0.categoryID), strCategory: $0.categoryName ?? "") }
            
            //MARK:  СНАЧАЛА ДЕЛАЕМ ЗАПРОС В CD, ПРИСВАЕВАЕМ ПОЛУЧЕННЫЕ ДАННЫЕ К МАССИВУ И ВЫЗЫВАЕМ ДЕЛЕГАТ ДЛЯ ОБНОВЛЕНИЯ ТАБЛИЦЫ. ДАЛЬШЕ ОТПРАВЛЯЕМ ЗАПРОС В СЕТЬ. И СРАВНИВАЕМ ПОЛУЧИВШИЕСЯ ДАННЫЕ С ТЕМИ ЧТО БЫЛИ В КД. ОБНОВЛЯЕМ КД
            
            if !categoriesFormCD.isEmpty{
                
                self.categoryModels = categoriesFormCD
                
                DispatchQueue.main.async {
                    
                    print("Categ from CD")
                    self.delegate?.updateCategories()
                }
            }
            //
            
            //После извлечения данных из КД, в более глубоком бэкграунде начинают отправляться запросы в сеть
            // Реализовать DispatchQueue.global(qos: .default).async {
            self.networkWorker.getData(from: self.categoriesURL) { result in
                
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let data):
                    
                    guard let categories = self.jsonDecoderWorker.decode(type: CategoriesModel.self, data: data)?.categories else { return }
                    
                    
                    //Сделать здесь что-то
                    //Сравнить например данные
                    var coreDataNeedToUpdate = false
                    if categories.count != self.categoryModels.count{
                        
                        coreDataNeedToUpdate = true
                        self.categoryModels = categories
                        
                        DispatchQueue.main.async {
                            self.delegate?.updateCategories()
                        }
                    }
                    
                    if coreDataNeedToUpdate{
                        
                        self.coreDataWorker.delete(type: CDCategory.self, withCondition: nil)
                        
                        self.coreDataWorker.add {
                            
                            for category in categories {
                                
                                let cdCategory = CDCategory(context: self.coreDataWorker.context)
                                
                                cdCategory.categoryName = category.strCategory
                                cdCategory.categoryID = Int32(category.idCategory) ?? -1
                            }
                        }
                    }
                    //
                }
            }
        }
    }
    //MARK: В текущей реализации метода нельзя добавить обновление данных из сети через activity indicator
    func requestMeals(for category: String) {
        
        DispatchQueue.global(qos: .userInteractive).async { //[ self ] //нужен ли weak/unowned
            
            let condition = "categoryName=\(category)"
            let sortedBy = ["mealName", "mealID"]
            
            //Если присваивать прямо, появляется ошибка
            //self.mealModels = []
            let mealsFromCD = self.coreDataWorker.get(type: CDMeal.self, sortingBy: sortedBy, withCondition: condition, withLimit: nil, offset: nil).map{ MealModel(strMeal: $0.mealName ?? "", strMealThumb: $0.mealImageURL ?? "", idMeal: String($0.mealID), price: Int($0.price)) }
            
            //MARK:  СНАЧАЛА ДЕЛАЕМ ЗАПРОС В КД, ПРИСВАЕВАЕМ ПОЛУЧЕННЫЕ ДАННЫЕ К МАССИВУ И ВЫЗЫВАЕМ ДЕЛЕГАТ ДЛЯ ОБНОВЛЕНИЯ ТАБЛИЦЫ. ДАЛЬШЕ ОТПРАВЛЯЕМ ЗАПРОС В СЕТЬ. И СРАВНИВАЕМ ПОЛУЧИВШИЕСЯ ДАННЫЕ С ТЕМИ ЧТО БЫЛИ В КД. ОБНОВЛЯЕМ КД
            
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
                    //Сделать здесь что-то
                    //Сравнить например данные
                    
                    //TEMP
                    var coreDataNeedToUpdate = false
                    if meals.count != self.mealModels.count{
                        
                        if !self.mealModels.isEmpty{
                            coreDataNeedToUpdate = true
                        }
                        
                        self.mealModels = meals
                        
                        DispatchQueue.main.async {
                            print("Meal from net")
                            self.delegate?.updateMeals()
                        }
                    }
                    
                    if coreDataNeedToUpdate{
                        print("Create cache in CD")
                        self.coreDataWorker.delete(type: CDMeal.self, withCondition: condition)
                        
                        self.coreDataWorker.add {
                            for meal in meals {
                                
                                let cdMeal = CDMeal(context: self.coreDataWorker.context)
                                
                                cdMeal.mealID = Int32(meal.idMeal) ?? -1
                                cdMeal.mealImageURL = meal.strMealThumb
                                cdMeal.mealName = meal.strMeal
                                cdMeal.categoryName = category
                                cdMeal.price = Int32(meal.price)
                            }
                        }
                    }
                    //
                }
            }
        }
    }
    
    func addMealToCart(meal: MealModel){
        
        coreDataWorker.add {
            
            let data = jsonEncoderWorker.encode(model: meal)
            let content = CartContent(context: coreDataWorker.context)
            
            content.data = data
            content.name = meal.strMeal
        }
    }
    
    func requestCartContent(){
        
        
    }
}

