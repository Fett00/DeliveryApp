//
//  CartViewController.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 19.01.2022.
//

import UIKit

final class CartViewController: UIViewController {
    
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
    
    //Конфигурация таблицы с выбранными блюдами
    func configureCartContentTableView(){
        
        view.addSubview(cartContentTableView)
        
        cartContentTableView.dataSource = self
        cartContentTableView.delegate = self
        cartContentTableView.register(CartContentTableViewCell.self, forCellReuseIdentifier: CartContentTableViewCell.id)
        
        cartContentTableView.rowHeight = UITableView.automaticDimension
        
        cartContentTableView.constraints(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingleft: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    //Конфигурация нижнего поля с итоговой суммой заказа
    func configureTotalAmount(){
        
        view.addSubview(totalAmountView)
        totalAmountView.addSubview(totalAmountLable, totalAmountButton)
        
        totalAmountView.constraints(top: cartContentTableView.bottomAnchor, bottom: view.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingleft: 0, paddingRight: 0, width: 0, height: 0)
        
        totalAmountLable.constraints(top: nil, bottom: nil, leading: totalAmountView.leadingAnchor, trailing: totalAmountButton.leadingAnchor, paddingTop: 0, paddingBottom: 0, paddingleft: 30, paddingRight: 20, width: 0, height: 0)
        totalAmountLable.centerYAnchor.constraint(equalTo: totalAmountButton.centerYAnchor).isActive = true
        
        totalAmountButton.constraints(top: totalAmountView.topAnchor, bottom: totalAmountView.bottomAnchor, leading: totalAmountView.centerXAnchor, trailing: totalAmountView.trailingAnchor, paddingTop: 10, paddingBottom: 30, paddingleft: -40, paddingRight: 30, width: 0, height: 60)
        
        totalAmountView.backgroundColor = Colors.mainColor
        
        totalAmountButton.setTitle("Buy", for: .normal)
        totalAmountButton.setTitleColor(.label, for: .normal)
        totalAmountButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2, compatibleWith: .none)
        totalAmountButton.backgroundColor = .systemBackground
        totalAmountButton.layer.borderWidth = 0.5
        totalAmountButton.layer.cornerCurve = .continuous
        totalAmountButton.layer.cornerRadius = 20
        totalAmountButton.addTarget(self, action: #selector(goToEnterPersonalInformation), for: .touchUpInside)
        
        totalAmountLable.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .title2, compatibleWith: .none).pointSize) 
    }
    
    //Загрузка блюд
    func loadMeals(){
        
        //Почему не происходит retain cycle
        self.dataWorker.requestCartContent(withCondition: nil) {
            
            self.cartContentTableView.reloadData()
            self.updateTotalAmount()
            
            self.checkCartFilling()
        }
    }
    //Вызов удаления содержимого корзины
    @objc func requestClearCart(){
        
        dataWorker.requestClearCart(withCondition: nil) {
            
            self.dataWorker.requestCartContent(withCondition: nil) {
                
                self.cartContentTableView.reloadData()
                self.updateTotalAmount()
                
                self.checkCartFilling()
                print("try reload cart")
            }
        }
    }
    //Вызов закрытия окна
    @objc func closeView(){
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //Переход к окну ввода адреса, ФИО итл
    @objc func goToEnterPersonalInformation(){
        
        let personalVC = ProjectAssembler.shared.createPersonalInformationViewController()
        
        self.navigationController?.pushViewController(personalVC, animated: true)
    }
    
    @objc func increaseMealCount(_ sender: Any?){
        
        guard let sendedView = (sender as? UIView)?.superview?.superview as? IndexPathCollector else { return }
        
        let condition = "mealID=\(data.cartContent[sendedView.indexPath.row].mealID)"
        
        dataWorker.changeMealValue(withCondition: condition, increaseOrDecrease: true) {
            
            self.dataWorker.requestCartContent(withCondition: nil) {
                self.cartContentTableView.reloadData()
                self.updateTotalAmount()
            }
        }
    }
    
    @objc func decreaseMealCount(_ sender: Any?){
        
        guard let sendedView = (sender as? UIView)?.superview?.superview as? IndexPathCollector else { return }

        let condition = "mealID=\(data.cartContent[sendedView.indexPath.row].mealID)"
        
        dataWorker.changeMealValue(withCondition: condition, increaseOrDecrease: false) {
            
            self.dataWorker.requestCartContent(withCondition: nil) {
                self.cartContentTableView.reloadData()
                self.updateTotalAmount()
                self.checkCartFilling()
            }
        }
    }
    
    //Проверка наполнения корзины и измененния активности кнопки покупки
    func checkCartFilling(){
        
        if self.data.cartContent.isEmpty{
            
            totalAmountButton.isEnabled = false
            totalAmountButton.setTitleColor(.lightGray, for: .normal)
            totalAmountButton.backgroundColor = .darkGray
        }
        else{
            
            totalAmountButton.isEnabled = true
            totalAmountButton.setTitleColor(.label, for: .normal)
            totalAmountButton.backgroundColor = .systemBackground
        }
    }
    
    func updateTotalAmount(){
        
        self.totalAmountLable.text = String(self.data.cartContent.reduce(into: 0, { partialResult, cartContent in
            partialResult += (cartContent.price * cartContent.count)
        })) + " ₽"
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
        
        cell.setUpCell(meal: data.cartContent[indexPath.row], indexPath: indexPath)
        
        imageWorker.requestImage(on: data.cartContent[indexPath.row].imageURL) { image in
            
            cell.setUpCellImage(image: image)
        }
        
        return cell
    }
}

extension CartViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, view, completionHandler in
            
            guard let strongSelf = self else { return }
            
            let condition = "mealID=\(strongSelf.data.cartContent[indexPath.row].mealID)"
            
            strongSelf.dataWorker.requestClearCart(withCondition: condition) {
                
                strongSelf.dataWorker.requestCartContent(withCondition: nil) {
                    strongSelf.cartContentTableView.reloadData()
                }
            }
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}


