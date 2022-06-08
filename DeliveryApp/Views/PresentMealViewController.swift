//
//  PresentItemView.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 05.12.2021.
//

import UIKit

final class PresentMealViewController: UIViewController, IndexPathCollector{
    
    var indexPath: IndexPath
    
    //Изображение блюда
    private let mealImage: UIImageView = {
        
        let imageView = UIImageView()
        
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerCurve = .continuous
        imageView.layer.cornerRadius = 20
        //imageView.image = Images.emptyMeal //placeholder
        
        return imageView
    }()
    
    //Название блюда
    private let mealName: UILabel = {
        
        let lable = UILabel()
        
        lable.setContentHuggingPriority(.defaultHigh, for: .vertical)
        lable.font = UIFont.preferredFont(forTextStyle: .title1)
        lable.numberOfLines = 3
        
        return lable
    }()
    
    //Кнопка добавления в корзину
    private let addToCartButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemFill
        button.layer.borderWidth = 0.5
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        
        return button
    }()
    
    //Описание блюда
    private let mealDescription: UILabel = {
        
        let lable = UILabel()
        
        lable.numberOfLines = 0
        
        return lable
    }()
    
    //Navigation Bar
    private let bar: UINavigationBar = {
        
        let navigationBar = UINavigationBar()
        
        //Стрелку вниз или стрелку назад?
        let doneButton = UIBarButtonItem(image: Images.downArrow, style: .done, target: self, action: #selector(dismissView))
        let navigationItem = UINavigationItem()
        navigationItem.leftBarButtonItem = doneButton
        
        navigationBar.items = [navigationItem]
        
        return navigationBar
    }()
    
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
        
        //TEMP DATA//
        mealDescription.text = "Cook the quinoa following the pack instructions, then rinse in cold water and drain thoroughly. Meanwhile, mix the butter, chilli and garlic into a paste. Toss the chicken fillets in 2 tsp of the olive oil with some seasoning."
        //________//
    }
    
    private func configureView(){
        
        view.addSubview(mealImage, mealName, mealDescription, addToCartButton, bar)
        
        let safeArea = view.safeAreaLayoutGuide
        
        bar.constraints(top: safeArea.topAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingleft: 0, paddingRight: 0, width: 0, height: 0)
        
        mealImage.constraints(top: bar.bottomAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingleft: 30, paddingRight: 30, width: 0, height: 0)
        mealImage.heightAnchor.constraint(equalTo: mealImage.widthAnchor, multiplier: 1).isActive = true
        
        mealName.constraints(top: mealImage.bottomAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingleft: 20, paddingRight: 20, width: 0, height: 0)
        
        mealDescription.constraints(top: mealName.bottomAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 10, paddingBottom: 0, paddingleft: 20, paddingRight: 20, width: 0, height: 0)
        
        addToCartButton.constraints(top: nil, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 0, paddingBottom: 20, paddingleft: 20, paddingRight: 20, width: 0, height: 50)
        
        addToCartButton.topAnchor.constraint(greaterThanOrEqualTo: mealDescription.bottomAnchor, constant: 20).isActive = true
        
        mealDescription.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
    
    @objc private func addToCart(_ sender: UIButton){
        
        sender.showTapAnimation {
            
            self.dataWorker.addMealToCart(byIndex: self.indexPath.row, handler: {})
        }
    }
    
    @objc private func dismissView(){
        
        self.dismiss(animated: true, completion: nil)
    }
}
