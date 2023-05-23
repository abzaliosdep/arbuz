//
//  CheckoutViewController.swift
//  Arbuz-app
//
//  Created by Абзал Бухарбай on 23.05.2023.
//

import UIKit

class CheckoutViewController: UIViewController {
    
    private let addressTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textAlignment = .left
        label.text = "Адрес доставки"
        
        return label
    } ()
    
    private lazy var addressField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Введите адрес"
        
        return field
    } ()
    
    private let dateTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textAlignment = .left
        label.text = "Дата доставки"
        
        return label
    } ()
    
    private lazy var dateField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Выберите дату"
        field.inputView = datePicker
        
        let button = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(dateChosen))
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), button], animated: false)
        
        field.inputAccessoryView = toolBar
        
        return field
    } ()
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.addTarget(self, action: #selector(dateChanged), for: .allEvents)
        picker.preferredDatePickerStyle = .wheels
        picker.datePickerMode = .dateAndTime
        picker.minimumDate = Date()
        return picker
    } ()
    
    private let contactsTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textAlignment = .left
        label.text = "Контактная информация"
        return label
    } ()
    
    private lazy var nameField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Введите свое имя"
        
        return field
    } ()
    
    private lazy var phoneField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "87004407798"
        field.keyboardType = .phonePad
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        
        
        field.inputAccessoryView = toolBar
        
        return field
    } ()
    
    private let totalTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .left
        label.text = "Итого"
        return label
    } ()
    
    private let totalSum: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .right
        label.text = "₸"
        return label
    } ()
    
    private lazy var totalView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [totalTitle, totalSum])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    } ()
    
    private lazy var payButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.setTitle("Оплатить", for: .normal)
        button.addTarget(self, action: #selector(pay), for: .touchUpInside)
        return button
    } ()
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [addressTitle, addressField, dateTitle, dateField, contactsTitle, nameField, phoneField, totalView, payButton])
        sv.axis = .vertical
        sv.distribution = .fillProportionally
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 16
        return sv
    } ()
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.addSubview(stackView)
        return sv
    } ()
    
    private let postPaymentView = PostPaymentView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationItem.title = "Оформление заказа"
        navigationController?.navigationBar.tintColor = .systemGreen
        
        phoneField.delegate = self
        
        setUI()
    }
    
    public func setTotal(_ total: Double) {
        totalSum.text = total.description + "₸"
    }
    
    private func setUI() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            
            payButton.heightAnchor.constraint(equalToConstant: 48),
            payButton.widthAnchor.constraint(equalToConstant: view.frame.width - 32)
        ])
    }
    
    @objc private func pay() {
        
        guard let address = addressField.text, !address.isEmpty,
              let date = dateField.text, !date.isEmpty,
              let name = nameField.text, !name.isEmpty,
              let phone = phoneField.text, !phone.isEmpty else {
            let alert = UIAlertController(title: "Предупреждение", message: "Заполните все поля", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let phoneRegex = "^\\d{11}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        if !phonePredicate.evaluate(with: phone) {
            let alert = UIAlertController(title: "Предупреждение", message: "Неверный формат номера телефона", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        view.addSubview(postPaymentView)
        postPaymentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            postPaymentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            postPaymentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            postPaymentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            postPaymentView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        tabBarController?.tabBar.isHidden = true
        navigationController?.isNavigationBarHidden = true
        
        postPaymentView.closeButtonTapped = { [weak self] in
            self?.navigationController?.viewControllers.forEach({ item in
                if let vc = item as? BasketViewController {
                    vc.clean()
                    self?.tabBarController?.tabBar.isHidden = false
                    self?.navigationController?.isNavigationBarHidden = false
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            })
        }
    }
    
    @objc private func addressDone() {
        addressField.resignFirstResponder()
    }
    
    @objc private func dateChanged() {
        let dateFormat = DateFormatter()
        dateFormat.timeZone = .current
        dateFormat.dateFormat = "dd.MM.yyyy HH:mm"
        
        dateField.text = dateFormat.string(from: datePicker.date)
    }
    
    @objc private func dateChosen() {
        dateField.resignFirstResponder()
    }
    
    @objc private func nameDone() {
        nameField.resignFirstResponder()
    }
    
    @objc private func phoneDone() {
        phoneField.resignFirstResponder()
    }
}

extension CheckoutViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneField {
            
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            let maxLength = 11
            let currentText = textField.text ?? ""
            let newLength = currentText.count + string.count - range.length
            if newLength > maxLength {
                return false
            }
            
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
}
