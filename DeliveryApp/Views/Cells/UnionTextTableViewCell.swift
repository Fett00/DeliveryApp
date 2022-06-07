//
//  UnionTextTableViewCell.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 13.04.2022.
//

import UIKit

class UnionTextTableViewCell: UITableViewCell {

    static var id: String { CategoryCollectionViewCell.description() }//идентификатор ячейки
    
    enum CellType{ //Тип ячейки (верняя, нижняя или центральная)
        
        case header
        case middle
        case footer
        case single
    }
    
    //Поле для ввода текста
    private let textField: UITextField = {
        
        let textField = UITextField()
        
        textField.font = UIFont.preferredFont(forTextStyle: .title2)
        textField.backgroundColor = .secondarySystemFill
        textField.textAlignment = .center
        return textField
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell(){
        
        self.addSubview(textField)
        
        self.clipsToBounds = true
        self.layer.cornerCurve = .continuous
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        textField.frame = self.contentView.bounds
    }
    
    func setUpCell(model: ProfileTextFieldModel, textFieldDelegate: UITextFieldDelegate, cellType: UnionTextTableViewCell.CellType){
        
        textField.placeholder = model.placeholder
        textField.textContentType = model.contentType
        textField.delegate = textFieldDelegate
        
        switch cellType{
            
        case .footer:
            self.layer.cornerRadius = 10
            self.layer.maskedCorners = [ .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            
        case .header:
            self.layer.cornerRadius = 10
            self.layer.maskedCorners = [ .layerMaxXMinYCorner, .layerMaxXMinYCorner]
            
        case .middle:
            self.layer.maskedCorners = [ .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            
        case .single:
            self.layer.cornerRadius = 10
        }
    }
    
    func startTextEditing(){
        
        textField.becomeFirstResponder()
    }
}

/* для контроллера
 
 let totalRows = tableView.numberOfRows(inSection: indexPath.section)
 if totalRows == 1 {
     cellPosition = .single
 } else if indexPath.row == 0 {
     cellPosition = .top
 } else if indexPath.row == totalRows - 1 {
     cellPosition = .bottom
 } else {
     cellPosition = .middle
 }
 */
