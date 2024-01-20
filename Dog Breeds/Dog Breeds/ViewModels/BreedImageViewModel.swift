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

    var likedBreedImages: [LikedBreedImage]? {
        didSet {
            likedBreedImagesDidChange?(likedBreedImages)
        }
    }

    var networkError: NetworkError? {
        didSet {
            networkErrorDidChange?(networkError)
        }
    }

    var selectedBreed: Breed?
    var breedImagesDidChange: (([BreedImage]?) -> Void)?
    var likedBreedImagesDidChange: (([LikedBreedImage]?) -> Void)?
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
        guard let breed = selectedBreed, let likedImages = likedBreedImages, let breedImage else { return false }
        let imageURLString = breedImage.image.absoluteString
        return likedImages.contains { likedImage in
            return likedImage.breedName == breed.name && likedImage.imageURL == imageURLString
        }
    }
}
