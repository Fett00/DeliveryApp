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
        configureMealsCollectionView()
        
        NetworkWorker.shared.getCategories { result in
            
            switch result{
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let categories):
                for i in categories.categories{
                    print(i.strCategory)
                    
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    func configureCategoryCollectionView(){
        
        let layout = UICollectionViewFlowLayout()
        
        categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.addSubview(categoryCollectionView)
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.id)
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        categoryCollectionView.showsHorizontalScrollIndicator = false
        
        let safeArea = view.safeAreaLayoutGuide
        categoryCollectionView.constraints(top: safeArea.topAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 10, paddingBottom: 0, paddingleft: 0, paddingRight: 0, width: 0, height: 40)
        
    }
    
    func configureMealsCollectionView(){
        
        let layout = UICollectionViewFlowLayout()
        
        mealsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.addSubview(mealsCollectionView)
        
        mealsCollectionView.delegate = self
        mealsCollectionView.dataSource = self
        mealsCollectionView.register(MealCollectionViewCell.self, forCellWithReuseIdentifier: MealCollectionViewCell.id)
        
        let insets = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        let spacing = 20.0
        let deviceWidth = view.frame.width
        let itemSize = (deviceWidth - insets.left - insets.right - spacing) / 2
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = insets
        layout.itemSize = CGSize(width: itemSize, height: itemSize * 2)
        
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
            cell.backgroundColor = .secondarySystemBackground
            
            return cell
        }
        else if collectionView == mealsCollectionView {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MealCollectionViewCell.id, for: indexPath) as? MealCollectionViewCell else { return UICollectionViewCell() }
            
            cell.backgroundColor = .secondarySystemBackground
            
            return cell
        }
        else{
            return UICollectionViewCell()
        }
    }
}

extension MainMenueViewController: UICollectionViewDelegate{
    
}

