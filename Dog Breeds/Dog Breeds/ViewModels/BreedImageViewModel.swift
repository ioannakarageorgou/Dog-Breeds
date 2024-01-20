//
//  BreedImageViewModel.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 19/1/24.
//

import Foundation

class BreedImageViewModel {
    var breedImages: [BreedImage]? {
        didSet {
            breedImagesDidChange?(breedImages)
        }
    }

    var networkError: NetworkError? {
        didSet {
            networkErrorDidChange?(networkError)
        }
    }

    var selectedBreed: Breed?
    var breedImagesDidChange: (([BreedImage]?) -> Void)?
    var networkErrorDidChange: ((NetworkError?) -> Void)?

    private var repository: BreedsRepositoryProtocol

    init(repository: BreedsRepositoryProtocol = BreedsRepository()) {
        self.repository = repository
    }

    func fetchAllImages() async {
        do {
            guard let breed = selectedBreed else { return }
            let list = try await repository.fetchAllImagesFromServer(for: breed.name)
            self.breedImages = !list.isEmpty ? list : []
        } catch {
            self.networkError = error as? NetworkError
        }
    }
}

