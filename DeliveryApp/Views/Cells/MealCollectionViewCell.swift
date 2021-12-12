//
//  MealCollectionViewCell.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 05.12.2021.
//

import UIKit

class MealCollectionViewCell: UICollectionViewCell {
    
    static let id = "MealCellID" //идентификатор ячейки
    
    let mealImage = UIImageView()
    let mealName = UILabel()
    let addToCartButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        confCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        confSubviews()
    }
    
    func confSubviews(){
        
        let cellFrame = self.bounds
        let buttonHeight = 50.0
        let lableHeight = mealName.font.lineHeight * 2
        let originX = 10.0
        let inset = 10.0
        let widthX = cellFrame.maxX - originX * 2
        
        let imageFrame = CGRect(x: originX,
                                y: cellFrame.minY + inset,
                                width: widthX,
                                height: cellFrame.midY)
        
        let nameFrame = CGRect(x: originX + 5,
                               y: imageFrame.maxY + 10,
                               width: widthX - inset,
                               height: lableHeight)
        
        let buttonFrame = CGRect(x: originX,
                                 y: cellFrame.maxY - inset - buttonHeight,
                                 width: widthX,
                                 height: buttonHeight)
        
        mealImage.frame = imageFrame
        mealName.frame = nameFrame
        addToCartButton.frame = buttonFrame
    }
    
    func confCell(){
        
        self.addSubview(mealImage, mealName, addToCartButton)
        
        self.layer.cornerCurve = .continuous
        self.layer.cornerRadius = 20
        
        mealImage.tintColor = .systemGray3
        mealImage.contentMode = .scaleAspectFit//.scaleAspectFill
        mealImage.clipsToBounds = true
        mealImage.layer.cornerCurve = .continuous
        mealImage.layer.cornerRadius = 20
        mealImage.image = Images.emptyMeal //placeholder
        
        mealName.textAlignment = .left
        mealName.numberOfLines = 2
        mealName.setContentCompressionResistancePriority( .defaultHigh, for: .vertical)
        mealName.setContentHuggingPriority(.defaultLow, for: .vertical)
        mealName.setContentCompressionResistancePriority( .defaultHigh, for: .horizontal)
        mealName.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        
        addToCartButton.setTitleColor(.label, for: .normal)
        addToCartButton.backgroundColor = .systemBackground
        addToCartButton.layer.borderWidth = 0.2
        addToCartButton.layer.cornerCurve = .continuous
        addToCartButton.layer.cornerRadius = 20
        //addToCartButton.showsTouchWhenHighlighted = true
        
        mealImage.translatesAutoresizingMaskIntoConstraints = false
        mealName.translatesAutoresizingMaskIntoConstraints = false
        
        //TEMP DATA//
        mealName.text = "Пицца Четыре сыра"
        mealImage.image = Images.emptyMeal
        addToCartButton.setTitle("\(Int.random(in: 100...4000))₽", for: .normal)
        //________//
    }
    
    func setUpCell(with meal: MealModel){
        
        mealName.text = meal.strMeal
        mealImage.image = Images.emptyMeal
        addToCartButton.setTitle("\(Int.random(in: 100...4000))₽", for: .normal)
    }
}