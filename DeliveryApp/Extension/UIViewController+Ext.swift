//
//  UIViewController+Ext.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 17.02.2022.
//

import UIKit

//Спрятать клавиатуру при тапе в любом месте
extension UIViewController{
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
