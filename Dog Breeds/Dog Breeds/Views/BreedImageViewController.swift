//
//  BreedImageViewController.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 19/1/24.
//

import UIKit

class BreedImageViewController: UIViewController {
    var viewModel: BreedImageViewModel!
    var selectedBreed: Breed?

    let breedNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 120, height: 160)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BreedImageCell.self, forCellWithReuseIdentifier: BreedImageCell.identifier)
        collectionView.backgroundColor = AppConstants.secondaryBackgroundColor
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViewModel()
        setUpBindings()
        configureUI()
        fetchData()
    }
}

private extension BreedImageViewController {
    func configureUI() {
        view.backgroundColor = AppConstants.primaryBackgroundColor

        breedNameLabel.text = viewModel.selectedBreed?.name
        breedNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(breedNameLabel)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            breedNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            breedNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            breedNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            breedNameLabel.heightAnchor.constraint(equalToConstant: 40),

            collectionView.topAnchor.constraint(equalTo: breedNameLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setUpViewModel() {
        viewModel = BreedImageViewModel()
        viewModel.selectedBreed = selectedBreed
    }

    func setUpBindings() {
        collectionView.delegate = self
        collectionView.dataSource = self

        viewModel.breedImagesDidChange = { breedImages in
            if breedImages != nil {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } else {
                // TODO Handle empty state
                print("No images available.")
            }
        }

        viewModel.networkErrorDidChange = { error in
            DispatchQueue.main.async {
                // TODO Handle error state
                print("Network error: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    func fetchData() {
        Task {
            await viewModel.fetchAllImages()
        }
    }
}

extension BreedImageViewController: BreedImageCellDelegate {
    func didTapLikeButton(for cell: BreedImageCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let breedImage = viewModel.breedImages?[indexPath.item]
        collectionView.reloadItems(at: [indexPath])
    }
}

extension BreedImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.breedImages?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BreedImageCell.identifier, for: indexPath) as! BreedImageCell
        let breedImage = viewModel.breedImages?[indexPath.item]
        let isLiked = viewModel.isImageLiked(breedImage)
        cell.configure(with: breedImage, isLiked: isLiked)
        return cell
    }
}
