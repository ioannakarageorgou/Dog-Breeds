//
//  FavoriteBreedsViewModel.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 20/1/24.
//

import Foundation

@MainActor
class FavoriteBreedsViewModel {
    var likedBreedImages: [LikedBreed]? {
        didSet {
            likedBreedImagesDidChange?(likedBreedImages)
        }
    }

    var likedBreedImagesDidChange: (([LikedBreed]?) -> Void)?

    private var repository: BreedsRepositoryProtocol
    private var tasks: [Task<Void, Never>] = []

    init(repository: BreedsRepositoryProtocol = BreedsRepository()) {
        self.repository = repository
    }

    func fetchLikedBreedImages() {
        let task = Task {
            do {
                let breedImages = try await repository.fetchAllLikedBreedImagesFromRealm()
                self.likedBreedImages = breedImages
            } catch {
                print("Error loading liked breed images: \(error)")
            }
        }
        tasks.append(task)
    }

    func cancelTasks() {
        tasks.forEach({ $0.cancel() })
        tasks = []
    }
}
