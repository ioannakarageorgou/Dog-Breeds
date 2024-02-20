//
//  BreedTableViewCell.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 19/1/24.
//

import UIKit

class BreedTableViewCell: UITableViewCell {
    static let identifier = "BreedCell"

    let contentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(contentLabel)
        NSLayoutConstraint.activate([
            contentLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            contentLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        contentView.backgroundColor = ColorTheme.Background.secondary
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let bottomSpace: CGFloat = 10.0
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: bottomSpace, right: 0))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with breed: Breed) {
        contentLabel.text = breed.name
    }
}
