//
//  ProjectAssembler.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 12.12.2021.
//

import UIKit

class ProjectAssembler{
    
    private let dataWorker = DataWorker() //Координация все отсальних воркеров. Работа с данными
    private let networkWorker = NetworkWorker() //Работа с сетью
    private let imageWorker = ImageWorker() // Работа с изображениями
    private let fileWorker = FileWorker() // Работа с файлами
    private let jsonDecoderWorker = JSONDecoderWorker() // Декодер JSON
    private let jsonEncoderWorker = JSONEncoderWorker() // Энкодер JSON
    private let coreDataWorker = CoreDataWorker() // Работа с core data
    private let userDefaultsWorker = UserDefaultsWorker()//Работа с user defaults
    
    //singleton
    public static let shared = ProjectAssembler()
    private init(){
        
        dataWorker.coreDataWorker = coreDataWorker
        dataWorker.jsonDecoderWorker = jsonDecoderWorker
        dataWorker.jsonEncoderWorker = jsonEncoderWorker
        dataWorker.networkWorker = networkWorker
        
        imageWorker.fileWorker = fileWorker
        imageWorker.networkWorker = networkWorker
    }
    
    ///Создание входной точки для приложения
    func createEnteryPointOfProject() -> UIViewController{
        
        UINavigationBar.appearance().tintColor = .label
        
        let tabBar = UITabBarController()
        tabBar.tabBar.backgroundColor = Colors.mainColor
        tabBar.tabBar.tintColor = .black
        tabBar.tabBar.unselectedItemTintColor = .gray
        
        //Настройка вкладки с меню
        let mainTab = UINavigationController(rootViewController: MainMenueViewController(dataWorker: dataWorker, imageWorker: imageWorker, data: dataWorker))
        
        mainTab.tabBarItem = UITabBarItem(title: "Menue", image: Images.menue, tag: 0)
        //
        
        //Настройка вкладки с профилем пользователя
        let profileTab = UINavigationController(rootViewController: ProfileViewController())
        
        profileTab.tabBarItem = UITabBarItem(title: "Profile", image: Images.profile, tag: 1)
        //
        
        tabBar.viewControllers = [mainTab, profileTab]
        
        return tabBar
    }
    
    ///Создание контроллера корзины
    func createCartViewController() -> UIViewController{
        UINavigationController(rootViewController: CartViewController(dataWorker: dataWorker, data: dataWorker, imageWorker: imageWorker))
    }
    
    ///Создание контроллера для представления блюд
    func createPresentMealViewController(meal: MealModel, indexPath: IndexPath) -> UIViewController{
        
        PresentMealViewController(meal: meal, imageWorker: self.imageWorker, dataWorker: self.dataWorker, indexPath: indexPath)
    }
    
    ///Контроллер для ввода пользовательских данных
    func createPersonalInformationViewController() -> UIViewController{
        
        PersonalInformationViewController(userDefaultsWorker: self.userDefaultsWorker)
    }
}

