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
    
    private let dataWorker = DataWorker()
    private let networkWorker = NetworkWorker()
    private let jsonDecoderWorker = JSONDecoderWorker()
    private let jsonEncoderWorker = JSONEncoderWorker()
    private let coreDataWorker = CoreDataWorker()
    
    let cartVC = CartViewController()
    
    func assemble() -> UIViewController{
        
        dataWorker.coreDataWorker = coreDataWorker
        dataWorker.jsonDecoderWorker = jsonDecoderWorker
        dataWorker.jsonEncoderWorker = jsonEncoderWorker
        dataWorker.networkWorker = networkWorker
        
        let mainViewController = MainMenueViewController()
        
        mainViewController.dataWorker = dataWorker
        
        cartVC.dataWorker = dataWorker
        
        return UINavigationController(rootViewController: mainViewController)
    }
}

