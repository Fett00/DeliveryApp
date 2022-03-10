//
//  PresentItemView.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 05.12.2021.
//

import UIKit

final class PresentMealViewController: UIViewController, IndexPathCollector{
    
    var indexPath: IndexPath
    
    private let mealImage = UIImageView()
    private let mealName = UILabel()
    private let addToCartButton = UIButton()
    private let mealDescription = UILabel()
    private let bar = UINavigationBar()
    
    //МодельБлюда
    private let meal: MealModel
    //Загрузка изображений
    private let imageWorker: ImageWorkerProtocol
    //Запры в БД
    private let dataWorker: DataWorkerForAddToCartProtocol
    
    init(meal: MealModel, imageWorker: ImageWorkerProtocol, dataWorker: DataWorkerForAddToCartProtocol, indexPath: IndexPath){
        
        self.imageWorker = imageWorker
        self.meal = meal
        self.dataWorker = dataWorker
        self.indexPath = indexPath
        
        super.init(nibName: nil, bundle: nil)
        
        loadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureView()
    }
    
    private func loadData(){
        
        imageWorker.requestImage(on: meal.strMealThumb) { [weak self] image in
            
            guard let strongSelf = self else { return }
            
            strongSelf.mealImage.image = image
        }
        
        mealName.text = meal.strMeal
        addToCartButton.setTitle("\(meal.price) ₽", for: .normal)
    }
    
    private func configureView(){
        
        //Стрелку вниз или стрелку назад?
        let doneButton = UIBarButtonItem(image: Images.downArrow, style: .done, target: self, action: #selector(dismissView))
        let navigationItem = UINavigationItem()
        navigationItem.leftBarButtonItem = doneButton
        
        bar.items = [navigationItem]

        view.addSubview(mealImage, mealName, mealDescription, addToCartButton, bar)
        
        let safeArea = view.safeAreaLayoutGuide
        
        bar.constraints(top: safeArea.topAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingleft: 0, paddingRight: 0, width: 0, height: 0)
        
        mealImage.constraints(top: bar.bottomAnchor, bottom: safeArea.centerYAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingleft: 30, paddingRight: 30, width: 0, height: 0)
        
        mealName.constraints(top: mealImage.bottomAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingleft: 20, paddingRight: 20, width: 0, height: 0)
        
        mealDescription.constraints(top: mealName.bottomAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 10, paddingBottom: 0, paddingleft: 20, paddingRight: 20, width: 0, height: 0)
        
        addToCartButton.constraints(top: nil, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 0, paddingBottom: 20, paddingleft: 20, paddingRight: 20, width: 0, height: 50)
        
        addToCartButton.topAnchor.constraint(greaterThanOrEqualTo: mealDescription.bottomAnchor, constant: 20).isActive = true
        
        mealImage.tintColor = .systemGray3
        mealImage.contentMode = .scaleToFill
        mealImage.clipsToBounds = true
        mealImage.layer.cornerCurve = .continuous
        mealImage.layer.cornerRadius = 20
        //mealImage.image = Images.emptyMeal //placeholder
        
        mealName.setContentHuggingPriority(.defaultHigh, for: .vertical)
        mealName.font = UIFont.preferredFont(forTextStyle: .title1)
        mealName.numberOfLines = 3
        
        mealDescription.numberOfLines = 0
        
        addToCartButton.setTitleColor(.label, for: .normal)
        addToCartButton.backgroundColor = .secondarySystemFill
        addToCartButton.layer.borderWidth = 0.5
        addToCartButton.layer.cornerCurve = .continuous
        addToCartButton.layer.cornerRadius = 20
        addToCartButton.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        
        //TEMP DATA//
        mealDescription.text = "Cook the quinoa following the pack instructions, then rinse in cold water and drain thoroughly. Meanwhile, mix the butter, chilli and garlic into a paste. Toss the chicken fillets in 2 tsp of the olive oil with some seasoning."
        //________//
        
    }
    
    @objc private func addToCart(){
        
        dataWorker.addMealToCart(byIndex: indexPath.row, handler: {})
    }
    
    @objc private func dismissView(){
        
        self.dismiss(animated: true, completion: nil)
    }
}
