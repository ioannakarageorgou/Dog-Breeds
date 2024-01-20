//
//  FavoriteBreedCell.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 20/1/24.
//

import UIKit

class FavoriteBreedCell: UICollectionViewCell {
    static let identifier = "FavoriteBreedCell"

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let breedNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let likeButton: UIButton = {
        let button = UIButton()
        button.tintColor = AppConstants.customBrown
        let heartSymbolConfiguration = UIImage.SymbolConfiguration(scale: .large)
        let heartImage = UIImage(systemName: AppConstants.heartImageName, withConfiguration: heartSymbolConfiguration)
        button.setImage(heartImage, for: .normal)
        button.setTitle(AppConstants.like, for: .normal)
        button.setTitleColor(AppConstants.customBrown, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(breedNameLabel)
        contentView.addSubview(likeButton)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: breedNameLabel.topAnchor, constant: -8),

            breedNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            breedNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            breedNameLabel.bottomAnchor.constraint(equalTo: likeButton.topAnchor, constant: -8),
            breedNameLabel.heightAnchor.constraint(equalToConstant: 20),

            likeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            likeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            likeButton.heightAnchor.constraint(equalToConstant: 24),
        ])

        contentView.layer.borderWidth = 0.4
        contentView.layer.borderColor = UIColor.lightGray.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with breedImageUrl: URL?, for breedName: String?) {
        if let imageURL = breedImageUrl{
            imageView.load(url: imageURL)
        } else {
            imageView.image = UIImage(named: AppConstants.defaultDogImageName)
        }
        breedNameLabel.text = breedName
    }
}
