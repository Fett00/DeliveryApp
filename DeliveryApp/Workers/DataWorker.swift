//
//  DataWorker.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 12.12.2021.
//

import UIKit

protocol DataWorkerProtocol: AnyObject{
    
    var delegate: DataWorkerDelegate? { get set }
    
    func requestCategories()
    
    func requsetMeals(for category: String)
}

protocol DataWorkerDelegate: AnyObject {
    
    func getCategories(categories: [CategoryModel])
    
    func getMeals(meals: [MealModel])
}

class DataWorker: DataWorkerProtocol{
    
    weak var delegate: DataWorkerDelegate?
    
    //Нужен ли инит
    //Как закрыть эти свойства от внешнего доступа
    var coreDataWorker: CoreDataWorkerProtocol!
    var jsonDecoderWorker: JSONDecoderWorkerProtocol!
    var networkWorker: NetworkWorkerProtocol!
    
    //АПИ для получения категорий
    private let categoriesURL = "https://www.themealdb.com/api/json/v1/1/categories.php"
    
    //АПИ для получения блюд для категории
    private let mealsURL = "https://www.themealdb.com/api/json/v1/1/filter.php?c="
    
    
    func requestCategories() {
        
        DispatchQueue.global(qos: .userInteractive).async { [ self ] //нужен ли weak/unowned
            
            var rawData = Data()
            
            let group = DispatchGroup()
            
            group.enter()
            self.networkWorker.getData(from: self.categoriesURL) { result in
                
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let data):
                    
                    rawData = data
                }
                group.leave()
            }
            
            group.wait()
            guard let categoriesToReturn = self.jsonDecoderWorker.decodeC(data: rawData) else { return }
            
            DispatchQueue.main.async {
                self.delegate?.getCategories(categories: categoriesToReturn.categories)
            }
        }
    }
    
    func requsetMeals(for category: String) {
        
        DispatchQueue.global(qos: .userInteractive).async { [ self ] //нужен ли weak/unowned
            
            var rawData = Data()
            
            let group = DispatchGroup()
            
            group.enter()
            self.networkWorker.getData(from: self.mealsURL + category) { result in
                
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let data):
                    
                    rawData = data
                }
                group.leave()
            }
            
            group.wait()
            guard let mealsToReturn = self.jsonDecoderWorker.decodeM(data: rawData) else { return }
            
            DispatchQueue.main.async {
                self.delegate?.getMeals(meals: mealsToReturn.meals)
            }
        }
    }
}

