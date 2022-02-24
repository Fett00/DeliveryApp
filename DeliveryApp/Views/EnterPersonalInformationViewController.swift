//
//  EnterPersonalInformationViewController.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 16.02.2022.
//

import UIKit

enum KeyChainKeys: String{
    
    case home = "home"
    case street = "street"
    case city = "city"
    case name = "name"
    case apartament = "apartament"
}

class EnterPersonalInformationViewController: UIViewController {
    
    let nameTextField: UITextField = {  //Поле ввода имени
        
        let textField = UITextField()
        
        textField.placeholder = "Name"
        textField.font = UIFont.preferredFont(forTextStyle: .title2)
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .secondarySystemFill
        textField.textContentType = .name
        textField.becomeFirstResponder()
        
        return textField
    }()
    
    let phoneNumberTextField: UITextField = { //Поле ввода телефона
        
        let textField = UITextField()
        
        textField.placeholder = "Phone"
        textField.font = UIFont.preferredFont(forTextStyle: .title2)
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .secondarySystemFill
        textField.textContentType = .telephoneNumber
        
        return textField
    }()
    
    let cityTextField: UITextField = { //Поле ввода города
        
        let textField = UITextField()
        
        textField.placeholder = "City"
        textField.font = UIFont.preferredFont(forTextStyle: .title2)
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .secondarySystemFill
        textField.textContentType = .addressCity
        
        return textField
    }()
    
    let streetTextField: UITextField = { //Поле ввода улицы
        
        let textField = UITextField()
        
        textField.placeholder = "Street"
        textField.font = UIFont.preferredFont(forTextStyle: .title2)
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .secondarySystemFill
        textField.textContentType = .streetAddressLine1
        
        return textField
    }()
    
    let homeTextField: UITextField = { //Поле ввода имени
        
        let textField = UITextField()
        
        textField.placeholder = "Home"
        textField.font = UIFont.preferredFont(forTextStyle: .title2)
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .secondarySystemFill
        textField.textContentType = .streetAddressLine2
        
        return textField
    }()
    
    let apartamentTextField: UITextField = { //Поле ввода номера квартиры
        
        let textField = UITextField()
        
        textField.placeholder = "Apartament (optional)"
        textField.font = UIFont.preferredFont(forTextStyle: .title2)
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .secondarySystemFill
        textField.textContentType = .streetAddressLine2
        
        return textField
    }()
    
    let buyButton: UIButton = { //Кнопка оплаты покупки
        
        let button = UIButton()
        
        button.setTitle(" Buy", for: .normal)
        button.backgroundColor = .black
        button.layer.borderWidth = 0.5
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(requestBuying), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confView()
        confSubview()
    }
    
    init(){
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func confView(){
        
        view.backgroundColor = .systemBackground
        
        self.navigationItem.title = "Personal Info"
        
        self.hideKeyboardWhenTappedAround()
        
        let doneButton = UIBarButtonItem(image: Images.backArrow, style: .done, target: self, action: #selector(backToCart))
        self.navigationItem.leftBarButtonItem = doneButton
    }
    
    func confSubview(){
        
        let globalStack = UIStackView()
        let secStack = UIStackView()
        let thdStack = UIStackView()
        
        view.addSubview(globalStack, buyButton)
        globalStack.addArrangedSubview(nameTextField)
        globalStack.addArrangedSubview(phoneNumberTextField)
        globalStack.addArrangedSubview(secStack)
        globalStack.addArrangedSubview(thdStack)
        secStack.addArrangedSubview(cityTextField)
        secStack.addArrangedSubview(streetTextField)
        thdStack.addArrangedSubview(homeTextField)
        thdStack.addArrangedSubview(apartamentTextField)
        
        globalStack.axis = .vertical
        globalStack.alignment = .fill
        globalStack.distribution = .fillEqually
        globalStack.spacing = 20
        secStack.axis = .horizontal
        secStack.alignment = .fill
        secStack.distribution = .fillEqually
        secStack.spacing = 20
        thdStack.axis = .horizontal
        thdStack.alignment = .fill
        thdStack.distribution = .fillEqually
        thdStack.spacing = 20

        globalStack.constraints(top: view.safeAreaLayoutGuide.topAnchor, bottom: view.safeAreaLayoutGuide.centerYAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 40, paddingBottom: 0, paddingleft: 40, paddingRight: 40, width: 0, height: 0)
        
        buyButton.constraints(top: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 30, paddingleft: 40, paddingRight: 40, width: 0, height: 60)
    }
    
    @objc func backToCart(){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func requestBuying(){
        
        if nameTextField.text!.isEmpty || phoneNumberTextField.text!.isEmpty || cityTextField.text!.isEmpty || streetTextField.text!.isEmpty || homeTextField.text!.isEmpty{
            
            let alert = UIAlertController(title: "Fill all fields!", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                
                alert.dismiss(animated: true)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        else{
            
        }
    }
}
