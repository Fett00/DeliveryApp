//
//  ProfileViewController.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 14.02.2022.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let userDefaultWorker: UserDefaultsWorkerProtocol //объект для работы с user defaults
    
    private let avatarImageView: UIImageView = { //Аватар ↓
        
        let view = UIImageView()
        
        view.image = Images.avatar
        view.contentMode = .scaleAspectFill
        view.layer.cornerCurve = .continuous
        //view.layer.cornerRadius = 20
        view.clipsToBounds = true
        //view.layer.masksToBounds = true
        view.backgroundColor = .white
        
        return view
    }()
    
    private let nameTextField: UITextField = {  //Поле ввода имени
        
        let textField = UITextField()
        
        textField.placeholder = "Name"
        textField.font = UIFont.preferredFont(forTextStyle: .title2)
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .secondarySystemFill
        textField.textContentType = .name
        
        return textField
    }()
    
    private let phoneNumberTextField: UITextField = { //Поле ввода телефона
        
        let textField = UITextField()
        
        textField.placeholder = "Phone"
        textField.font = UIFont.preferredFont(forTextStyle: .title2)
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .secondarySystemFill
        textField.textContentType = .telephoneNumber
        
        return textField
    }()
    
    private let cityTextField: UITextField = { //Поле ввода города
        
        let textField = UITextField()
        
        textField.placeholder = "City"
        textField.font = UIFont.preferredFont(forTextStyle: .title2)
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .secondarySystemFill
        textField.textContentType = .addressCity
        
        return textField
    }()
    
    private let streetTextField: UITextField = { //Поле ввода улицы
        
        let textField = UITextField()
        
        textField.placeholder = "Street"
        textField.font = UIFont.preferredFont(forTextStyle: .title2)
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .secondarySystemFill
        textField.textContentType = .streetAddressLine1
        
        return textField
    }()
    
    private let homeTextField: UITextField = { //Поле ввода дома
        
        let textField = UITextField()
        
        textField.placeholder = "Home"
        textField.font = UIFont.preferredFont(forTextStyle: .title2)
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .secondarySystemFill
        textField.textContentType = .streetAddressLine2
        
        return textField
    }()
    
    private let apartmentTextField: UITextField = { //Поле ввода номера квартиры
        
        let textField = UITextField()
        
        textField.placeholder = "Apartment (optional)"
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
    
    private func confView(){
        
        view.backgroundColor = .systemBackground
        
        self.navigationItem.title = "Personal Info"
        
        self.hideKeyboardWhenTappedAround()
    }
    
    private func confSubview(){
        
        nameTextField.delegate = self
        phoneNumberTextField.delegate = self
        cityTextField.delegate = self
        streetTextField.delegate = self
        homeTextField.delegate = self
        apartmentTextField.delegate = self
        
        view.addSubview(avatarImageView, nameTextField, phoneNumberTextField, cityTextField, streetTextField, homeTextField, apartmentTextField)
        
        let safeArea = view.safeAreaLayoutGuide
        
        avatarImageView.constraints(top: safeArea.topAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: nil, paddingTop: 20, paddingBottom: 0, paddingleft: 20, paddingRight: 0, width: 0, height: 0)
        avatarImageView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 1/3).isActive = true
        avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor).isActive = true
        
        nameTextField.constraints(top: nil, bottom: nil, leading: avatarImageView.trailingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingleft: 20, paddingRight: 20, width: 0, height: 0)
        nameTextField.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
        
        phoneNumberTextField.constraints(top: avatarImageView.bottomAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingleft: 20, paddingRight: 20, width: 0, height: 0)
        
        cityTextField.constraints(top: phoneNumberTextField.bottomAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingleft: 20, paddingRight: 20, width: 0, height: 0)
        
        streetTextField.constraints(top: cityTextField.bottomAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingleft: 20, paddingRight: 20, width: 0, height: 0)
        
        homeTextField.constraints(top: streetTextField.bottomAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingleft: 20, paddingRight: 20, width: 0, height: 0)
        
        apartmentTextField.constraints(top: homeTextField.bottomAnchor, bottom: nil, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 20, paddingBottom: 0, paddingleft: 20, paddingRight: 20, width: 0, height: 0)
        
        let apartmentBottomAnchor = apartmentTextField.bottomAnchor.constraint(greaterThanOrEqualTo: safeArea.bottomAnchor, constant: -20)
        apartmentBottomAnchor.priority = .defaultHigh
    }
    
    override func viewDidLayoutSubviews() {
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
    }
    
    private func loadDataFromUserDefaults(){
        
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
        userDefaultWorker.getStringValue(withKey: UserDefaultsKeys.apartment.rawValue) { apartment in
            
            self.apartmentTextField.text = apartment
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
        case apartmentTextField:
            userDefaultWorker.setStringValue(withKey: UserDefaultsKeys.apartment.rawValue, value: apartmentTextField.text!) {}
        default:
            break
        }
    }
}
