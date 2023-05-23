//
//  BasketCellView.swift
//  Arbuz-app
//
//  Created by Абзал Бухарбай on 20.05.2023.
//

import UIKit

class BasketCell: UITableViewCell {
    
    public static let reuseIdentifier = "BasketCell"
    
    public var product: Product? {
        didSet {
            guard let product = product else { return }
            productLabel.text = product.name
            productImage.image = UIImage(named: product.image)
            priceLabel.text = "\(product.price) ₸"
        }
    }
    
    public var onDeleteButtonTapped: (() -> Void)?
    
    private let productLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    } ()
    
    private let productImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    } ()
    
    private let separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(red: 0.225, green: 0.225, blue: 0.225, alpha: 0.3)
        return separatorView
    } ()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        return label
    } ()
    
    private lazy var deleteProductButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        return button
    } ()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setActions()
        sendSubviewToBack(contentView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
        setActions()
    }
    
    private func setUI() {
        self.backgroundColor = .white
        
        [productLabel, productImage, separatorView, priceLabel, deleteProductButton].forEach { self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            productImage.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            productImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            productImage.widthAnchor.constraint(equalToConstant: 80),
            productImage.heightAnchor.constraint(equalToConstant: 80),

            productLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            productLabel.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: 16),

            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 16),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            separatorView.heightAnchor.constraint(equalToConstant: 1),

            priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            deleteProductButton.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            deleteProductButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }

    private func setActions() {
        deleteProductButton.addTarget(self, action: #selector(handleDeleteProduct), for: .touchUpInside)
    }
    
    @objc private func handleDeleteProduct() {
        onDeleteButtonTapped?()
    }
}
