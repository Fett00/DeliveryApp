//
//  CartContentTableViewCell.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 15.02.2022.
//

import UIKit

class CartContentTableViewCell: UITableViewCell, IndexPathCollector {
    
    var indexPath: IndexPath = IndexPath()

    static let id = CartContentTableViewCell.description()
    
    private let mealImage = UIImageView() //картинка блюда в корзине
    private let mealName = UILabel() //названия блюда в корзине
    private let mealCount = UILabel() //Показывает кол-во штук для одного блюда
    private let mealPrice = UILabel() //Ценник блюда
    private let increaseButton = UIButton() //Кнопка увеличения кол-ва блюд
    private let decreaseButton = UIButton() //Кнопка уменьшения кол-ва блюд
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configurateCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurateCell(){

        self.contentView.addSubview(mealName, mealImage, mealCount, mealPrice, increaseButton, decreaseButton)
        self.contentView.clipsToBounds = true
        self.selectionStyle = .none
        
        mealImage.constraints(top: self.contentView.topAnchor, bottom: self.contentView.bottomAnchor, leading: self.contentView.leadingAnchor, trailing: nil, paddingTop: 20, paddingBottom: 30, paddingleft: 30, paddingRight: 0, width: 80, height: 80)
        
        mealName.constraints(top: self.contentView.topAnchor, bottom: nil, leading: mealImage.trailingAnchor, trailing: nil, paddingTop: 10, paddingBottom: 0, paddingleft: 20, paddingRight: 0, width: 0, height: 0)
        
        mealPrice.constraints(top: self.contentView.topAnchor, bottom: nil, leading: nil, trailing: self.contentView.trailingAnchor, paddingTop: 10, paddingBottom: 0, paddingleft: 10, paddingRight: 20, width: 0, height: 0)
        mealPrice.leadingAnchor.constraint(greaterThanOrEqualTo: mealName.trailingAnchor, constant: 10).isActive = true
        
        decreaseButton.constraints(top: mealImage.centerYAnchor, bottom: self.contentView.bottomAnchor, leading: mealImage.trailingAnchor, trailing: nil, paddingTop: 15, paddingBottom: 10, paddingleft: 20, paddingRight: 0, width: 0, height: 0)
        decreaseButton.widthAnchor.constraint(equalTo: increaseButton.heightAnchor, multiplier: 1/1).isActive = true
        decreaseButton.topAnchor.constraint(greaterThanOrEqualTo: mealName.bottomAnchor, constant: 10).isActive = true
        
        mealCount.constraints(top: nil, bottom: nil, leading: decreaseButton.trailingAnchor, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingleft: 15, paddingRight: 0, width: 0, height: 0)
        mealCount.centerYAnchor.constraint(equalTo: decreaseButton.centerYAnchor).isActive = true
        
        increaseButton.constraints(top: mealImage.centerYAnchor, bottom: self.contentView.bottomAnchor, leading: mealCount.trailingAnchor, trailing: nil, paddingTop: 15, paddingBottom: 10, paddingleft: 15, paddingRight: 0, width: 0, height: 0)
        increaseButton.widthAnchor.constraint(equalTo: decreaseButton.heightAnchor, multiplier: 1/1).isActive = true
        
        mealName.text = "Chiken & mushroom hotpot"
        mealName.numberOfLines = 2
        mealName.font = UIFont.preferredFont(forTextStyle: .title3, compatibleWith: .none)
        mealName.setContentHuggingPriority(.defaultHigh, for: .vertical)
        //mealName.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        mealImage.image = Images.emptyMeal
        mealImage.tintColor = .systemGray3
        mealImage.contentMode = .scaleAspectFill
        mealImage.clipsToBounds = true
        mealImage.layer.cornerCurve = .continuous
        mealImage.layer.cornerRadius = 10
        
        mealPrice.font = UIFont.preferredFont(forTextStyle: .title2, compatibleWith: .none)
        mealPrice.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        //mealPrice.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        //mealPrice.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        mealCount.font = UIFont.preferredFont(forTextStyle: .title2, compatibleWith: .none)
        
        increaseButton.setTitle("+", for: .normal)
        increaseButton.setTitleColor(.label, for: .normal)
        increaseButton.layer.borderWidth = 0.5
        increaseButton.layer.borderColor = UIColor.black.cgColor
        increaseButton.layer.cornerCurve = .continuous
        increaseButton.layer.cornerRadius = 10
        increaseButton.backgroundColor = .secondarySystemBackground
        increaseButton.addTarget(nil, action: Selector(("increaseMealCount:")), for: .touchUpInside)
        
        decreaseButton.setTitle("-", for: .normal)
        decreaseButton.setTitleColor(.label, for: .normal)
        decreaseButton.layer.borderWidth = 0.5
        decreaseButton.layer.borderColor = UIColor.black.cgColor
        decreaseButton.layer.cornerCurve = .continuous
        decreaseButton.layer.cornerRadius = 10
        decreaseButton.backgroundColor = .secondarySystemBackground
        decreaseButton.addTarget(nil, action: Selector(("decreaseMealCount:")), for: .touchUpInside)
    }
    
    func setUpCell(meal: CartContentModel, indexPath: IndexPath){
        
        self.mealName.text = meal.name
        self.mealCount.text = String(meal.count)
        self.mealPrice.text = String(meal.price) + " ₽"
        
        self.indexPath = indexPath
    }
    
    func setUpCellImage(image: UIImage){
        
        mealImage.image = image
    }
    
    override func prepareForReuse() {
        
        mealImage.image = Images.emptyMeal
        mealName.text = ""
        mealPrice.text = ""
        mealCount.text = "1"
    }
}
