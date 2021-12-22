//
//  ViewController.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 05.12.2021.
//

import UIKit

class MainMenueViewController: UIViewController {
    
    //TEMP
    var categoriesSTR = [String]()
    //
    
    var categoryCollectionView: UICollectionView! //Категории
    var mealsCollectionView: UICollectionView! //Меню с едой
    
    var dataWorker: DataWorkerProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        dataWorker.delegate = self

        configureMainMenue()
        configureCategoryCollectionView()
        configureMealsCollectionView()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dataWorker.requestCategories()
    }
    
    func configureMainMenue(){
        
        let cartImage = Images.cart
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: cartImage,
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(openCart))
    }
    
    func configureCategoryCollectionView(){
        
        let layout = UICollectionViewFlowLayout()
        
        categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.addSubview(categoryCollectionView)
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.id)
        
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
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
    
    @objc func openCart(){
        
    }
}

extension MainMenueViewController: UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView{
            
        case categoryCollectionView:
            return categoriesSTR.count
            
        case mealsCollectionView:
            return 10
            
        default:
            return 10
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == categoryCollectionView{
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.id, for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
            
            cell.categoryLable.text = categoriesSTR[indexPath.row]
            
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == categoryCollectionView{
            
            
        }
        else if collectionView == mealsCollectionView {
            
            self.present(PresentMealViewController(), animated: true, completion: nil)
        }
    }
}

extension MainMenueViewController: DataWorkerDelegate{
    
    func getCategories(categories: [String]) {
        
        categoriesSTR = categories
        
        categoryCollectionView.reloadData()
    }
    
    func getMeals() {
        
    }
}

