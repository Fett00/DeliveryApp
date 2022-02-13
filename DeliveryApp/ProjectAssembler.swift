//
//  ProjectAssembler.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 12.12.2021.
//

import UIKit

class ProjectAssembler{
    
    //singleton
    public static let shared = ProjectAssembler()
    private init(){}
    
    private let dataWorker = DataWorker() //Координация все отсальних воркеров. Работа с данными
    private let networkWorker = NetworkWorker() //Работа с сетью
    private let imageWorker = ImageWorker() // Работа с изображениями
    private let fileWorker = FileWorker() // Работа с файлами
    private let jsonDecoderWorker = JSONDecoderWorker() // Декодер JSON
    private let jsonEncoderWorker = JSONEncoderWorker() // Энкодер JSON
    private let coreDataWorker = CoreDataWorker() // Работа с core data
    
    func createMainViewController() -> UIViewController{
        
        dataWorker.coreDataWorker = coreDataWorker
        dataWorker.jsonDecoderWorker = jsonDecoderWorker
        dataWorker.jsonEncoderWorker = jsonEncoderWorker
        dataWorker.networkWorker = networkWorker
        
        imageWorker.fileWorker = fileWorker
        imageWorker.networkWorker = networkWorker
        
        let mainViewController = MainMenueViewController(dataWorker: dataWorker, imageWorker: imageWorker, data: dataWorker)
        
        return UINavigationController(rootViewController: mainViewController)
    }
    
    func createCartViewController() -> UIViewController{
        CartViewController()
    }
}

