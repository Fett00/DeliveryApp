//
//  EnterPersonalInformationViewController.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 16.02.2022.
//

import UIKit

class EnterPersonalInformationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //confView()
    }
    
    init(){
        super.init(nibName: nil, bundle: nil)
        confView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func confView(){
        
        view.backgroundColor = .systemBackground
        
        let doneButton = UIBarButtonItem(image: Images.backArrow, style: .done, target: self, action: #selector(backToCart))
        self.navigationItem.leftBarButtonItem = doneButton
    }
    
    @objc func backToCart(){
        
        self.navigationController?.popViewController(animated: true)
    }
}
