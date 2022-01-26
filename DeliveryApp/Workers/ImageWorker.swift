//
//  ImageWorker.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 25.01.2022.
//

import UIKit

protocol ImageWorkerProtocol{
    
    func requestImage(on mealUrl: String, handler: @escaping (UIImage) -> ())
    
    func saveImage(image: UIImage, with url: String)
}

class ImageWorker: ImageWorkerProtocol{
    
    var fileWorker: FileWorkerProtocol!
    var networkWorker: NetworkWorkerProtocol!
    
    func requestImage(on mealUrl: String, handler: @escaping (UIImage) -> ()) {
        
        DispatchQueue.global(qos: .userInteractive).async { //[ self ] //нужен ли weak/unowned
            
            let name = self.createImageNameFromImageURL(url: mealUrl)
            
            if self.fileWorker.didFileExsist(with: mealUrl) {
                
                self.fileWorker.requestFile(with: mealUrl) { data in
                    
                    guard let data = data, let image = UIImage(data: data) else { return }
                    
                    DispatchQueue.main.async {
                        handler(image)
                    }
                }
            }
            else {
                
                self.networkWorker.getData(from: mealUrl) { result in
                    
                    switch result {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .success(let data):
                        
                        guard let image = UIImage(data: data) else { return }
                        
                        DispatchQueue.main.async {
                            handler(image)
                        }
                        
                        self.saveImage(image: image, with: name)
                    }
                }
            }
        }
    }
    
    func saveImage(image: UIImage, with url: String) {
        
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
        
        let name = createImageNameFromImageURL(url: url)
        
        fileWorker.saveFile(with: name, file: imageData)
    }
    
    func createImageNameFromImageURL(url: String) -> String {
        
        return String(url.split(separator: "/").last ?? "")
    }
}
