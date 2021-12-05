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
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.id)
        
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

extension MainMenueViewController: UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView{
            
        case categoryCollectionView:
            return 10
            
        case mealsCollectionView:
            return 10
            
        default:
            return 10
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == categoryCollectionView{
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.id, for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
            
            cell.categoryLable.text = "Beef"
            
            return cell
        }
        else if collectionView == mealsCollectionView {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MealCollectionViewCell.id, for: indexPath) as? MealCollectionViewCell else { return UICollectionViewCell() }
            
            return cell
        }
        else{
            return UICollectionViewCell()
        }
    }
}

extension MainMenueViewController: UICollectionViewDelegate{
    
}

