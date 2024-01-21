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
    private var likedBreedImages: [LikedBreed] = []

    var breedImagesDidChange: (([BreedImage]?) -> Void)?
    var networkErrorDidChange: ((NetworkError?) -> Void)?

    private var repository: BreedsRepositoryProtocol

    init(repository: BreedsRepositoryProtocol = BreedsRepository()) {
        self.repository = repository
    }

    func fetchAllImages() async {
        do {
            guard let breed = selectedBreed else { return }

            let serverList = try await repository.fetchAllImagesFromServer(for: breed.name)
            let likedList = try await repository.fetchLikedBreedImagesFromRealm(for: breed)
            self.likedBreedImages = !likedList.isEmpty ? likedList : []

            let combinedList = serverList.map { serverImage in
                var breedImage = serverImage
                breedImage.isLiked = self.likedBreedImages.contains { $0.imageURL == serverImage.image.absoluteString }
                return breedImage
            }
            self.breedImages = !combinedList.isEmpty ? combinedList : []
        } catch {
            self.networkError = error as? NetworkError
        }
    }

    func tapLikeBreedImage(at index: Int) async {
        guard let breedImage = breedImages?[index] else { return }
        breedImage.isLiked ? await unlikeBreedImage(breedImage) : await likeBreedImage(breedImage)
    }

    private func likeBreedImage(_ breedImage: BreedImage) async {
        guard let breed = selectedBreed else { return }
        let likedBreedImage = LikedBreed(imageURL: breedImage.image.absoluteString, breedName: breed.name)
        await repository.saveLikedBreedImageToRealm(likedBreedImage)
    }

    private func unlikeBreedImage(_ breedImage: BreedImage) async {
        guard let breed = selectedBreed else { return }
        await repository.removeLikedBreedImageFromRealm(for: breed, and: breedImage)
    }
}
