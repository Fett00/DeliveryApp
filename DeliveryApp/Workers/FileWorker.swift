//
//  FileWorker.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 25.01.2022.
//

import Foundation
import UIKit

protocol FileWorkerProtocol{
    
    func didFileExsist(with name: String) -> Bool
    
    func saveFile(with name: String, file: Data)
    
    func requestFile(with name: String, handler: @escaping (Data?) -> ())
}

final class FileWorker: FileWorkerProtocol{
    
    private let fileManager = FileManager.default
    
    private let cachesPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]

    
    func didFileExsist(with name: String) -> Bool {
        
        return fileManager.fileExists(atPath: cachesPath.appendingPathComponent(name).path)
    }
    
    func saveFile(with name: String, file: Data){
        
        let path = cachesPath.appendingPathComponent(name)
        
        if didFileExsist(with: name){
          
            do {
                try fileManager.removeItem(at: path)
            } catch {
                print(error.localizedDescription)
            }
        }
        
        do {
            try file.write(to: path)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func requestFile(with name: String, handler: @escaping (Data?) -> ()) {
        
        let path = cachesPath.appendingPathComponent(name)
        
        let data = fileManager.contents(atPath: path.path)
        
        handler(data)
    }
}
