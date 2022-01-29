//
//  ImageWorker.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 25.01.2022.
//

import UIKit

protocol ImageWorkerProtocol{
    
    func requestImage(on imageUrl: String, handler: @escaping (UIImage) -> ())
    
    func saveImage(image: UIImage, with url: String)
}

class ImageWorker: ImageWorkerProtocol{
    
    var fileWorker: FileWorkerProtocol!
    var networkWorker: NetworkWorkerProtocol!
    
    func requestImage(on imageUrl: String, handler: @escaping (UIImage) -> ()) {
        
        DispatchQueue.global(qos: .userInteractive).async { //[ self ] //нужен ли weak/unowned
            
            let name = self.createImageNameFromImageURL(url: imageUrl)
            
            if self.fileWorker.didFileExsist(with: name) {
                
                self.fileWorker.requestFile(with: name) { data in
                    
                    if let data = data, let image = UIImage(data: data){
                        
                        DispatchQueue.main.async {
                            handler(image)
                        }
                    }
                    //guard let data = data, let image = UIImage(data: data) else { return }
                }
            }
            else {
                
                self.networkWorker.getData(from: imageUrl) { result in
                    
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
