//
//  ProductCellView.swift
//  Arbuz-app
//
//  Created by Абзал Бухарбай on 19.05.2023.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    public static let productIdentifier = "ProductCell"
    public var product: Product? {
        didSet {
            guard let product = product else { return }
            productLabel.text = product.name
            productImage.image = UIImage(named: product.image)
            priceLabel.text = "\(product.price) ₸"
        }
    }
    
    private var numberOfSelectedProduct: Int = 0 {
        didSet {
            selectedItemsNumberLabel.text = "\(numberOfSelectedProduct)"
        }
    }
    
    public var isProductSelected: Bool = false {
        didSet {
            if numberOfSelectedProduct > 0 {
                priceLabel.isHidden = true
                minusButton.isHidden = false
                selectedItemsNumberLabel.isHidden = false
                priceView.backgroundColor = .systemGreen
                plusButton.setTitleColor(.white, for: .normal)
                minusButton.setTitleColor(.white, for: .normal)
            } else {
                priceLabel.isHidden = false
                minusButton.isHidden = true
                selectedItemsNumberLabel.isHidden = true
                priceView.backgroundColor = UIColor(red: 0.225, green: 0.225, blue: 0.225, alpha: 0.1)
                plusButton.setTitleColor(.systemGreen, for: .normal)
                minusButton.setTitleColor(.systemGreen, for: .normal)
            }
        }
    }
    
    private let productLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .center
        return label
    } ()
    
    private let productImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    } ()
    
    private let priceView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.225, green: 0.225, blue: 0.225, alpha: 0.1)
        view.layer.cornerRadius = 16
        return view
    } ()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .center
        return label
    } ()
    
    private let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.setTitleColor(.systemGreen, for: .normal)
        button.layer.cornerRadius = 8
        return button
    } ()
    
    private let minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.isHidden = true
        button.setTitle("-", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.setTitleColor(.green, for: .normal)
        button.layer.cornerRadius = 8
        return button
    } ()
    
    private let selectedItemsNumberLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .center
        return label
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(productBasketChanged(_:)), name: .deletedItemFromBasketNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleClean), name: .cleanBasketNotification, object: nil)
        
        setUI()
        plusButton.addTarget(self, action: #selector(handleAddProduct), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(handleRemoveProduct), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleAddProduct() {
        if numberOfSelectedProduct < 3 {
            guard let product = product else { return }
            BasketManager.addProductToBasket(product)
            numberOfSelectedProduct += 1
            isProductSelected = true
            NotificationCenter.default.post(name: .updatedBasketNotification, object: nil, userInfo: ["product": product])
        }
    }
    
    @objc private func handleRemoveProduct() {
        guard let product = product else { return }
        BasketManager.removeProductFromBasket(product)
        numberOfSelectedProduct -= 1
        isProductSelected = false
        NotificationCenter.default.post(name: .updatedBasketNotification, object: nil, userInfo: ["product": product])
    }
    
    @objc private func productBasketChanged(_ notification: Notification) {
        if let item = notification.userInfo?["product"] as? Product {
            if product?.id == item.id {
                numberOfSelectedProduct -= 1
                isProductSelected = false
            }
        }
    }
    
    @objc private func handleClean() {
        numberOfSelectedProduct = 0
        isProductSelected = false
    }
    
    private func setUI() {
        backgroundColor = .white
        layer.cornerRadius = 16
        
        [productImage, productLabel, priceView].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        [priceLabel, plusButton, minusButton, selectedItemsNumberLabel].forEach {
            priceView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            productImage.topAnchor.constraint(equalTo: topAnchor),
            productImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            productImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            productImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75),
            
            productLabel.topAnchor.constraint(equalTo: productImage.bottomAnchor),
            productLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            productLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            priceView.topAnchor.constraint(equalTo: productLabel.bottomAnchor, constant: 8),
            priceView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            priceView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            priceView.heightAnchor.constraint(equalToConstant: 32),
            
            priceLabel.leadingAnchor.constraint(equalTo: priceView.leadingAnchor, constant: 16),
            priceLabel.centerYAnchor.constraint(equalTo: priceView.centerYAnchor),
            
            plusButton.trailingAnchor.constraint(equalTo: priceView.trailingAnchor, constant: -8),
            plusButton.widthAnchor.constraint(equalToConstant: 16),
            plusButton.heightAnchor.constraint(equalToConstant: 16),
            plusButton.centerYAnchor.constraint(equalTo: priceView.centerYAnchor),
            
            minusButton.leadingAnchor.constraint(equalTo: priceView.leadingAnchor, constant: 8),
            minusButton.widthAnchor.constraint(equalToConstant: 16),
            minusButton.heightAnchor.constraint(equalToConstant: 16),
            minusButton.centerYAnchor.constraint(equalTo: priceView.centerYAnchor),
            
            selectedItemsNumberLabel.centerXAnchor.constraint(equalTo: priceView.centerXAnchor),
            selectedItemsNumberLabel.centerYAnchor.constraint(equalTo: priceView.centerYAnchor)
        ])
    }
}
