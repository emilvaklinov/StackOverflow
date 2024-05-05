//
//  UserListViewController.swift
//  StackOverflow
//
//  Created by Emil Vaklinov on 03/05/2024.
//

import UIKit

class UserListViewController: UIViewController {
    private var errorView: ErrorView?
    
    var userListView: UserListView! {
        return view as? UserListView
    }
    
    var viewModel = UserListViewModel()

    override func loadView() {
        view = UserListView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupErrorView()
        setupBindings()
        viewModel.fetchUsers()
        setupTableViewHeader()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        errorView?.frame = userListView.tableView.bounds
    }
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .red
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    private func setupErrorLabel() {
        view.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func setupBindings() {
        userListView.tableView.delegate = self
        userListView.tableView.dataSource = self

        viewModel.onUsersUpdated = { [weak self] in
            guard let self = self else { return }
            
            self.hideError()

            if self.viewModel.users.isEmpty {
                // If data is fetched but the list is empty
                self.showError(message: "No data available.")
            } else {
                // Data fetched successfully and is not empty, reload the data and ensure the error view is hidden
                print("Users updated, reloading data")
                self.userListView.tableView.reloadData()
            }
        }

        viewModel.onNetworkError = { [weak self] message in
            // Show error message when a network error occurs
            self?.showError(message: message)
        }
    }

    
    private func setupErrorView() {
        let errorView = ErrorView(frame: CGRect.zero)
        errorView.isHidden = true
        view.addSubview(errorView)
        errorView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        errorView.retryButtonAction = { [weak self] in
            self?.errorView?.isHidden = true
            self?.retryNetworkRequest()
        }

        self.errorView = errorView
    }

    private func retryNetworkRequest() {
        viewModel.fetchUsers()
    }

    func showError(message: String) {
        DispatchQueue.main.async {
            self.errorLabel.text = message
            self.errorLabel.isHidden = false
            self.errorView?.messageLabel.text = message
            self.errorView?.isHidden = false
        }
    }

    func hideError() {
        DispatchQueue.main.async {
            self.errorLabel.isHidden = true
            self.errorView?.isHidden = true
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

        headerView.frame = CGRect(x: 0, y: 0, width: userListView.tableView.bounds.width, height: 100)
    }
}

extension UserListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

