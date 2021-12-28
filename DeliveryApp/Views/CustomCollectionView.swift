//
//  CustomCollectionView.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 23.12.2021.
//

import UIKit

class CustomCollectionView {
    
    let collectionView: UICollectionView

    init(layout: UICollectionViewLayout){
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    }
}

//extension CustomCollectionView: UICollectionViewDelegate{
//
//}
//
//extension CustomCollectionView: UICollectionViewDataSource{
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//    }
//
//}
