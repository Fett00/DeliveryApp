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
    
    let dataWorker = DataWorker()
    let networkWorker = NetworkWorker()
    let jsonWorker = JSONDecoderWorker()
    let coreDataWorker = CoreDataWorker()
    
    func assemble() -> UIViewController{
        
        dataWorker.coreDataWorker = coreDataWorker
        dataWorker.jsonDecoderWorker = jsonWorker
        dataWorker.networkWorker = networkWorker
        
        let mainViewController = MainMenueViewController()
        
        mainViewController.dataWorker = dataWorker
        
        return UINavigationController(rootViewController: mainViewController)
    }
}

