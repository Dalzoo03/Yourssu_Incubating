//
//  ViewController.swift
//  Calculator
//
//  Created by 황문주 on 4/27/26.
//

import UIKit

class ViewController: UIViewController {
    
    let firstInputField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "첫번째 숫자를 입력해주세요"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        tf.backgroundColor = UIColor(white: 0.94, alpha: 1.0)
        tf.layer.cornerRadius = 10
        tf.clipsToBounds = true
        return tf
    }()
    
    let secondInputField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "두번째 숫자를 입력해주세요"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        tf.backgroundColor = UIColor(white: 0.94, alpha: 1.0)
        tf.layer.cornerRadius = 10
        tf.clipsToBounds = true
        return tf
    }()
    
    let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "버튼을 눌러주세요"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .light)
        return label
    }()
    
    let addButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("더하기", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(red: 45/255, green: 165/255, blue: 185/255, alpha: 1.0)
        btn.layer.cornerRadius = 25
        return btn
    }()
    
    let subButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("빼기", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(red: 45/255, green: 165/255, blue: 185/255, alpha: 1.0)
        btn.layer.cornerRadius = 25
        return btn
    }()
    
    let mulButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("곱하기", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(red: 45/255, green: 165/255, blue: 185/255, alpha: 1.0)
        btn.layer.cornerRadius = 25
        return btn
    }()
    
    let divButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("나누기", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(red: 45/255, green: 165/255, blue: 185/255, alpha: 1.0)
        btn.layer.cornerRadius = 25
        return btn
    }()
    
    let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 15
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
        setupActions()
    }
    
    func setupUI() {
        view.addSubview(mainStackView)
        
        [firstInputField, secondInputField, resultLabel, addButton, subButton, mulButton, divButton].forEach {
            mainStackView.addArrangedSubview($0)
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        
        NSLayoutConstraint.activate([
            mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    func setupActions() {
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        subButton.addTarget(self, action: #selector(subTapped), for: .touchUpInside)
        mulButton.addTarget(self, action: #selector(mulTapped), for: .touchUpInside)
        divButton.addTarget(self, action: #selector(divTapped), for: .touchUpInside)
        
        firstInputField.addTarget(self, action: #selector(inputFieldDidChange), for: .editingChanged)
        secondInputField.addTarget(self, action: #selector(inputFieldDidChange), for: .editingChanged)
    }
    

    @objc func inputFieldDidChange() {
        let text1 = firstInputField.text ?? ""
        let text2 = secondInputField.text ?? ""
        
        if text1.isEmpty && text2.isEmpty {
            resultLabel.text = "값을 먼저 입력해주세요"
        } else if (!text1.isEmpty && Int(text1) == nil) || (!text2.isEmpty && Int(text2) == nil){
            resultLabel.text = "정수 숫자만 입력해주세요"
        } else if text1.isEmpty || text2.isEmpty {
            resultLabel.text = "숫자를 모두 입력해주세요"
        } else {
            resultLabel.text = "버튼을 눌러주세요!"
        }
    }
    
    @objc func addTapped() { calculate(operatorText: "+") }
    @objc func subTapped() { calculate(operatorText: "-") }
    @objc func mulTapped() { calculate(operatorText: "*") }
    @objc func divTapped() { calculate(operatorText: "/") }
    
    func calculate(operatorText: String) {
        let text1 = firstInputField.text ?? ""
        let text2 = secondInputField.text ?? ""
        
        guard let num1 = Int(text1), let num2 = Int(text2) else {
            resultLabel.text = "올바른 숫자를 입력해주세요"
            return
        }
        
        var result: Int = 0
        switch operatorText {
        case "+": result = num1 + num2
        case "-": result = num1 - num2
        case "*": result = num1 * num2
        case "/":
            if num2 == 0 {
                resultLabel.text = "0으로 나눌 수 없습니다"
                return
            }
            result = num1 / num2
        default: break
        }
        resultLabel.text = "\(num1) \(operatorText) \(num2) = \(result)"
    }
}

#Preview {
    ViewController()
}
