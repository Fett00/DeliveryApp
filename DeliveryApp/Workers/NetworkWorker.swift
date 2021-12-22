//
//  NetworkWorker.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 05.12.2021.
//

import Foundation

protocol NetworkWorkerProtocol{
    
    func getData(from url: String, networkHandler: @escaping (Result<Data, URLError>)->())
}


class NetworkWorker: NetworkWorkerProtocol {
    
    private let categoriesURL = "https://www.themealdb.com/api/json/v1/1/categories.php" //АПИ для получения категорий
    
    private let mealsURL = "https://www.themealdb.com/api/json/v1/1/filter.php?c=" //АПИ для получения блюд для категории
    
    
    func getCategories(handler: @escaping (Result<CategoriesModel, URLError>)->()){
        
        guard let url = URL(string: categoriesURL) else {
            
            handler(.failure(URLError(.badURL)))
            return
        }
        
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
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
    
    func getMeals(category: String, handler: @escaping (Result<[MealModel], URLError>)->()){
        
        guard let url = URL(string: mealsURL + category) else {
            
            handler(.failure(URLError(.badURL)))
            return
        }
        
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                handler(.failure(URLError(.unknown)))
            }
            
            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else { return }
            
            if let data = data {
                
                do {
                    let result = try JSONDecoder().decode([MealModel].self, from: data)
                    handler(.success(result))
                    
                } catch {
                    
                    print(error.localizedDescription)
                    handler(.failure(URLError(.unknown)))
                }
            }
            
            handler(.failure(URLError(.unknown)))
        }.resume()
    }
    
    func getData(from url: String, networkHandler: @escaping (Result<Data, URLError>)->()){
        
        guard let localURL = URL(string: url) else {

            networkHandler(.failure(URLError(.badURL)))
            return
        }
        
        let request = URLRequest(url: localURL, cachePolicy: .returnCacheDataElseLoad)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                networkHandler(.failure(URLError(.unknown)))
            }
            
            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                
                networkHandler(.failure(URLError(.unknown)))
                return
            }
            
            if let data = data {
                
                networkHandler(.success(data))
            }
            else{
                networkHandler(.failure(URLError(.badURL)))
            }
        }.resume()
    }
}

fileprivate class NetworkWorkerSingleton{
    
    
}
