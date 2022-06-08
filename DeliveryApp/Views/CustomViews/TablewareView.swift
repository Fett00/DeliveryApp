//
//  TablewareView.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 08.06.2022.
//

import UIKit

class TablewareView: UIView {
    
    private var wareCounter = 0 {
        
        didSet {
            
            wareCount.text = "\(wareCounter)"
        }
    }
    
    //картинка блюда в корзине
    private let wareImage: UIImageView = {
        
        let imageView = UIImageView()
        
        imageView.tintColor = .systemGray3
        imageView.clipsToBounds = true
        imageView.contentMode = .center
        imageView.layer.cornerCurve = .continuous
        imageView.layer.cornerRadius = 10
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold )
        let image = UIImage(systemName: "fork.knife", withConfiguration: imageConfig)
        imageView.image = image
        imageView.preferredSymbolConfiguration = imageConfig
        imageView.tintColor = .label
        imageView.backgroundColor = .tertiarySystemFill
        
        return imageView
    }()
    
    //названия блюда в корзине
    private let wareDescription: UILabel = {
        
        let label = UILabel()
        
        label.text = "Appliances and napkins"
        label.font = UIFont.preferredFont(forTextStyle: .title3, compatibleWith: .none)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        //label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    
    //Показывает кол-во штук для одного блюда
    private let wareCount: UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont.preferredFont(forTextStyle: .title2, compatibleWith: .none)
        label.textAlignment = .center
        label.text = "0"
        
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
        button.addTarget(self, action: Selector(("increaseWareCount")), for: .touchUpInside)
        
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
        button.addTarget(self, action: Selector(("decreaseWareCount")), for: .touchUpInside)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configurateView()
        configurateSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurateView(){
        
        self.clipsToBounds = true
    }
    
    private func configurateSubview(){
        
        self.addSubview(wareDescription, wareImage, wareCount, increaseButton, decreaseButton)
        
        wareImage.constraints(top: self.topAnchor, bottom: self.bottomAnchor, leading: self.leadingAnchor, trailing: nil, paddingTop: 20, paddingBottom: 30, paddingleft: 30, paddingRight: 0, width: 80, height: 80)
        
        wareDescription.constraints(top: self.topAnchor, bottom: nil, leading: wareImage.trailingAnchor, trailing: nil, paddingTop: 10, paddingBottom: 0, paddingleft: 20, paddingRight: 0, width: 0, height: 0)
        
        decreaseButton.constraints(top: wareImage.centerYAnchor, bottom: self.bottomAnchor, leading: wareImage.trailingAnchor, trailing: nil, paddingTop: 15, paddingBottom: 10, paddingleft: 20, paddingRight: 0, width: 0, height: 0)
        decreaseButton.widthAnchor.constraint(equalTo: increaseButton.heightAnchor, multiplier: 1/1).isActive = true
        decreaseButton.topAnchor.constraint(greaterThanOrEqualTo: wareDescription.bottomAnchor, constant: 10).isActive = true
        
        wareCount.constraints(top: nil, bottom: nil, leading: decreaseButton.trailingAnchor, trailing: nil, paddingTop: 0, paddingBottom: 0, paddingleft: 15, paddingRight: 0, width: 40, height: 0)
        wareCount.centerYAnchor.constraint(equalTo: decreaseButton.centerYAnchor).isActive = true
        
        increaseButton.constraints(top: wareImage.centerYAnchor, bottom: self.bottomAnchor, leading: wareCount.trailingAnchor, trailing: nil, paddingTop: 15, paddingBottom: 10, paddingleft: 15, paddingRight: 0, width: 0, height: 0)
        increaseButton.widthAnchor.constraint(equalTo: decreaseButton.heightAnchor, multiplier: 1/1).isActive = true
    }
    
    @objc private func decreaseWareCount(){
        
        if self.wareCounter != 0{
            
            self.wareCounter -= 1
        }
    }
    
    @objc private func increaseWareCount(){
        
        self.wareCounter += 1
    }
}
