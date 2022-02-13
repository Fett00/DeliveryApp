//
//  CustomCollectionView.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 23.12.2021.
//

import UIKit

protocol CollectionManagerProtocol{
    
    //Колекция с которой будет работать менеджер
    var collectionView: UICollectionView { get }
    
    //Функция для обновления данных колекции
    func updateData()
    
    //
    
}

class CollectionManager: NSObject {
    
    let collectionView: UICollectionView

    init(layout: UICollectionViewLayout, dataWorker: DataWorkerCollectedDataProtocol){
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension CollectionManager: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
    
    
}

extension CollectionManager: UICollectionViewDelegate{
    
}


