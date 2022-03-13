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
    
    let imageQuality: CGFloat = 1.0
    
    func requestImage(on imageUrl: String, handler: @escaping (UIImage) -> ()) {
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            let name = self.createImageNameFromImageURL(url: imageUrl)
            
            self.fileWorker.requestFile(with: name) { data in
                
                if let data = data, let image = UIImage(data: data){
                    
                    DispatchQueue.main.async {
                        //print("Картинка из хранилища")
                        handler(image)
                    }
                }
                
                else if data == nil{
                    
                    self.networkWorker.getData(from: imageUrl) { result in
                        
                        switch result {
                        case .failure(let error):
                            print(error.localizedDescription)
                        case .success(let data):
                            
                            guard let compresdImage = UIImage(data: data)?.jpegData(compressionQuality: self.imageQuality), let image = UIImage(data: compresdImage) else { return } // Есть ли вариант лучше?
                            
                            DispatchQueue.main.async {
                                //print("Картинка из сети")
                                handler(image)
                            }
                            
                            self.saveImage(image: image, with: name)
                        }
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
    
    private func createImageNameFromImageURL(url: String) -> String {
        
        return String(url.split(separator: "/").last ?? "")
    }
}
