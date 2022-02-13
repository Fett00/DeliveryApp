//
//  PresentItemView.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 05.12.2021.
//

import UIKit

class PresentMealViewController: UIViewController{
    
    let mealImage = UIImageView()
    let mealName = UILabel()
    let addToCartButton = UIButton()
    let mealDescription = UILabel()
    let bar = UINavigationBar()
    
    //МодельБлюда
    let meal: MealModel
    //Загрузка изображений
    let imageWorker: ImageWorkerProtocol
    //Запры в БД
    //let coreDataWorker: CoreDataWorkerProtocol
    
    init(meal: MealModel, imageWorker: ImageWorkerProtocol){
        
        self.imageWorker = imageWorker
        self.meal = meal
        
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
    
    func loadData(){
        
        imageWorker.requestImage(on: meal.strMealThumb) { [weak self] image in
            
            guard let strongSelf = self else { return }
            
            strongSelf.mealImage.image = image
        }
        
        mealName.text = meal.strMeal
        addToCartButton.setTitle("\(meal.price) ₽", for: .normal)
    }
    
    func configureView(){
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissView))
        let navigationItem = UINavigationItem()
        navigationItem.rightBarButtonItem = doneButton
        
        bar.items = [navigationItem]

        view.addSubview(mealImage, mealName, mealDescription, addToCartButton, bar)
        
        let safeArea = view.safeAreaLayoutGuide
        
        bar.constraints(top: safeArea.topAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingleft: 0, paddingRight: 0, width: 0, height: 0)
        
        mealImage.constraints(top: bar.bottomAnchor, bottom: safeArea.centerYAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingleft: 10, paddingRight: 10, width: 0, height: 0)
        
        mealName.constraints(top: mealImage.bottomAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingleft: 20, paddingRight: 20, width: 0, height: 0)
        
        mealDescription.constraints(top: mealName.bottomAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 10, paddingBottom: 0, paddingleft: 20, paddingRight: 20, width: 0, height: 0)
        
        addToCartButton.constraints(top: nil, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 0, paddingBottom: 20, paddingleft: 20, paddingRight: 20, width: 0, height: 40)
        
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
        addToCartButton.layer.borderWidth = 0.2
        addToCartButton.layer.cornerCurve = .continuous
        addToCartButton.layer.cornerRadius = 20
        //addToCartButton.showsTouchWhenHighlighted = true
        
        //TEMP DATA//
        mealDescription.text = "Cook the quinoa following the pack instructions, then rinse in cold water and drain thoroughly. Meanwhile, mix the butter, chilli and garlic into a paste. Toss the chicken fillets in 2 tsp of the olive oil with some seasoning."
        //________//
        
    }
    
    @objc func dismissView(){
        
        self.dismiss(animated: true, completion: nil)
    }
}
