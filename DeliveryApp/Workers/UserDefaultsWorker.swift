//
//  UserDefaultsWorker.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 02.03.2022.
//

import Foundation

enum UserDefaultsKeys: String{
    
    case home = "home"
    case street = "street"
    case city = "city"
    case name = "name"
    case apartment = "apartment"
    case phone = "phone"
}

protocol UserDefaultsWorkerProtocol{
    
    func getStringValue(withKey key: String, handler: @escaping (String?) -> ())
    
    func setStringValue(withKey key: String, value: String, handler: @escaping () -> ())
}

final class UserDefaultsWorker: UserDefaultsWorkerProtocol{
    
    let userDefaultsStorage = UserDefaults.standard
    
    func getStringValue(withKey key: String, handler: @escaping (String?) -> ()){
        
        handler(userDefaultsStorage.string(forKey: key))
    }
    
    func setStringValue(withKey key: String, value: String, handler: @escaping () -> ()){
        
        userDefaultsStorage.setValue(value, forKey: key)
        handler()
    }
}
