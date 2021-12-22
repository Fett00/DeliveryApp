//
//  JSONDecoderWorker.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 19.12.2021.
//

import Foundation

protocol JSONDecoderWorkerProtocol{
    
    func decode<TypeOf: Decodable>(data: Data) -> TypeOf?
}

//Класс для парсинга данных в json
class JSONDecoderWorker: JSONDecoderWorkerProtocol{
    
    let decoder: JSONDecoder = {
        
        let dec = JSONDecoder()
        
        return dec
    }()
    
    func decode<TypeOf: Decodable>(data: Data) -> TypeOf?{
        
        do {
            return try decoder.decode(TypeOf.self, from: data)
        } catch {
            
            print(error.localizedDescription)
            return nil
        }
    }
}
