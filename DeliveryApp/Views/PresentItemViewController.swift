//
//  PresentItemView.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 05.12.2021.
//

import UIKit

class PresentMealViewController: UIViewController{
    
    let meal: MealModel
    
    let mealImage = UIImageView()
    let mealName = UILabel()
    let addToCartButton = UIButton()
    let mealDescription = UILabel()
    let bar = UINavigationBar()
    
    init(meal: MealModel) {
        
        self.meal = meal
        
        super.init(nibName: nil, bundle: nil)
    }
    
    init(){ //TEMP INIT
        
        self.meal = .init(strMeal: "", strMealThumb: "", idMeal: "")
       
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureView()
    }
    
    func configureView(){
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dissmisView))
        let navigationItem = UINavigationItem()
        navigationItem.rightBarButtonItem = doneButton
        
        bar.items = [navigationItem]

        view.addSubview(mealImage, mealName, mealDescription, addToCartButton, bar)
        
        let safeArea = view.safeAreaLayoutGuide
        
        bar.constraints(top: safeArea.topAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingleft: 0, paddingRight: 0, width: 0, height: 0)
        
        mealImage.constraints(top: bar.bottomAnchor, bottom: safeArea.centerYAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 10, paddingBottom: 0, paddingleft: 10, paddingRight: 10, width: 0, height: 0)
        
        mealName.constraints(top: mealImage.bottomAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingleft: 20, paddingRight: 20, width: 0, height: 0)
        
        mealDescription.constraints(top: mealName.bottomAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 10, paddingBottom: 0, paddingleft: 20, paddingRight: 20, width: 0, height: 0)
        
        addToCartButton.constraints(top: nil, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 0, paddingBottom: 20, paddingleft: 20, paddingRight: 20, width: 0, height: 40)
        
        addToCartButton.topAnchor.constraint(greaterThanOrEqualTo: mealDescription.bottomAnchor, constant: 20).isActive = true
        
        mealImage.tintColor = .systemGray3
        mealImage.contentMode = .scaleAspectFit
        
        mealName.setContentHuggingPriority(.defaultHigh, for: .vertical)
        mealName.font = UIFont.preferredFont(forTextStyle: .title1)
        mealName.numberOfLines = 3
        
        mealDescription.numberOfLines = 0
        
        addToCartButton.setTitleColor(.label, for: .normal)
        addToCartButton.layer.borderWidth = 0.2
        addToCartButton.layer.cornerCurve = .continuous
        addToCartButton.layer.cornerRadius = 20
        //addToCartButton.showsTouchWhenHighlighted = true
        
        mealName.text = meal.strMeal
        
        //TEMP DATA//
        mealImage.image = Images.emptyMeal
        mealDescription.text = "Пицца 4 сыра относится к так называемому типу белых пицц («pizza Bianca»), т.е. в неё не кладётся традиционный для большинства пицц томатный соус и помидоры. Самое главное тут сыры, а точнее их сочетание. Здесь важно, чтобы у вас присутствовали четыре разных типа сыров: мягкий, твердый, ароматный (пряный) и голубой сыры. "
        addToCartButton.setTitle("\(Int.random(in: 100...4000))₽", for: .normal)
        //________//
    }
    
    @objc func dissmisView(){
        
        self.dismiss(animated: true, completion: nil)
    }
}
