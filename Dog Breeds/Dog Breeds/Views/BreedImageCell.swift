//
//  BreedImageCell.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 20/1/24.
//

import Foundation
import UIKit

protocol BreedImageCellDelegate: AnyObject {
    func didTapLikeButton(for cell: BreedImageCell)
}

class BreedImageCell: UICollectionViewCell {
    static let identifier = "BreedImageCell"

    weak var delegate: BreedImageCellDelegate?

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    var isLiked: Bool = false {
        didSet {
            updateLikeButton()
        }
    }

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
        contentView.addSubview(likeButton)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: likeButton.topAnchor, constant: -8),

            likeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            likeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            likeButton.heightAnchor.constraint(equalToConstant: 24),
        ])

        contentView.layer.borderWidth = 0.4
        contentView.layer.borderColor = UIColor.lightGray.cgColor

        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with breedImage: BreedImage?) {
        if let imageURL = breedImage?.image {
            imageView.load(url: imageURL)
        } else {
            imageView.image = UIImage(named: AppConstants.defaultDogImageName)
        }
        self.isLiked = breedImage?.isLiked ?? false
        updateLikeButton()
    }

    @objc func likeButtonTapped() {
        isLiked.toggle()
        delegate?.didTapLikeButton(for: self)
    }

    private func updateLikeButton() {
        let imageName = isLiked ? AppConstants.heartFillImageName : AppConstants.heartImageName
        let title = isLiked ? AppConstants.liked : AppConstants.like

        let heartSymbolConfiguration = UIImage.SymbolConfiguration(scale: .large)
        likeButton.setImage(UIImage(systemName: imageName, withConfiguration: heartSymbolConfiguration), for: .normal)
        likeButton.setTitle(title, for: .normal)
    }
}
