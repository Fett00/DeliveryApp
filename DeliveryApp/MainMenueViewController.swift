//
//  ViewController.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 05.12.2021.
//

import UIKit

class MainMenueViewController: UIViewController {
    
    var categoryCollectionView: UICollectionView! //Категории
    var mealsCollectionView: UICollectionView! //Меню с едой

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground

        configureCategoryCollectionView()
        configuremealsCollectionView()
    }
    
    func configureCategoryCollectionView(){
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        
        categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.addSubview(categoryCollectionView)
        
        categoryCollectionView.backgroundColor = .brown
        
        let safeArea = view.safeAreaLayoutGuide
        categoryCollectionView.constraints(top: safeArea.topAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 10, paddingBottom: 0, paddingleft: 0, paddingRight: 0, width: 0, height: 40)
        
    }
    
    func configuremealsCollectionView(){
        
        let layout = UICollectionViewFlowLayout()
        
        mealsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.addSubview(mealsCollectionView)
        
        mealsCollectionView.backgroundColor = .blue
        
//        mealsCollectionView.delegate = self
//        mealsCollectionView.dataSource = self
        
        let safeArea = view.safeAreaLayoutGuide
        mealsCollectionView.constraints(top: categoryCollectionView.bottomAnchor, bottom: view.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 10, paddingBottom: 0, paddingleft: 0, paddingRight: 0, width: 0, height: 0)
    }
}

//extension MainMenueViewController: UICollectionViewDataSource{
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        10
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = UICollectionViewCell()
//
//        cell.backgroundColor = .blue
//
//        return cell
//    }
//}

extension MainMenueViewController: UICollectionViewDelegate{
    
}

