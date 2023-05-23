//
//  Model.swift
//  Arbuz-app
//
//  Created by Абзал Бухарбай on 18.05.2023.
//

import UIKit

struct Category: Codable, Equatable {
    let title: String
    var products: [Product]
    
    public static let categories: [Category] = [
        Category(title: "Фрукты", products: [Product.products[0], Product.products[1], Product.products[2]]),
        
        Category(title: "Сезонные овощи", products: [Product.products[3], Product.products[4], Product.products[5]]),
        
        Category(title: "Молочные продукты", products: [Product.products[6], Product.products[7], Product.products[8]]),
    ]
}

struct Product: Codable, Equatable {
    var id = UUID()
    let name: String
    let price: Double
    let weight: Double?
    let image: String
    
    public static let products: [Product] = [
        Product(name: "Яблоки", price: 700.0, weight: 1.0, image: "apple"),
        Product(name: "Арбуз", price: 5000, weight: 1.0, image: "watermelon"),
        Product(name: "Апельсин", price: 1300.0, weight: 1.0, image: "orange"),
        
        Product(name: "Картофель", price: 250.0, weight: 1.0, image: "potato"),
        Product(name: "Лук", price: 400.0, weight: 1.0, image: "onion"),
        Product(name: "Морковь", price: 350.0, weight: 1.0, image: "carrot"),
        
        Product(name: "Кефир", price: 900.0, weight: 1.0, image: "kefir"),
        Product(name: "Сметана", price: 550.0, weight: 0.2, image: "sourcream"),
        Product(name: "Масло", price: 400.0, weight: 0.5, image: "butter"),
    ]
}

struct BasketManager {
    static var basketProducts: [Product] = [] {
        didSet {
            
        }
    }
    
    static func addProductToBasket(_ product: Product) {
        basketProducts.append(product)
    }
    
    static func removeProductFromBasket(_ product: Product) {
        if let index = basketProducts.firstIndex(where: { $0.id == product.id }) {
            basketProducts.remove(at: index)
        }
    }
    
    static func clearBasket() {
        basketProducts.removeAll()
    }
}
