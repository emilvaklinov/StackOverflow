//
//  UserListViewController.swift
//  StackOverflow
//
//  Created by Emil Vaklinov on 03/05/2024.
//

import UIKit

class UserListViewController: UIViewController {
    var userListView: UserListView! {
        return view as? UserListView
    }
    var viewModel = UserListViewModel()

    override func loadView() {
        view = UserListView()
        print("View loaded as UserListView")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel.fetchUsers()
        setupTableViewHeader()
    }

    private func setupBindings() {
        userListView.tableView.delegate = self
        userListView.tableView.dataSource = self
        viewModel.onUsersUpdated = { [weak self] in
            print("Users updated, reloading data")
            self?.userListView.tableView.reloadData()
        }
    }
    
    private func setupTableViewHeader() {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.systemBackground

        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = "StackOverflow Users"
        headerLabel.font = UIFont.boldSystemFont(ofSize: 22)
        headerLabel.textAlignment = .center

        headerView.addSubview(headerLabel)

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -20),
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
        ])

        userListView.tableView.tableHeaderView = headerView

        // Set the frame of the header view after adding constraints to determine its size
        headerView.frame = CGRect(x: 0, y: 0, width: userListView.tableView.bounds.width, height: 100)
    }
}

extension UserListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("TableView numberOfRowsInSection: \(viewModel.users.count)")
        return viewModel.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell else {
            fatalError("Cell identifier 'UserCell' not found")
        }
        let user = viewModel.users[indexPath.row]
        cell.configure(with: user)
        cell.followButtonPressed = { [weak self] in
            print("Follow button pressed at row \(indexPath.row)")
            self?.viewModel.toggleFollowStatus(for: indexPath.row)
        }
        return cell
    }
}

