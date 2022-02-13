//
//  CartViewController.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 19.01.2022.
//

import UIKit

class CartViewController: UIViewController {
    
    var dataWorker: DataWorkerForCartProtocol! //Объект для запроса данных
    
    var mealsInCart = [MealModel]() //Блюда в корзине

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        
        configureCartViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadMeals()
    }
    
    func configureCartViewController(){
        
    }
    
    func loadMeals(){
        
        
    }
}
