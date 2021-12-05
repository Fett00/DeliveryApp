//
//  NetworkWorker.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 05.12.2021.
//

import Foundation


class NetworkWorker {
    
    //singleton
    static public let shared = NetworkWorker()
    private init(){}
    
    private let categoriesURL = URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php")! //АПИ для получения категорий
    
    private let mealsURL = URL(string: "www.themealdb.com/api/json/v1/1/filter.php?c=")! //АПИ для получения блюд для категории
    
    
    func getCategories(handler: @escaping (Result<CategoriesModel, URLError>)->()){
        
        let request = URLRequest(url: categoriesURL, cachePolicy: .returnCacheDataElseLoad)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                handler(.failure(URLError(.unknown)))
            }
            
            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else { return }
            
            if let data = data {
                
                do {
                    let result = try JSONDecoder().decode(CategoriesModel.self, from: data)
                    handler(.success(result))
                    
                } catch {
                    
                    print(error.localizedDescription)
                    handler(.failure(URLError(.unknown)))
                }
            }
            
            handler(.failure(URLError(.unknown)))
        }.resume()
    }
}
