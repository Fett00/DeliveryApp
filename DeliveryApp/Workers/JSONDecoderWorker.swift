//
//  JSONDecoderWorker.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 19.12.2021.
//

import Foundation

protocol JSONDecoderWorkerProtocol{
    
    func decode<TypeOf: Decodable>(data: Data) -> TypeOf?
    
    //TEMP
    func decodeC(data: Data) -> CategoriesModel?
    func decodeM(data: Data) -> MealsModel?
    //
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
    
    
    //TEMP
    func decodeC(data: Data) -> CategoriesModel?{
        
        do {
            return try decoder.decode(CategoriesModel.self, from: data)
        } catch {
            
            print(error.localizedDescription)
            return nil
        }
    }
    func decodeM(data: Data) -> MealsModel?{
        
        do {
            return try decoder.decode(MealsModel.self, from: data)
        } catch {
            
            print(error.localizedDescription)
            return nil
        }
    }
}
