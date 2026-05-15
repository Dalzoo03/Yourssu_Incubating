//
//  MemoDetailViewController.swift
//  Memo
//
//  Created by 황문주 on 5/13/26.
//

import UIKit
import SnapKit

class MemoDetailViewController: UIViewController {
    
    var memo: Memo?
    
    private let memoTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let memoContentTextView: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let stackView: UIStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupAutoLayout()
        setupMemoData()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "메모 상세"
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.addArrangedSubview(memoTitleLabel)
        stackView.addArrangedSubview(memoContentTextView)
        
        view.addSubview(stackView)
    }
    
    private func setupAutoLayout() {
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupMemoData() {
        if let currentMemo = memo {
            memoTitleLabel.text = currentMemo.title
            memoContentTextView.text = currentMemo.content
        }
        
    }
}
