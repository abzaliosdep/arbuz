//
//  SubscribViewController.swift
//  Arbuz-app
//
//  Created by Абзал Бухарбай on 23.05.2023.
//

import UIKit

class SubscribeViewController: UIViewController {
    
    var dismissHandler: (() -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Подписка"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let imageArbuz: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "arbuz")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let friendsLabel: UILabel = {
        let label = UILabel()
        label.text = "arbuz friend's"
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subscriptionOptions: [String] = ["Месячный 2500 ₸", "Полугодовой 12000 ₸", "Годовой 18000 ₸"]
    private var selectedOptionIndex: Int?
    
    private lazy var optionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let buyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Купить подписку", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemYellow
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(imageArbuz)
        view.addSubview(friendsLabel)
        view.addSubview(optionsStackView)
        view.addSubview(buyButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            imageArbuz.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 16),
            imageArbuz.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageArbuz.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageArbuz.widthAnchor.constraint(equalToConstant: 100),
            imageArbuz.heightAnchor.constraint(equalToConstant: 200),
            
            friendsLabel.topAnchor.constraint(equalTo: imageArbuz.topAnchor, constant: 16),
            friendsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            friendsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            optionsStackView.topAnchor.constraint(equalTo: friendsLabel.bottomAnchor, constant: 8),
            optionsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            optionsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            buyButton.topAnchor.constraint(equalTo: optionsStackView.bottomAnchor, constant: 16),
            buyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buyButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            buyButton.heightAnchor.constraint(equalToConstant: 48)
        ])

        for (index, option) in subscriptionOptions.enumerated() {
            let optionView = createSubscriptionOptionView(option, index: index)
            optionsStackView.addArrangedSubview(optionView)
        }
    }
    
    private func createSubscriptionOptionView(_ option: String, index: Int) -> UIView {
        let optionView = UIView()
        optionView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = option
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        checkmarkImageView.tintColor = .systemGreen
        checkmarkImageView.contentMode = .scaleAspectFit
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkImageView.isHidden = true
        
        optionView.addSubview(titleLabel)
        optionView.addSubview(checkmarkImageView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: optionView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: optionView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: optionView.trailingAnchor),
            
            checkmarkImageView.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            checkmarkImageView.centerXAnchor.constraint(equalTo: optionView.centerXAnchor),
            checkmarkImageView.bottomAnchor.constraint(equalTo: optionView.bottomAnchor)
        ])

        optionView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(subscriptionOptionTapped(_:)))
        optionView.addGestureRecognizer(tapGesture)

        optionView.tag = index
        
        return optionView
    }
    
    @objc private func subscriptionOptionTapped(_ gesture: UITapGestureRecognizer) {
        guard let optionView = gesture.view else { return }
        
        let selectedIndex = optionView.tag

        for subview in optionsStackView.arrangedSubviews {
            if let subview = subview as? UIView {
                let checkmarkImageView = subview.subviews.first(where: { $0 is UIImageView }) as? UIImageView
                checkmarkImageView?.isHidden = subview.tag != selectedIndex
            }
        }
        
        selectedOptionIndex = selectedIndex
    }
    
    @objc private func buyButtonTapped() {
        dismissHandler?()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .down {
            dismissHandler?()
            dismiss(animated: true, completion: nil)
        }
    }
}
