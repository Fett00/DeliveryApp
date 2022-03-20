//
//  MealCollectionViewCell.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 05.12.2021.
//

import UIKit

class MealCollectionViewCell: UICollectionViewCell, IndexPathCollector {
    
    //indexpath для связи с данными
    var indexPath: IndexPath = IndexPath()
    
    static var id: String { MealCollectionViewCell.description() }//идентификатор ячейки
    
    private let mealImage: UIImageView = {
        
        let imageView = UIImageView()
        
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerCurve = .continuous
        imageView.layer.cornerRadius = 20
        imageView.image = Images.emptyMeal //placeholder
        
        return imageView
    }()
    
    private let mealName: UILabel = {
        
        let label = UILabel()
        
        label.textAlignment = .left
        label.numberOfLines = 3
        label.setContentCompressionResistancePriority( .defaultHigh, for: .vertical)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        label.setContentCompressionResistancePriority( .defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    
    private let addToCartButton: UIButton = {
       
        let button = UIButton()
        
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemFill
        button.layer.borderWidth = 0.5
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 20
        button.addTarget(nil, action: Selector(("addToCart:")), for: .touchUpInside)
        
        return button
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = .secondarySystemBackground
        
        confCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let cellFrame = self.bounds
        let buttonHeight = 50.0
        let lableHeight = mealName.font.lineHeight * 3
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
        
        mealImage.translatesAutoresizingMaskIntoConstraints = false
        mealName.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setUpCell(with meal: MealModel, indexPath: IndexPath){
        
        self.indexPath = indexPath
        self.mealName.text = meal.strMeal
        self.addToCartButton.setTitle("\(meal.price) ₽", for: .normal)
    }
    
    func setUpImage(with image: UIImage){
        
        mealImage.image = image
    }
    
    override func prepareForReuse() {
        
        mealImage.image = nil//Images.emptyMeal
        mealName.text = ""
        addToCartButton.setTitle("", for: .normal)
    }
}
