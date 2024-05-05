//
//  UserListViewModel.swift
//  StackOverflow
//
//  Created by Emil Vaklinov on 03/05/2024.
//

import Foundation
import CoreData

class UserListViewModel {
    var users: [User] = []
    var onUsersUpdated: (() -> Void)?
    var onNetworkError: ((String) -> Void)?
    
    private let networkManager: NetworkManager
    private let context: NSManagedObjectContext
    
    init(networkManager: NetworkManager, context: NSManagedObjectContext) {
        self.networkManager = networkManager
        self.context = context
    }
    
    func fetchUsers() {
        NetworkManager.shared.fetchData(from: StackOverflowAPI.users) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let usersResponse = try decoder.decode(UsersResponse.self, from: data)
                        print("Decoded \(usersResponse.items.count) users")
                        self?.users = usersResponse.items
                        self?.loadFollowStatus()
                    } catch {
                        print("Decoding error: \(error)")
                    }
                case .failure(let error):
                    self?.onNetworkError?("Failed to fetch users: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func loadFollowStatus() {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        do {
            let results = try AppDelegate.context.fetch(request)
            for index in 0..<users.count {
                let user = users[index]
                if let match = results.first(where: { $0.displayName == user.displayName }) {
                    users[index].isFollowed = match.isFollowed
                }
            }
            DispatchQueue.main.async {
                self.onUsersUpdated?()
            }
        } catch {
            print("Failed to fetch follow status: \(error)")
        }
    }
    
    private func updateUsersWithFollowStatus() {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        do {
            let results = try AppDelegate.context.fetch(request)
            for index in users.indices {
                if let entity = results.first(where: { $0.accountId == users[index].accountId }) {
                    users[index].isFollowed = entity.isFollowed
                }
            }
        } catch {
            print("Failed to fetch users from CoreData: \(error)")
        }
    }
    
    func toggleFollowStatus(for userIndex: Int) {
        let user = users[userIndex]
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "accountId == %d", user.accountId)
        
        do {
            let results = try AppDelegate.context.fetch(request)
            if let entity = results.first {
                entity.isFollowed.toggle()
            } else {
                let newUserEntity = UserEntity(context: AppDelegate.context)
                newUserEntity.accountId = Int32(user.accountId)
                newUserEntity.isFollowed = true
                newUserEntity.displayName = user.displayName
                newUserEntity.profileImage = user.profileImage
                newUserEntity.reputation = Int32(user.reputation)
            }
            AppDelegate.shared.saveContext()
            users[userIndex].isFollowed.toggle()
            onUsersUpdated?()
        } catch {
            print("Failed to toggle follow status: \(error)")
        }
    }
}
