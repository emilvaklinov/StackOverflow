//
//  UserCell.swift
//  StackOverflow
//
//  Created by Emil Vaklinov on 03/05/2024.
//

import UIKit

class UserCell: UITableViewCell {
    var followButtonPressed: (() -> Void)?

    // Initialize UILabels, UIButton, and UIImageView
    private let nameLabel = UILabel()
    private let reputationLabel = UILabel()
    private let followButton = UIButton(type: .system)
    private let profileImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 25  // Make image circular with 50x50 size
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(reputationLabel)
        contentView.addSubview(followButton)
        
        followButton.setTitle("Follow", for: .normal)
        followButton.addTarget(self, action: #selector(followButtonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        reputationLabel.translatesAutoresizingMaskIntoConstraints = false
        followButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),

            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: followButton.leadingAnchor, constant: -10),

            reputationLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            reputationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            reputationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            followButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            followButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            followButton.widthAnchor.constraint(equalToConstant: 100)
        ])
    }

    @objc private func followButtonTapped() {
        followButtonPressed?()
    }

    func configure(with user: User) {
        nameLabel.text = user.displayName
        reputationLabel.text = "\(user.reputation)"
        followButton.setTitle(user.isFollowed ? "Unfollow" : "Follow", for: .normal)

        // Reset image to a placeholder initially
        profileImageView.image = UIImage(named: "placeholder")

        if let imageUrl = URL(string: user.profileImage) {
            // Load image asynchronously
            Task { [weak self] in
                await self?.profileImageView.loadImage(from: imageUrl)
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil  // Reset image
        nameLabel.text = nil
        reputationLabel.text = nil
        followButton.setTitle("Follow", for: .normal)
    }
}

extension UIImageView {
    func loadImage(from url: URL) async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        } catch {
            print("Failed to load image from url: \(url), error: \(error)")
            // Optionally set a placeholder image in case of failure
            DispatchQueue.main.async {
                self.image = UIImage(named: "placeholder")
            }
        }
    }
}
