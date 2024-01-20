//
//  RealmService.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 20/1/24.
//

import Foundation
import RealmSwift

protocol RealmServiceProtocol {
    func saveLikedBreedImage(_ likedBreedImage: LikedBreed) async throws
    func removeLikedBreedImage(for breed: Breed, and breedImage: BreedImage) async throws
    func fetchAllLikedBreedImages() async throws -> [LikedBreed]?
    func fetchLikedBreedImages(for breed: Breed) async throws -> [LikedBreed]?
}

class RealmService: RealmServiceProtocol {
    private let realm: Realm

    init(realm: Realm = try! Realm()) {
        self.realm = realm
    }

    func saveLikedBreedImage(_ likedBreedImage: LikedBreed) async throws {
        try await MainActor.run {
            try realm.write {
                realm.add(likedBreedImage.object())
            }
        }
    }

    func removeLikedBreedImage(for breed: Breed, and breedImage: BreedImage) async throws {
        try await MainActor.run {
            let predicate = NSPredicate(format: "breedName == %@ AND imageURL == %@", breed.name, breedImage.image.absoluteString)
            if let likedBreedImage = realm.objects(LikedBreedObject.self).filter(predicate).first {
                try realm.write {
                    realm.delete(likedBreedImage)
                }
            }
        }
    }

    func fetchAllLikedBreedImages() async throws -> [LikedBreed]? {
        return await MainActor.run {
            let realmObjects = realm.objects(LikedBreedObject.self)
            guard realmObjects.count > 0 else { return nil }
            return realmObjects.compactMap { LikedBreed(object: $0) }
        }
    }

    func fetchLikedBreedImages(for breed: Breed) async throws -> [LikedBreed]? {
        return await MainActor.run {
            let realmObjects = realm.objects(LikedBreedObject.self)
                .filter("breedName == %@", breed.name)
            guard realmObjects.count > 0 else { return nil }
            return realmObjects.compactMap { LikedBreed(object: $0) }
        }
    }
}

