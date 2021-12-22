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
    
    func getCategories(categories: [String])
    
    func getMeals()
}

class DataWorker: DataWorkerProtocol{
    
    weak var delegate: DataWorkerDelegate?
    
    //Нужен ли инит
    //Как закрыть эти свойства от внешнего доступа
    var coreDataWorker: CoreDataWorkerProtocol!
    var jsonDecoderWorker: JSONDecoderWorkerProtocol!
    var networkWorker: NetworkWorkerProtocol!
    
    
    func requestCategories() {
        
        delegate?.getCategories(categories: ["Beef", "Chkn", "Fish", "Potat"])
    }
    
    func requsetMeals(for category: String) {
        
    }
}

