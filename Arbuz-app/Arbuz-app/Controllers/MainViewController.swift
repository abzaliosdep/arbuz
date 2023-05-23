//
//  ViewController.swift
//  Arbuz-app
//
//  Created by Абзал Бухарбай on 18.05.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    private var categories: [Category] = Category.categories
    
    private let categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var dimmingView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        setupNavigationBar()
        setConstraints()
        setupCollectionView()
    }
    
    private func setConstraints() {
        view.addSubview(categoriesCollectionView)
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoriesCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            categoriesCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            categoriesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            categoriesCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        let logoImageView = UIImageView(image: UIImage(named: "logo"))
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        navigationItem.titleView = logoImageView
        
        let subscribeButton = UIButton(type: .custom)
            subscribeButton.setTitle("Оформить подписку", for: .normal)
            subscribeButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
            subscribeButton.setTitleColor(.white, for: .normal)
            subscribeButton.backgroundColor = .systemGreen
            subscribeButton.layer.cornerRadius = 8
            subscribeButton.addTarget(self, action: #selector(subscribeButtonTapped), for: .touchUpInside)
        
        let subscribeButtonItem = UIBarButtonItem(customView: subscribeButton)
            navigationItem.rightBarButtonItem = subscribeButtonItem
        
    }
    
    private func setupCollectionView() {
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.categoryIdentifier)
    }
    
    @objc private func subscribeButtonTapped() {
            navigationItem.rightBarButtonItem?.isHidden = true // Отключаем кнопку
            
            dimmingView = UIView(frame: view.bounds)
            dimmingView?.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            dimmingView?.alpha = 0 // Начальное значение прозрачности
            view.addSubview(dimmingView!)
            
            let subscriptionVC = SubscribeViewController()
            subscriptionVC.modalPresentationStyle = .custom
            subscriptionVC.transitioningDelegate = self
            subscriptionVC.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height * 0.75)
            subscriptionVC.dismissHandler = { [weak self] in
                self?.dismissSubscriptionView()
            }
            
            present(subscriptionVC, animated: true, completion: nil)
            
            UIView.animate(withDuration: 0.3) {
                self.dimmingView?.alpha = 1 // Плавно увеличиваем прозрачность затемнения
            }
        }
        
        private func dismissSubscriptionView() {
            UIView.animate(withDuration: 0.3, animations: {
                self.dimmingView?.alpha = 0 // Плавно уменьшаем прозрачность затемнения
            }) { _ in
                self.dimmingView?.removeFromSuperview() // Удаляем затемнение после анимации
                self.dimmingView = nil
                self.navigationItem.rightBarButtonItem?.isHidden = false // Включаем кнопку
            }
        }
}

extension MainViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.categoryIdentifier, for: indexPath) as? CategoryCell else {
            return UICollectionViewCell()
        }
        
        cell.category = categories[indexPath.item]
        
        return cell
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 32
        return CGSize(width: width, height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
}

extension MainViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

class CustomPresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        
        let originY = containerView.bounds.height * 0.25
        let height = containerView.bounds.height * 0.75
        
        return CGRect(x: 0, y: originY, width: containerView.bounds.width, height: height)
    }
}
