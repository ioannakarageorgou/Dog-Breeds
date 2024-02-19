//
//  BreedImageViewModel.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 19/1/24.
//

import Foundation

@MainActor
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
    private var repository: BreedsRepositoryProtocol
    private var tasks: [Task<Void, Never>] = []

    var breedImagesDidChange: (([BreedImage]?) -> Void)?
    var networkErrorDidChange: ((NetworkError?) -> Void)?

    init(repository: BreedsRepositoryProtocol = BreedsRepository()) {
        self.repository = repository
    }

    func fetchAllImages() {
        let task = Task {
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
        tasks.append(task)
    }

    func tapLikeBreedImage(at index: Int) {
        let task = Task {
            guard let breedImage = breedImages?[index] else { return }
            breedImages?[index].isLiked.toggle()
            breedImage.isLiked ? await unlikeBreedImage(breedImage) : await likeBreedImage(breedImage)
        }
        tasks.append(task)
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

    func cancelTasks() {
        tasks.forEach({ $0.cancel() })
        tasks = []
    }
}
