//
//  CartViewController.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 19.01.2022.
//

import UIKit

final class CartViewController: UIViewController {
    
    private let dataWorker: DataWorkerForCartProtocol //Объект для запроса данных
    private let imageWorker: ImageWorker
    private let data: DataWorkerCollectedDataForCartProtocol //Данные для заполнения корзины
     
    //Таблица с содержимым корзины
    private let cartContentTableView: UITableView = {
       
        let tableView = UITableView()
        
        tableView.rowHeight = UITableView.automaticDimension
        
        return tableView
    }()
    
    //Вью с итоговой суммой
    private let totalAmountView: UIView = {
        
        let view = UIView()
        
        view.backgroundColor = Colors.mainColor
        
        return view
    }()
    
    // Лейбл на котором написана общая сумма
    private let totalAmountLable: UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .title2, compatibleWith: .none).pointSize)
        
        return label
    }()
    
    // Кнопка оплаты рядом с общей суммой
    private let totalAmountButton: UIButton = {
        
        let button = UIButton()
        
        button.setTitle("Buy", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2, compatibleWith: .none)
        button.backgroundColor = .systemBackground
        button.layer.borderWidth = 0.5
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(goToEnterPersonalInformation), for: .touchUpInside)
        
        return button
    }()
    
    //индикатор загрузки
    private let loadingView: LoadingBlurView = {
       
        let loadingView = LoadingBlurView(frame: .zero, blurStyle: .dark, activityStyle: .medium)
        
        return loadingView
    }()
    
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
        configureLoadingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadMeals()
    }
    
    override func viewWillLayoutSubviews() {
        
        loadingView.frame = self.view.frame
    }
    
    private func configureCartViewController(){
        
        view.backgroundColor = .systemBackground
        self.navigationItem.title = "Cart"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let doneButton = UIBarButtonItem(image: Images.backArrow, style: .done , target: self, action: #selector(closeView))
        let clearCartButton = UIBarButtonItem(image: Images.trash, style: .plain, target: self, action: #selector(requestClearCart))
        
        self.navigationItem.leftBarButtonItem = doneButton
        self.navigationItem.rightBarButtonItem = clearCartButton
    }
    
    private func configureLoadingView(){
        
        view.addSubview(loadingView)
        loadingView.frame = self.view.frame
    }
    
    //Конфигурация таблицы с выбранными блюдами
    private func configureCartContentTableView(){
        
        view.addSubview(cartContentTableView)
        
        cartContentTableView.dataSource = self
        cartContentTableView.delegate = self
        cartContentTableView.register(CartContentTableViewCell.self, forCellReuseIdentifier: CartContentTableViewCell.id)
        
        cartContentTableView.constraints(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingleft: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    //Конфигурация нижнего поля с итоговой суммой заказа
    private func configureTotalAmount(){
        
        view.addSubview(totalAmountView)
        totalAmountView.addSubview(totalAmountLable, totalAmountButton)
        
        totalAmountView.constraints(top: cartContentTableView.bottomAnchor, bottom: view.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingleft: 0, paddingRight: 0, width: 0, height: 0)
        
        totalAmountLable.constraints(top: nil, bottom: nil, leading: totalAmountView.leadingAnchor, trailing: totalAmountButton.leadingAnchor, paddingTop: 0, paddingBottom: 0, paddingleft: 30, paddingRight: 20, width: 0, height: 0)
        totalAmountLable.centerYAnchor.constraint(equalTo: totalAmountButton.centerYAnchor).isActive = true
        
        totalAmountButton.constraints(top: totalAmountView.topAnchor, bottom: totalAmountView.bottomAnchor, leading: totalAmountView.centerXAnchor, trailing: totalAmountView.trailingAnchor, paddingTop: 10, paddingBottom: 30, paddingleft: -40, paddingRight: 30, width: 0, height: 60)
    }
    
    //Загрузка блюд
    private func loadMeals(){
        
        //Почему не происходит retain cycle
        self.dataWorker.requestCartContent(withCondition: nil) {
            
            self.cartContentTableView.reloadData()
            self.updateTotalAmount()
            self.updateFooterView()
            
            self.checkCartFilling()
        }
    }
    //Вызов удаления содержимого корзины
    @objc private func requestClearCart(){
        
        self.loadingView.enableActivityWithAnimation {}
        
        dataWorker.requestClearCart(withCondition: nil) {
            
            self.dataWorker.requestCartContent(withCondition: nil) {
                
                self.cartContentTableView.reloadData()
                self.updateTotalAmount()
                self.updateFooterView()
                
                self.checkCartFilling()
                self.loadingView.disableActivityWithAnimation {}
                print("try reload empty cart")
            }
        }
    }
    //Вызов закрытия окна
    @objc private func closeView(){
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //Переход к окну ввода адреса, ФИО итл
    @objc private func goToEnterPersonalInformation(_ sender: UIButton){
        
        sender.showTapAnimation {
            
            let personalVC = ProjectCoordinator.shared.createPersonalInformationViewController()
            
            self.navigationController?.pushViewController(personalVC, animated: true)
        }
    }
    
    @objc private func increaseMealCount(_ sender: UIButton){
        
        sender.showTapAnimation {

            self.loadingView.enableActivityWithAnimation {}

            guard let sendedView = sender.superview?.superview as? IndexPathCollector else { return }

            let mealID = "\(self.data.cartContent[sendedView.indexPath.row].mealID)"

            self.dataWorker.changeMealValue(mealID: mealID, increaseOrDecrease: true) {

                self.dataWorker.requestCartContent(withCondition: nil) {
                    self.cartContentTableView.reloadData()
                    self.updateTotalAmount()
                    self.updateFooterView()
                    self.loadingView.disableActivityWithAnimation {}
                }
            }
        }
    }
    
    @objc private func decreaseMealCount(_ sender: UIButton){
        
        sender.showTapAnimation {
            
            self.loadingView.enableActivityWithAnimation {}
            
            guard let sendedView = sender.superview?.superview as? IndexPathCollector else { return }

            let mealID = "\(self.data.cartContent[sendedView.indexPath.row].mealID)"
            
            self.dataWorker.changeMealValue(mealID: mealID, increaseOrDecrease: false) {
                
                self.dataWorker.requestCartContent(withCondition: nil) {
                    self.cartContentTableView.reloadData()
                    self.updateTotalAmount()
                    self.updateFooterView()
                    self.checkCartFilling()
                    self.loadingView.disableActivityWithAnimation {}
                }
            }
        }
    }
    
    //Проверка наполнения корзины и измененния активности кнопки покупки
    private func checkCartFilling(){
        
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
    
    private func updateTotalAmount(){
        
        self.totalAmountLable.text = String(self.data.cartContent.reduce(into: 0, { partialResult, cartContent in
            partialResult += (cartContent.price * cartContent.count)
        })) + " ₽"
    }
    
    private func updateFooterView(){
        
        if cartContentTableView.numberOfRows(inSection: 0) != 0 {
            
            let footerViewFrame = CGRect(origin: .zero, size: CGSize(width: cartContentTableView.frame.width, height: cartContentTableView.rowHeight))

            cartContentTableView.tableFooterView = TablewareView(frame: footerViewFrame)
        }
        else {

            cartContentTableView.tableFooterView = nil
        }
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
                    strongSelf.updateFooterView()
                }
            }
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}


