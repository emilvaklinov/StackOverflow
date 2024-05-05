//
//  UserListView.swift
//  StackOverflow
//
//  Created by Emil Vaklinov on 03/05/2024.
//

import UIKit

class UserListView: UIView {
    let tableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTableView() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
        tableView.register(UserCell.self, forCellReuseIdentifier: "UserCell")
    }
}
