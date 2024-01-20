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

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(breedNameLabel)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: breedNameLabel.topAnchor, constant: -8),

            breedNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            breedNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            breedNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            breedNameLabel.heightAnchor.constraint(equalToConstant: 20),
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
