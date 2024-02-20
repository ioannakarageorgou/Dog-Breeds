//
//  FavoriteBreedsViewController.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 20/1/24.
//

import UIKit

class FavoriteBreedsViewController: UIViewController {
    var viewModel: FavoriteBreedsViewModel!
    var selectedBreed: Breed?

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstants.favoriteBreedsTitle
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 120, height: 160)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FavoriteBreedCell.self, forCellWithReuseIdentifier: FavoriteBreedCell.identifier)
        collectionView.backgroundColor = ColorTheme.Background.secondary
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewModel()
        setUpBindings()
        configureUI()
        fetchData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.cancelTasks()
    }
}

private extension FavoriteBreedsViewController {
    func configureUI() {
        view.backgroundColor = ColorTheme.Background.primary

        view.addSubview(titleLabel)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),

            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setUpViewModel() {
        viewModel = FavoriteBreedsViewModel()
    }

    func setUpBindings() {
        collectionView.delegate = self
        collectionView.dataSource = self

        viewModel.likedBreedImagesDidChange = { likedImages in
            if likedImages != nil {
                self.collectionView.reloadData()
            } else {
                // TODO Handle empty state
                print("No liked images available.")
            }
        }
    }

    func fetchData() {
        viewModel.fetchLikedBreedImages()
    }
}

extension FavoriteBreedsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.likedBreedImages?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteBreedCell.identifier, for: indexPath) as! FavoriteBreedCell
        let likedBreed = viewModel.likedBreedImages?[indexPath.item]
        cell.configure(with: URL(string: likedBreed?.imageURL ?? ""), for: likedBreed?.breedName)
        return cell
    }
}
