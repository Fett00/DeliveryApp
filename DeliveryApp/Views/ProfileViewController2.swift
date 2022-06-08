//
//  ProfileViewController.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 14.02.2022.
//

import UIKit

final class ProfileViewController2: UIViewController {
    
    private let textFieldDataSource: [ProfileTextFieldModel] = [
    
        .init(contentType: .name, placeholder: "Name"),
        .init(contentType: .telephoneNumber, placeholder: "Phone"),
        .init(contentType: .addressCity, placeholder: "City"),
        .init(contentType: .streetAddressLine1, placeholder: "Street"),
        .init(contentType: .streetAddressLine2, placeholder: "Home"),
        .init(contentType: .streetAddressLine2, placeholder: "Apartment(optional)")
    ]
    
    private let userDefaultWorker: UserDefaultsWorkerProtocol //объект для работы с user defaults
    
    private let avatarImageView: UIImageView = { //Аватар ↓
        
        let view = UIImageView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.image = Images.avatar
        view.contentMode = .scaleAspectFill
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        
        return view
    }()
    
    private let textFieldsTableView: UITableView = {
        
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UnionTextTableViewCell.self, forCellReuseIdentifier: UnionTextTableViewCell.id)
        tableView.isScrollEnabled = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //loadDataFromUserDefaults()
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
        
        view.addSubview(textFieldsTableView, avatarImageView)
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        
        textFieldsTableView.dataSource = self
        
        NSLayoutConstraint.activate([
        
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            avatarImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/3),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),
            
            textFieldsTableView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            textFieldsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textFieldsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            textFieldsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
        ])
    }
}
    
extension ProfileViewController2: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        textFieldDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UnionTextTableViewCell.id, for: indexPath) as? UnionTextTableViewCell else { return UITableViewCell() }
        
        var cellType: UnionTextTableViewCell.CellType
        let totalRows = tableView.numberOfRows(inSection: 0)
        
        if totalRows == 1{
            
            cellType = .single
        }
        else if indexPath.row == 0{
            
            cellType = .header
        }
        else if indexPath.row == totalRows - 1{
            
            cellType = .footer
        }
        else{
            
            cellType = .middle
        }
        
        cell.setUpCell(model: textFieldDataSource[indexPath.row], textFieldDelegate: self, cellType: cellType)
        
        return cell
    }
}

extension ProfileViewController2: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        guard let cell = textFieldsTableView.cellForRow(at: indexPath) as? UnionTextTableViewCell else { return nil }
        
        cell.startTextEditing()
        
        return nil
    }
}

extension ProfileViewController2: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        
    }
}
