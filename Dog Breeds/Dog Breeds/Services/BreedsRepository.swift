//
//  DogBreedsRepository.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 19/1/24.
//

import Foundation

protocol BreedsRepositoryProtocol {
    func fetchAllDogBreedsFromServer() async throws -> [Breed]
    func fetchAllImagesFromServer(for breed: String) async throws -> [BreedImage]

    func saveLikedBreedImageToRealm(_ likedBreedImage: LikedBreed) async
    func removeLikedBreedImageFromRealm(for breed: Breed, and breedImage: BreedImage) async

    func fetchAllLikedBreedImagesFromRealm() async throws -> [LikedBreed]
    func fetchLikedBreedImagesFromRealm(for breed: Breed) async throws -> [LikedBreed]
}

class BreedsRepository: BreedsRepositoryProtocol {

    private let networkManager: NetworkManagerProtocol
    private var realmService: RealmServiceProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager(), realmService: RealmServiceProtocol = RealmService.shared) {
        self.networkManager = networkManager
        self.realmService = realmService
    }

    func fetchAllDogBreedsFromServer() async throws -> [Breed] {
        let resource = RequestConfig.Resource<BreedsListResponse?>(
            urlPath: AppConstants.allDogBreedsUrlPath,
            method: .get
        ) { data in
            return BreedsListResponse.decode(data)
        }

        do {
            let result: Result<BreedsListResponse?, NetworkError> = try await networkManager.fetchData(resource: resource)

            switch result {
            case .success(let response): do {
                guard response?.status == AppConstants.success else { throw NetworkError.requestfailed }
                guard let breeds = response?.message.keys.compactMap({ name -> Breed in
                    return Breed(name: name)
                }) else { throw NetworkError.nodata }

                guard breeds.count > 0 else { throw NetworkError.parsingfailed }
                return breeds
            }
            case .failure(let error):
                throw error
            }
        } catch {
            throw error
        }
    }

    func fetchAllImagesFromServer(for breed: String) async throws -> [BreedImage] {
        let resource = RequestConfig.Resource<BreedImagesResponse?>(
            urlPath: String(format: AppConstants.allBreedImagesUrlPath, breed),
            method: .get
        ) { data in
            return BreedImagesResponse.decode(data)
        }

        do {
            let result: Result<BreedImagesResponse?, NetworkError> = try await networkManager.fetchData(resource: resource)

            switch result {
            case .success(let response): do {
                guard response?.status == AppConstants.success else { throw NetworkError.requestfailed }
                let list = response?.message.compactMap{ URL(string: $0) }
                guard let breedImages = list?.compactMap({ url in
                    return BreedImage(image: url)
                }) else { throw NetworkError.nodata }

                guard breedImages.count > 0 else { throw NetworkError.parsingfailed }
                return breedImages
            }
            case .failure(let error):
                throw error
            }
        } catch {
            throw error
        }
    }

    func saveLikedBreedImageToRealm(_ likedBreedImage: LikedBreed) async {
        do {
            try await realmService.saveLikedBreedImage(likedBreedImage)
        } catch {
            print("Error saving liked breed image to Realm: \(error)")
        }
    }

    func removeLikedBreedImageFromRealm(for breed: Breed, and breedImage: BreedImage) async {
        do {
            try await realmService.removeLikedBreedImage(for: breed, and: breedImage)
        } catch {
            print("Error removing liked breed image from Realm: \(error)")
        }
    }

    func fetchAllLikedBreedImagesFromRealm() async throws -> [LikedBreed] {
        do {
            return try await realmService.fetchAllLikedBreedImages() ?? []
        } catch {
            print("Error fetching all liked breed images from Realm: \(error)")
            throw error
        }
    }

    func fetchLikedBreedImagesFromRealm(for breed: Breed) async throws -> [LikedBreed] {
        do {
            return try await realmService.fetchLikedBreedImages(for: breed) ?? []
        } catch {
            print("Error fetching liked breed images from Realm for breed \(breed.name): \(error)")
            throw error
        }
    }
}
