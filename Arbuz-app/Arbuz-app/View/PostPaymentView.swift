//
//  PostPaymentView.swift
//  Arbuz-app
//
//  Created by Абзал Бухарбай on 23.05.2023.
//

import UIKit

class PostPaymentView: UIView {
    
    private let paidImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "success")
        return imageView
    } ()
    
    private let paidImageTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textAlignment = .center
        label.text = "Оплата прошла успешно"
        return label
    } ()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.setTitle("Закрыть", for: .normal)
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        return button
    } ()
    
    public var closeButtonTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .white
        
        [paidImage, paidImageTitle, closeButton].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            paidImage.heightAnchor.constraint(equalToConstant: 320),
            paidImage.topAnchor.constraint(equalTo: topAnchor, constant: 80),
            paidImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            paidImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            paidImageTitle.topAnchor.constraint(equalTo: paidImage.bottomAnchor, constant: 16),
            paidImageTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            paidImageTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            closeButton.topAnchor.constraint(equalTo: paidImageTitle.bottomAnchor, constant: 16),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            closeButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    @objc private func close() {
        closeButtonTapped?()
    }
}
