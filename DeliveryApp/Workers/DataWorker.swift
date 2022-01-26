//
//  DataWorker.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 12.12.2021.
//

import UIKit

protocol DataWorkerForMainMenueProtocol: AnyObject{
    
    var delegate: DataWorkerDelegate? { get set }
    
    var imageDelegate: DataWorkerForImageDelegate? { get set }
    
    func requestCategories()
    
    func requestMeals(for category: String)
    
    func requestImageData(on mealUrl: String, for item: IndexPath)
    
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

protocol DataWorkerForImageDelegate: AnyObject{
    
    func getImage(image: UIImage, for item: IndexPath)
}

//SOLID???
class DataWorker: DataWorkerForMainMenueProtocol, DataWorkerForCartProtocol, DataWorkerCollectedDataProtocol{
    
    weak var delegate: DataWorkerDelegate?
    weak var imageDelegate: DataWorkerForImageDelegate?
    
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
    var categoryModels: [CategoryModel] = []
    
    //Массив для хранения блюд текущей категории
    var mealModels: [MealModel] = []
    
    func requestCategories() {
        
        DispatchQueue.global(qos: .userInteractive).async { //[ self ] //нужен ли weak/unowned
            
            self.networkWorker.getData(from: self.categoriesURL) { result in
                
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let data):

                    guard let categories = self.jsonDecoderWorker.decodeC(data: data)?.categories else { return }
                    
                    self.categoryModels = categories
                    
                    DispatchQueue.main.async {  
                        self.delegate?.updateCategories()
                    }
                }
            }
        }
    }
    
    func requestMeals(for category: String) {
        
        DispatchQueue.global(qos: .userInteractive).async { //[ self ] //нужен ли weak/unowned
            
            self.networkWorker.getData(from: self.mealsURL + category) { result in
                
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let data):
                    
                    guard let meals = self.jsonDecoderWorker.decodeM(data: data)?.meals else { return }
                    
                    self.mealModels = meals
                    
                    DispatchQueue.main.async {
                        self.delegate?.updateMeals()
                    }
                }
            }
        }
    }
    
    //Где вызывать?
    func requestImageData(on mealUrl: String, for item: IndexPath) {
        
        DispatchQueue.global(qos: .userInteractive).async { //[ self ] //нужен ли weak/unowned
            
            var rawData = Data()
            
            let group = DispatchGroup()
            
            group.enter()
            self.networkWorker.getData(from: mealUrl) { result in
                
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let data):
                    
                    rawData = data
                }
                group.leave()
            }
            
            group.wait()
            guard let image = UIImage(data: rawData) else { return }
            
            DispatchQueue.main.async {
                self.imageDelegate?.getImage(image: image, for: item)
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

