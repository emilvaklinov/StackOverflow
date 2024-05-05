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
    }

    private func setupBindings() {
        userListView.tableView.delegate = self
        userListView.tableView.dataSource = self
        viewModel.onUsersUpdated = { [weak self] in
            print("Users updated, reloading data")
            self?.userListView.tableView.reloadData()
        }
    }
}

extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
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

