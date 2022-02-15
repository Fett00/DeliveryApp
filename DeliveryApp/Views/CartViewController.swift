//
//  CartViewController.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 19.01.2022.
//

import UIKit

class CartViewController: UIViewController {
    
    let dataWorker: DataWorkerForCartProtocol //Объект для запроса данных
    let imageWorker: ImageWorker
    let data: DataWorkerCollectedDataForCartProtocol //Данные для заполнения корзины
    
    let cartContentTableView = UITableView() //Таблица с содержимым корзины
    
    let totalAmountView = UIView() //Вью с итоговой суммой
    let totalAmountLable = UILabel() // Лейбл на котором написана общая сумма
    let totalAmountButton = UIButton() // Кнопка оплаты рядом с общей суммой
    
    init(dataWorker: DataWorkerForCartProtocol, data: DataWorkerCollectedDataForCartProtocol, imageWorker: ImageWorker){
        
        self.dataWorker = dataWorker
        self.data = data
        self.imageWorker = imageWorker
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCartViewController()
        configureCartContentTableView()
        configureTotalAmount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadMeals()
    }
    
    func configureCartViewController(){
        
        view.backgroundColor = .systemBackground
        self.navigationItem.title = "Cart"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let doneButton = UIBarButtonItem(image: Images.backArrow, style: .done , target: self, action: #selector(closeView))
        let clearCartButton = UIBarButtonItem(image: Images.trash, style: .plain, target: self, action: #selector(requestClearCart))
        
        self.navigationItem.leftBarButtonItem = doneButton
        self.navigationItem.rightBarButtonItem = clearCartButton
    }
    
    func configureCartContentTableView(){
        
        view.addSubview(cartContentTableView)
        
        cartContentTableView.dataSource = self
        cartContentTableView.delegate = self
        cartContentTableView.register(CartContentTableViewCell.self, forCellReuseIdentifier: CartContentTableViewCell.id)
        
        cartContentTableView.rowHeight = UITableView.automaticDimension
        
        cartContentTableView.constraints(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingleft: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    func configureTotalAmount(){
        
        view.addSubview(totalAmountView)
        totalAmountView.addSubview(totalAmountLable, totalAmountButton)
        
        totalAmountView.constraints(top: cartContentTableView.bottomAnchor, bottom: view.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingleft: 0, paddingRight: 0, width: 0, height: 0)
        
        totalAmountLable.constraints(top: nil, bottom: nil, leading: totalAmountView.leadingAnchor, trailing: totalAmountButton.leadingAnchor, paddingTop: 0, paddingBottom: 0, paddingleft: 30, paddingRight: 20, width: 0, height: 0)
        totalAmountLable.centerYAnchor.constraint(equalTo: totalAmountButton.centerYAnchor).isActive = true
        
        totalAmountButton.constraints(top: totalAmountView.topAnchor, bottom: totalAmountView.bottomAnchor, leading: totalAmountView.centerXAnchor, trailing: totalAmountView.trailingAnchor, paddingTop: 10, paddingBottom: 30, paddingleft: -40, paddingRight: 30, width: 0, height: 60)
        
        totalAmountView.backgroundColor = Colors.mainColor
        
        totalAmountButton.setTitle("Buy", for: .normal)
        totalAmountButton.setTitleColor(.black, for: .normal)
        totalAmountButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2, compatibleWith: .none)
        totalAmountButton.backgroundColor = .secondarySystemBackground
        totalAmountButton.layer.borderWidth = 0.2
        totalAmountButton.layer.cornerCurve = .continuous
        totalAmountButton.layer.cornerRadius = 20
        
        totalAmountLable.font = UIFont.preferredFont(forTextStyle: .title2, compatibleWith: .none)
    }
    
    func loadMeals(){
        
        //Почему не происходит retain cycle
        self.dataWorker.requestCartContent {
            
            self.cartContentTableView.reloadData()
            self.totalAmountLable.text = String(self.data.cartContent.reduce(into: 0, { partialResult, cartContent in
                partialResult += cartContent.price
            })) + " ₽"
        }
    }
    
    @objc func requestClearCart(){
        
        dataWorker.requestClearCart {
            
            self.cartContentTableView.reloadData()
            print("try reload cart")
        }
    }
    
    @objc func closeView(){
        
        self.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("Cart deinit")
    }
}

extension CartViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        data.cartContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartContentTableViewCell.id, for: indexPath) as? CartContentTableViewCell else { return UITableViewCell() }
        
        cell.setUpCell(meal: data.cartContent[indexPath.row])
        
        imageWorker.requestImage(on: data.cartContent[indexPath.row].imageURL) { image in
            
            cell.setUpCellImage(image: image)
        }
        
        return cell
    }
}

extension CartViewController: UITableViewDelegate{
    
}


