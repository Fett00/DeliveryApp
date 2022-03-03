//
//  UserDefaultsWorker.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 02.03.2022.
//

import Foundation

protocol UserDefaultsWorkerProtocol{
    
    func getStringValue(withKey key: String, hanlder: @escaping (String?) -> ())
    
    func setStringValue(withKey key: String, value: String, hanlder: @escaping () -> ())
}

class UserDefaultsWorker: UserDefaultsWorkerProtocol{
    
    let userDefaultsStorage = UserDefaults.standard
    
    func getStringValue(withKey key: String, hanlder: @escaping (String?) -> ()){
        
        hanlder(userDefaultsStorage.string(forKey: key))
    }
    
    func setStringValue(withKey key: String, value: String, hanlder: @escaping () -> ()){
        
        userDefaultsStorage.setValue(value, forKey: key)
        hanlder()
    }
}
