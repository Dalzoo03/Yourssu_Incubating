//
//  MemoWriteViewController.swift
//  Memo
//
//  Created by 황문주 on 5/13/26.
//

import UIKit
import SnapKit

protocol MemoWriteDelegate: AnyObject {
    func didSaveMemo(memo: Memo)
}

class MemoWriteViewController : UIViewController {
    
    weak var delegate: MemoWriteDelegate?
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목 입력"
        return textField
    }()
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.systemGray.cgColor
        return textView
    }()
    
    private let stackView : UIStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAutoLayout()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "메모 작성"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "등록", style: .plain, target: self, action: #selector(saveMemoTapped))
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.addArrangedSubview(titleTextField)
        stackView.addArrangedSubview(contentTextView)
        
        view.addSubview(stackView)
    }
    
    private func setupAutoLayout() {
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
    
    @objc private func saveMemoTapped() {
        guard let title = titleTextField.text, !title.isEmpty else {
            return
        }
        guard let content = contentTextView.text, !content.isEmpty else {
            return
        }
        
        let newMemo = Memo(title: title, content: content)
        delegate?.didSaveMemo(memo: newMemo)
        navigationController?.popViewController(animated: true)
    }
}
