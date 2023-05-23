//
//  CategoryCellView.swift
//  Arbuz-app
//
//  Created by Абзал Бухарбай on 19.05.2023.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    public static let categoryIdentifier = "CategoryCell"
    
    public var category: Category? {
        didSet {
            categoryLabel.text = category?.title
            productCollectionView.reloadData()
        }
    }
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    } ()
    
    private let productCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .white
        
        [productCollectionView, categoryLabel].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            productCollectionView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            productCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),
            productCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            productCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -8),
            
            categoryLabel.topAnchor.constraint(equalTo: topAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: productCollectionView.topAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        ])
    }
    
    private func setupCollectionView() {
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        productCollectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.productIdentifier)
    }
}

extension CategoryCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category?.products.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.productIdentifier, for: indexPath) as? ProductCell else {
            return UICollectionViewCell()
        }
        
        cell.product = category?.products[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = 125
        let cellHeight: CGFloat = collectionView.bounds.height - 16
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
