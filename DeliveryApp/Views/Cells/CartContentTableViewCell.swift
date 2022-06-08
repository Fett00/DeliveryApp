//
//  CartContentTableViewCell.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 15.02.2022.
//

import UIKit

class CartContentTableViewCell: UITableViewCell, IndexPathCollector {
    
    var indexPath: IndexPath = IndexPath()

    static var id: String { CartContentTableViewCell.description() }
    
    //картинка блюда в корзине
    private let mealImage: UIImageView = {
        
        let imageView = UIImageView()
        
        imageView.image = Images.emptyMeal
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerCurve = .continuous
        imageView.layer.cornerRadius = 10
        
        return imageView
    }()
    
    //названия блюда в корзине
    private let mealName: UILabel = {
        
        let label = UILabel()
        
        label.text = "Chiken & mushroom hotpot"
        label.numberOfLines = 2
        label.font = UIFont.preferredFont(forTextStyle: .title3, compatibleWith: .none)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        //label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    
    //Показывает кол-во штук для одного блюда
    private let mealCount: UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont.preferredFont(forTextStyle: .title2, compatibleWith: .none)
        label.textAlignment = .center
        
        return label
    }()
    
    //Ценник блюда
    private let mealPrice: UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont.preferredFont(forTextStyle: .title2, compatibleWith: .none)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        return label
    }()
    
    //Кнопка увеличения кол-ва блюд
    private let increaseButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle("+", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 10
        button.backgroundColor = .secondarySystemFill
        button.addTarget(nil, action: Selector(("increaseMealCount:")), for: .touchUpInside)
        
        return button
    }()
    
    //Кнопка уменьшения кол-ва блюд
    private let decreaseButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle("-", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 10
        button.backgroundColor = .secondarySystemFill
        button.addTarget(nil, action: Selector(("decreaseMealCount:")), for: .touchUpInside)
        
        return button
    }()
    
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
        
        mealCount.constraints(top: nil, bottom: nil, leading: decreaseButton.trailingAnchor, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingleft: 15, paddingRight: 0, width: 40, height: 0)
        mealCount.centerYAnchor.constraint(equalTo: decreaseButton.centerYAnchor).isActive = true
        
        increaseButton.constraints(top: mealImage.centerYAnchor, bottom: self.contentView.bottomAnchor, leading: mealCount.trailingAnchor, trailing: nil, paddingTop: 15, paddingBottom: 10, paddingleft: 15, paddingRight: 0, width: 0, height: 0)
        increaseButton.widthAnchor.constraint(equalTo: decreaseButton.heightAnchor, multiplier: 1/1).isActive = true
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
        
        mealImage.image = nil
        mealName.text = ""
        mealPrice.text = ""
        mealCount.text = "1"
    }
}
