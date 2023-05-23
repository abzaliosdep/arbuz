//
//  BasketViewController.swift
//  Arbuz-app
//
//  Created by Абзал Бухарбай on 20.05.2023.
//

import UIKit

class BasketViewController: UIViewController {
    
    private var basketProducts: [Product] = [] {
        didSet {
            if basketProducts.isEmpty {
                emptyView.isHidden = false
                basketTableView.isHidden = true
                registerOrderButton.isHidden = true
                navigationItem.rightBarButtonItem?.isHidden = true
                basketTableView.reloadData()
            } else {
                emptyView.isHidden = true
                basketTableView.isHidden = false
                basketTableView.reloadData()
                registerOrderButton.isHidden = false
                navigationItem.rightBarButtonItem?.isHidden = false
                registerOrderButton.setTitle("Перейти к оплате\n\(getTotalSum())₸", for: .normal)
            }
        }
    }
    
    private let emptyView = EmptyBasketView()
    
    private lazy var basketTableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.delegate = self
        tv.dataSource = self
        tv.register(BasketCell.self, forCellReuseIdentifier: BasketCell.reuseIdentifier)
        return tv
    } ()
    
    private lazy var registerOrderButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(checkout), for: .touchUpInside)
        return button
    } ()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(productAddedToBasket(_:)), name: .updatedBasketNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationItem.title = "Корзина"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Очистить", style: .done, target: self, action: #selector(clean))
        self.navigationItem.rightBarButtonItem?.tintColor = .lightGray
        
        setUI()
    }
    
    @objc private func productAddedToBasket(_ notification: Notification) {
        if notification.userInfo?["product"] is Product {
            basketProducts = BasketManager.basketProducts
        }
    }
    
    private func setUI() {
        if basketProducts.isEmpty {
            basketTableView.isHidden = true
            registerOrderButton.isHidden = true
            navigationItem.rightBarButtonItem?.isHidden = true
        } else {
            basketTableView.isHidden = false
            registerOrderButton.isHidden = false
            navigationItem.rightBarButtonItem?.isHidden = false
        }
        
        [emptyView, basketTableView, registerOrderButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            basketTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            basketTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            basketTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            basketTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            registerOrderButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            registerOrderButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            registerOrderButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            registerOrderButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    @objc private func checkout() {
        let vc = CheckoutViewController()
        
        var total = 0.0
        
        basketProducts.forEach { product in
            total += product.price
        }
        vc.setTotal(total)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc public func clean() {
        NotificationCenter.default.post(name: .cleanBasketNotification, object: nil, userInfo: ["clean": true])
        basketProducts.removeAll()
        BasketManager.clearBasket()
        basketTableView.reloadData()
        
        if basketProducts.isEmpty {
            registerOrderButton.isHidden = true
            navigationItem.rightBarButtonItem?.isHidden = true
        } else {
            navigationItem.rightBarButtonItem?.isHidden = false
        }
    }
}

extension BasketViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BasketCell.reuseIdentifier, for: indexPath) as? BasketCell else { return UITableViewCell() }
        
        cell.product = basketProducts[indexPath.row]
        cell.onDeleteButtonTapped = { [weak self] in
            self?.deleteProduct(at: indexPath)
        }
        
        return cell
    }
}

extension BasketViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension BasketViewController {
    
    private func getTotalSum() -> Double {
        return basketProducts.reduce(0.0) { $0 + $1.price }
    }
    
    private func deleteProduct(at indexPath: IndexPath) {
        let product = basketProducts[indexPath.row]
        BasketManager.removeProductFromBasket(product)
        basketProducts.remove(at: indexPath.row)
        basketTableView.reloadData()
        
        NotificationCenter.default.post(name: .deletedItemFromBasketNotification, object: nil, userInfo: ["product": product])
    }
}

extension Notification.Name {
    static let updatedBasketNotification = Notification.Name("UpdatedBasketNotification")
    static let deletedItemFromBasketNotification = Notification.Name("DeletedItemFromBasketNotification")
    static let cleanBasketNotification = Notification.Name("CleanBasketNotification")
}
