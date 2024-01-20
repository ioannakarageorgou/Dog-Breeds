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
    private var likedBreedImages: [BreedImage] = []

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
                breedImage.isLiked = likedList.contains { $0 == serverImage }
                return breedImage
            }
            self.breedImages = !combinedList.isEmpty ? combinedList : []
        } catch {
            self.networkError = error as? NetworkError
        }
    }

    func likeBreedImage(at index: Int) {
        guard let breedImage = breedImages?[index] else { return }
        if isImageLiked(breedImage) {
            unlikeBreedImage(breedImage)
        } else {
            likeBreedImage(breedImage)
        }
    }

    private func likeBreedImage(_ breedImage: BreedImage) {
        guard let breed = selectedBreed else { return }
        let likedBreedImage = LikedBreedImage()
        likedBreedImage.breedName = breed.name
        likedBreedImage.imageURL = breedImage.image.absoluteString
        repository.saveLikedBreedImageToRealm(likedBreedImage)
    }

    private func unlikeBreedImage(_ breedImage: BreedImage) {
        guard let breed = selectedBreed else { return }
        repository.removeLikedBreedImageFromRealm(for: breed, and: breedImage)
    }

    func isImageLiked(_ breedImage: BreedImage?) -> Bool {
        guard let breed = selectedBreed, let breedImage else { return false }
        return likedBreedImages.contains(breedImage)
    }
}
