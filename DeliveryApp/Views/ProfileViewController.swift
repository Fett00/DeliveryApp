//
//  ProfileViewController.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 14.02.2022.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    let userDefaultWorker: UserDefaultsWorkerProtocol //объект для работы с user defaults
    
    let avatarImageView: UIImageView = { //Аватар ↓
        
        let view = UIImageView()
        
        view.image = Images.avatar
        view.contentMode = .scaleAspectFill
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        
        return view
    }()
    
    let nameTextField: UITextField = {  //Поле ввода имени
        
        let textField = UITextField()
        
        textField.placeholder = "Name"
        textField.font = UIFont.preferredFont(forTextStyle: .title2)
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .secondarySystemFill
        textField.textContentType = .name
        
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
    
    let homeTextField: UITextField = { //Поле ввода дома
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confView()
        confSubview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDataFromUserDefaults()
    }
    
    init(userDefaultsWorker: UserDefaultsWorkerProtocol){
        
        self.userDefaultWorker = userDefaultsWorker
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func confView(){
        
        view.backgroundColor = .systemBackground
        
        self.navigationItem.title = "Personal Info"
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func confSubview(){
        
        nameTextField.delegate = self
        phoneNumberTextField.delegate = self
        cityTextField.delegate = self
        streetTextField.delegate = self
        homeTextField.delegate = self
        apartamentTextField.delegate = self
        
        view.addSubview(avatarImageView, nameTextField, phoneNumberTextField, cityTextField, streetTextField, homeTextField, apartamentTextField)
        
        let safeArea = view.safeAreaLayoutGuide
        
        avatarImageView.constraints(top: safeArea.topAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: nil, paddingTop: 20, paddingBottom: 0, paddingleft: 20, paddingRight: 0, width: 0, height: 0)
        avatarImageView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 1/3).isActive = true
        avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor, multiplier: 28/25).isActive = true
        
        nameTextField.constraints(top: safeArea.topAnchor, bottom: nil, leading: avatarImageView.trailingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingleft: 20, paddingRight: 20, width: 0, height: 0)
        
        phoneNumberTextField.constraints(top: avatarImageView.bottomAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingleft: 20, paddingRight: 20, width: 0, height: 0)
        
        cityTextField.constraints(top: phoneNumberTextField.bottomAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingleft: 20, paddingRight: 20, width: 0, height: 0)
        
        streetTextField.constraints(top: cityTextField.bottomAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingleft: 20, paddingRight: 20, width: 0, height: 0)
        
        homeTextField.constraints(top: streetTextField.bottomAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingleft: 20, paddingRight: 20, width: 0, height: 0)
        
        apartamentTextField.constraints(top: homeTextField.bottomAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingleft: 20, paddingRight: 20, width: 0, height: 0)
        
        let buttomAnchor = apartamentTextField.bottomAnchor.constraint(greaterThanOrEqualTo: safeArea.bottomAnchor, constant: -20)
        buttomAnchor.priority = .defaultHigh
        //apartamentTextField.bottomAnchor.constraint(greaterThanOrEqualTo: safeArea.bottomAnchor, constant: -20).isActive = true
        
        
//        nameTextField.setContentHuggingPriority(.defaultHigh, for: .vertical)
//        phoneNumberTextField.setContentHuggingPriority(.defaultHigh, for: .vertical)
//        cityTextField.setContentHuggingPriority(.defaultHigh, for: .vertical)
//        streetTextField.setContentHuggingPriority(.defaultHigh, for: .vertical)
//        homeTextField.setContentHuggingPriority(.defaultHigh, for: .vertical)
//        apartamentTextField.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    func loadDataFromUserDefaults(){
        
        userDefaultWorker.getStringValue(withKey: UserDefaultsKeys.name.rawValue) { name in
            
            self.nameTextField.text = name
        }
        userDefaultWorker.getStringValue(withKey: UserDefaultsKeys.phone.rawValue) { phone in
            
            self.phoneNumberTextField.text = phone
        }
        userDefaultWorker.getStringValue(withKey: UserDefaultsKeys.city.rawValue) { city in
            
            self.cityTextField.text = city
        }
        userDefaultWorker.getStringValue(withKey: UserDefaultsKeys.street.rawValue) { street in
            
            self.streetTextField.text = street
        }
        userDefaultWorker.getStringValue(withKey: UserDefaultsKeys.home.rawValue) { home in
            
            self.homeTextField.text = home
        }
        userDefaultWorker.getStringValue(withKey: UserDefaultsKeys.apartament.rawValue) { apartament in
            
            self.apartamentTextField.text = apartament
        }
    }
}

extension ProfileViewController: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        print("Save changes")
        
        //ужос😱
        switch textField{
            
        case nameTextField:
            userDefaultWorker.setStringValue(withKey: UserDefaultsKeys.name.rawValue, value: nameTextField.text!) {}
        case phoneNumberTextField:
            userDefaultWorker.setStringValue(withKey: UserDefaultsKeys.phone.rawValue, value: phoneNumberTextField.text!) {}
        case cityTextField:
            userDefaultWorker.setStringValue(withKey: UserDefaultsKeys.city.rawValue, value: cityTextField.text!) {}
        case streetTextField:
            userDefaultWorker.setStringValue(withKey: UserDefaultsKeys.street.rawValue, value: streetTextField.text!) {}
        case homeTextField:
            userDefaultWorker.setStringValue(withKey: UserDefaultsKeys.home.rawValue, value: homeTextField.text!) {}
        case apartamentTextField:
            userDefaultWorker.setStringValue(withKey: UserDefaultsKeys.apartament.rawValue, value: apartamentTextField.text!) {}
        default:
            break
        }
    }
}
