//
//  MockBreedsRepository.swift
//  Dog BreedsTests
//
//  Created by Ioanna Karageorgou on 21/1/24.
//

import Foundation

@testable import Dog_Breeds

class MockBreedsRepository: BreedsRepositoryProtocol {

    var mockDogBreeds: [Breed]?
    var mockBreedImages: [BreedImage]?
    var mockLikedBreedImages: [LikedBreed]?

    func fetchAllDogBreedsFromServer() async throws -> [Breed] {
        if let mockDogBreeds = mockDogBreeds {
            return mockDogBreeds
        } else {
            throw MockError.noMockData
        }
    }

    func fetchAllImagesFromServer(for breed: String) async throws -> [BreedImage] {
        if let mockBreedImages = mockBreedImages {
            return mockBreedImages
        } else {
            throw MockError.noMockData
        }
    }

    func saveLikedBreedImageToRealm(_ likedBreedImage: LikedBreed) async {
        if var mockLikedBreedImages = mockLikedBreedImages {
            mockLikedBreedImages.append(likedBreedImage)
            self.mockLikedBreedImages = mockLikedBreedImages
        } else {
            self.mockLikedBreedImages = [likedBreedImage]
        }
    }

    func removeLikedBreedImageFromRealm(for breed: Breed, and breedImage: BreedImage) async {
        if var mockLikedBreedImages = mockLikedBreedImages {
            mockLikedBreedImages.removeAll { $0.breedName == breed.name && $0.imageURL == breedImage.image.absoluteString }
            self.mockLikedBreedImages = mockLikedBreedImages
        }
    }

    func fetchAllLikedBreedImagesFromRealm() async throws -> [LikedBreed] {
        if let mockLikedBreedImages = mockLikedBreedImages {
            return mockLikedBreedImages
        } else {
            throw MockError.noMockData
        }
    }

    func fetchLikedBreedImagesFromRealm(for breed: Breed) async throws -> [LikedBreed] {
        if let mockLikedBreedImages = mockLikedBreedImages {
            return mockLikedBreedImages.filter { $0.breedName == breed.name }
        } else {
            throw MockError.noMockData
        }
    }

    enum MockError: Error {
        case noMockData
    }
}
