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
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            profileImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),

            reputationLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            reputationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            reputationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),

            followButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            followButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            followButton.topAnchor.constraint(equalTo: reputationLabel.bottomAnchor, constant: 20)
        ])
    }

    @objc private func followButtonTapped() {
        followButtonPressed?()
    }

    func configure(with user: User) {
        nameLabel.text = user.displayName
        reputationLabel.text = "\(user.reputation)"

        if user.isFollowed {
            followButton.setTitle("Unfollow", for: .normal)
            followButton.setTitleColor(.red, for: .normal)
        } else {
            followButton.setTitle("Follow", for: .normal)
            followButton.setTitleColor(.systemBlue, for: .normal)
        }
        
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
