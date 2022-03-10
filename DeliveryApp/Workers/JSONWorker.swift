//
//  JSONWorker.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 19.12.2021.
//

import Foundation

protocol JSONDecoderWorkerProtocol{
    
    func decode<T: Decodable>(type: T.Type, data: Data) -> T?
    
}

protocol JSONEncoderWorkerProtocol{
    
    func encode<T: Encodable>(model: T) -> Data?
}

//Класс для парсинга данных в json
final class JSONDecoderWorker: JSONDecoderWorkerProtocol{
    
    let decoder: JSONDecoder = {
        
        let dec = JSONDecoder()
        
        return dec
    }()
    
    func decode<T: Decodable>(type: T.Type, data: Data) -> T?{
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            
            print(error.localizedDescription)
            return nil
        }
    }
}

final class JSONEncoderWorker: JSONEncoderWorkerProtocol{
    //Не создаем инстанс энкодера, т.к. encode происходит не часто, смысла в памяти держать нет
    func encode<T: Encodable>(model: T) -> Data? {
        
        return try? JSONEncoder().encode(model)
    }
}
