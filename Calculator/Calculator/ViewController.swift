//
//  ViewController.swift
//  Calculator
//
//  Created by 황문주 on 4/27/26.
//

import UIKit

extension UIButton {
    static func makeOperationButton(title: String) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)!
        btn.backgroundColor = UIColor(red: 42/255, green: 161/255, blue: 187/255, alpha:1.0)
        btn.layer.cornerRadius = 20
        return btn
    }
}

class ViewController: UIViewController {
    
    private lazy var firstInputField: UITextField = makeInputField(inputText: "첫번째 숫자를 입력해주세요")
    private lazy var secondInputField: UITextField = makeInputField(inputText: "두번째 숫자를 입력해주세요")
    
    private func makeInputField (inputText:String) -> UITextField {
        let tf = UITextField()
        tf.placeholder = inputText
        tf.borderStyle = .roundedRect
        tf.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)!
        tf.keyboardType = .numberPad
        tf.backgroundColor = .systemGray6
        tf.layer.cornerRadius = 10
        tf.clipsToBounds = true
        return tf
    }
    
    let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "버튼을 눌러주세요"
        label.textAlignment = .center
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        return label
    }()
    
    let addButton = UIButton.makeOperationButton(title: "더하기")
    let subButton = UIButton.makeOperationButton(title: "빼기")
    let mulButton = UIButton.makeOperationButton(title: "곱하기")
    let divButton = UIButton.makeOperationButton(title: "나누기")
    
    private let inputStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fillEqually
        return stack
    }()

    private let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fillEqually
        return stack
    }()

    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fill
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
        
        inputStackView.addArrangedSubview(firstInputField)
        inputStackView.addArrangedSubview(secondInputField)
        
        [addButton, subButton, mulButton, divButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        mainStackView.addArrangedSubview(inputStackView)
        mainStackView.addArrangedSubview(resultLabel)
        mainStackView.addArrangedSubview(buttonStackView)
        
        [firstInputField, secondInputField].forEach {
            $0.heightAnchor.constraint(equalToConstant: 35).isActive = true
        }
            
        [addButton, subButton, mulButton, divButton].forEach {
            $0.heightAnchor.constraint(equalToConstant: 39).isActive = true // 버튼 높이
        }
            
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 157),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 47),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -47)
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
    
    enum CalculatorOperator {
        case add
        case subtract
        case multiply
        case divide

        var symbol: String {
            switch self {
            case .add: return "+"
            case .subtract: return "-"
            case .multiply: return "x"
            case .divide: return "÷"
            }
        }
    }
    
    @objc func addTapped() { calculate(operatorText: .add) }
    @objc func subTapped() { calculate(operatorText: .subtract) }
    @objc func mulTapped() { calculate(operatorText: .multiply) }
    @objc func divTapped() { calculate(operatorText: .divide) }
    
    func calculate(operatorText: CalculatorOperator) {
        let text1 = firstInputField.text ?? ""
        let text2 = secondInputField.text ?? ""
        
        guard let num1 = Int(text1), let num2 = Int(text2) else {
            resultLabel.text = "올바른 숫자를 입력해주세요"
            return
        }
        
        var result: Int = 0
        switch operatorText {
        case .add: result = num1 + num2
        case .subtract: result = num1 - num2
        case .multiply: result = num1 * num2
        case .divide:
            do {
                try result = safeDivide(num1, num2)
            }
            catch {
                resultLabel.text = "0으로 나눌 수 없습니다"
                return
            }
        }
        resultLabel.text = "\(num1) \(operatorText.symbol) \(num2) = \(result)"
    }
    
    enum CalculatingError: Error {
        case divisionByZero
    }
    func safeDivide(_ operand1:Int, _ operand2:Int) throws  -> Int {
        if operand2 == 0 {
            throw CalculatingError.divisionByZero
        }
        return operand1 / operand2
    }
}

#Preview {
    ViewController()
}
