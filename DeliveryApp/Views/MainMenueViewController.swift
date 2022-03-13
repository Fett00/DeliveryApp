//
//  ViewController.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 05.12.2021.
//

import UIKit

final class MainMenueViewController: UIViewController {
    
    private var currentCategory:Int = 0 //Текущая категория
    
    private let categoryCollectionView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    private let mealsCollectionView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        return collectionView
    }()
    
    private let dataWorker: DataWorkerForMainMenueProtocol //Объект для запроса данных
    private let imageWorker: ImageWorkerProtocol //Объект для работы с изображениями
    private let data: DataWorkerCollectedDataProtocol //Объект для получения данных
    
    init(dataWorker: DataWorkerForMainMenueProtocol, imageWorker: ImageWorkerProtocol, data: DataWorkerCollectedDataProtocol){
        
        self.dataWorker = dataWorker
        self.imageWorker = imageWorker
        self.data = data
        
        super.init(nibName: nil, bundle: nil)
        
        self.dataWorker.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground

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
        //dataWorker.requsetMeals(for: "Beef") // Перенес в делегат после получения списка категорий
    }
    
    private func configureMainMenue(){
        
        let cartImage = Images.cart
        
        let cartButton = UIBarButtonItem(image: cartImage, style: .plain, target: self, action: #selector(openCart))
        
        self.navigationItem.rightBarButtonItem = cartButton
    }
    
    private func configureCategoryCollectionView(){
        
        view.addSubview(categoryCollectionView)
        
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.id)
        
        let safeArea = view.safeAreaLayoutGuide
        categoryCollectionView.constraints(top: safeArea.topAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 10, paddingBottom: 0, paddingleft: 0, paddingRight: 0, width: 0, height: 50)
        
    }
    
    private func configureMealsCollectionView(){
        
        view.addSubview(mealsCollectionView)
        
        mealsCollectionView.delegate = self
        mealsCollectionView.dataSource = self
        mealsCollectionView.register(MealCollectionViewCell.self, forCellWithReuseIdentifier: MealCollectionViewCell.id)
        
        guard let flowLayout = mealsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let insets = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        let spacing = 20.0
        let deviceWidth = view.frame.width
        let itemSize = (deviceWidth - insets.left - insets.right - spacing ) / 2
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.minimumLineSpacing = spacing
        flowLayout.sectionInset = insets
        flowLayout.itemSize = CGSize(width: itemSize, height: itemSize * 2)
        
        let safeArea = view.safeAreaLayoutGuide
        mealsCollectionView.constraints(top: categoryCollectionView.bottomAnchor, bottom: view.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingleft: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    @objc private func openCart(){
        
        let cartVC = ProjectAssembler.shared.createCartViewController()
        
        self.present(cartVC, animated: true, completion: nil)
    }
    
    @objc private func addToCart(_ sender: UIButton){
        
        sender.showTapAnimation {
            
            guard let sendedView = sender.superview as? IndexPathCollector else { return }
            
            self.dataWorker.addMealToCart(byIndex: sendedView.indexPath.row, handler: {})
        }
    }
}

extension MainMenueViewController: UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView{
            
        case categoryCollectionView:
            return data.categoryModels.count
            
        case mealsCollectionView:
            return data.mealModels.count
            
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == categoryCollectionView{
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.id, for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
            
            cell.setUpCell(with: data.categoryModels[indexPath.row])//categoryModels[indexPath.row])
            
            return cell
        }
        else if collectionView == mealsCollectionView {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MealCollectionViewCell.id, for: indexPath) as? MealCollectionViewCell else { return UICollectionViewCell() }
            
            cell.setUpCell(with: data.mealModels[indexPath.row], indexPath: indexPath)//mealModels[indexPath.row])
            
            imageWorker.requestImage(on: data.mealModels[indexPath.row].strMealThumb) { image in
                
                cell.setUpImage(with: image)
            }
            
            //cell.addToCartButton.addTarget(self, action: #selector(addToCart(_:)), for: .touchUpInside)
            
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
            
            let topRow = IndexPath(row: 0, section: 0)
            
            if currentCategory != indexPath.row{
                
                currentCategory = indexPath.row
                dataWorker.requestMeals(for: data.categoryModels[currentCategory].strCategory)
                
                mealsCollectionView.scrollToItem(at: topRow, at: .centeredVertically, animated: false)
            }
            
            else{
                mealsCollectionView.scrollToItem(at: topRow, at: .centeredVertically, animated: true)
            }
            
        }
        else if collectionView == mealsCollectionView {
            
            let presentVC = ProjectAssembler.shared.createPresentMealViewController(meal: data.mealModels[indexPath.row], indexPath: indexPath)
            
            self.present(presentVC, animated: true, completion: nil)
        }
    }
}

extension MainMenueViewController: DataWorkerDelegate{
    
    func updateCategories() {
        
        if !data.categoryModels.isEmpty{
            
            categoryCollectionView.reloadData()
            
            dataWorker.requestMeals(for: data.categoryModels[currentCategory].strCategory)
        }
    }
    
    func updateMeals() {
        
        mealsCollectionView.reloadData()
        self.navigationItem.title = self.data.categoryModels[self.currentCategory].strCategory
    }
}



