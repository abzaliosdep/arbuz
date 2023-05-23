//
//  EmptyBasketView.swift
//  Arbuz-app
//
//  Created by Абзал Бухарбай on 20.05.2023.
//

import UIKit

class EmptyBasketView: UIView {
    
    private let emptyBasketImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "icon"))
        return image
    } ()
    
    private let emptyBasketTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textAlignment = .center
        label.text = "Ваша корзина пока пуста"
        return label
    } ()
    
    private let emptyBasketText: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.text = "Здесь будут лежать товары для покупки"
        return label
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        
        [emptyBasketImage, emptyBasketTitle, emptyBasketText].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        setConstraints()
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            emptyBasketImage.widthAnchor.constraint(equalToConstant: 160),
            emptyBasketImage.heightAnchor.constraint(equalToConstant: 160),
            emptyBasketImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyBasketImage.centerYAnchor.constraint(equalTo: centerYAnchor),

            emptyBasketTitle.topAnchor.constraint(equalTo: emptyBasketImage.bottomAnchor, constant: 16),
            emptyBasketTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            emptyBasketTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            emptyBasketText.topAnchor.constraint(equalTo: emptyBasketTitle.bottomAnchor, constant: 16),
            emptyBasketText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            emptyBasketText.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
