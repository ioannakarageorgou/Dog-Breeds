//
//  FavoriteBreedsViewModel.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 20/1/24.
//

import Foundation

class FavoriteBreedsViewModel {
    var likedBreedImages: [LikedBreed]? {
        didSet {
            likedBreedImagesDidChange?(likedBreedImages)
        }
    }

    var likedBreedImagesDidChange: (([LikedBreed]?) -> Void)?

    private var repository: BreedsRepositoryProtocol

    init(repository: BreedsRepositoryProtocol = BreedsRepository()) {
        self.repository = repository
    }

    func fetchLikedBreedImages() async {
        do {
            let breedImages = try await repository.fetchAllLikedBreedImagesFromRealm()
            self.likedBreedImages = breedImages
        } catch {
            print("Error loading liked breed images: \(error)")
        }
    }
}
