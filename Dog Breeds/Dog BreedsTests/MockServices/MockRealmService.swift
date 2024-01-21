//
//  MockRealmService.swift
//  Dog BreedsTests
//
//  Created by Ioanna Karageorgou on 20/1/24.
//

import Foundation
import RealmSwift

@testable import Dog_Breeds

class MockRealmService: RealmServiceProtocol {
    private var likedBreedImages: [LikedBreed] = []

    func saveLikedBreedImage(_ likedBreedImage: LikedBreed) async throws {
        likedBreedImages.append(likedBreedImage)
    }

    func removeLikedBreedImage(for breed: Breed, and breedImage: BreedImage) async throws {
        likedBreedImages.removeAll { $0.breedName == breed.name && $0.imageURL == breedImage.image.absoluteString }
    }

    func fetchAllLikedBreedImages() async throws -> [LikedBreed]? {
        return likedBreedImages.isEmpty ? nil : likedBreedImages
    }

    func fetchLikedBreedImages(for breed: Breed) async throws -> [LikedBreed]? {
        return likedBreedImages.filter { $0.breedName == breed.name }
    }

    func addLikedBreedImage(imageURL: String, breedName: String) {
        let likedBreedImage = LikedBreed(imageURL: imageURL, breedName: breedName)
        likedBreedImages.append(likedBreedImage)
    }
}

