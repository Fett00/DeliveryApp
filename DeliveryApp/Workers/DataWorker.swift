//
//  DataWorker.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 12.12.2021.
//

import UIKit

protocol DataWorkerProtocol{
    
    
}

class DataWorker: DataWorkerProtocol{
    
    var coreDataWorker: CoreDataWorkerProtocol!
    var jsonDecoderWorker: JSONDecoderWorkerProtocol!
    var networkWorker: NetworkWorkerProtocol!

    func firstGetCategories(){
        
//        var categories: [CategoryModel] = []
//        let group = DispatchGroup()
//
//        group.enter()
//        NetworkWorker.shared.getCategories { result in
//
//            switch result {
//            case .failure(let error):
//
//                print(error.localizedDescription)
//
//            case .success(let model):
//
//                categories = model.categories
//            }
//            group.leave()
//        }
//
//        group.wait()
//
//        //Дописать
        
    }
    
}

