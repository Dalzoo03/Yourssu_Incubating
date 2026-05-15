//
//  MemoListViewController.swift
//  Memo
//
//  Created by 황문주 on 5/13/26.
//

import UIKit
import SnapKit

class MemoListViewController: UIViewController {
    
    private var memos:[Memo] = []
    
    private let tableView = UITableView()
    
    private let emptyStateLabel: UILabel = {
            let label = UILabel()
            label.text = "메모가 없습니다."
            label.textColor = .black
            label.textAlignment = .center
            return label
        }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTableView()
        setupAutoLayout()
        setupIfMemoEmpty()
        
        
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "메모 목록"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        view.addSubview(tableView)
        view.addSubview(emptyStateLabel)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Memocell")
    }
    
    private func setupAutoLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        emptyStateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupIfMemoEmpty() {
        emptyStateLabel.isHidden = memos.count > 0
        tableView.isHidden = memos.isEmpty
    }
    
    @objc private func addButtonTapped() {
        let memoWriteViewController = MemoWriteViewController()
        memoWriteViewController.delegate = self
        
        navigationController?.pushViewController(memoWriteViewController, animated: true)
    }
}

extension MemoListViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Memocell", for: indexPath)
        let memo = memos[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = memo.title
        content.secondaryText = memo.content
        content.secondaryTextProperties.color = .systemGray
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedMemo = memos[indexPath.row]
        
        let memoDetailViewController = MemoDetailViewController()
        memoDetailViewController.memo = selectedMemo
        navigationController?.pushViewController(memoDetailViewController, animated: true)

    }
}

extension MemoListViewController : MemoWriteDelegate {
    func didSaveMemo(memo: Memo) {
        memos.append(memo)
        tableView.reloadData()
        setupIfMemoEmpty()
    }
}
