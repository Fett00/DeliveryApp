//
//  MealCollectionViewCell.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 05.12.2021.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let id = "CategoryCellID" //идентификатор ячейки
    
    let categoryLable = UILabel() //Название категории
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(categoryLable)
        
        categoryLable.constraints(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingleft: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpCell(with category: CategoryModel){
        
        categoryLable.text = category.strCategory
    }
}
