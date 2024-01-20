//
//  RealmService.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 20/1/24.
//

import Foundation
import RealmSwift

protocol RealmServiceProtocol {
    func saveLikedBreedImage(_ likedBreedImage: LikedBreedImage) async throws
    func removeLikedBreedImage(for breed: Breed, and breedImage: BreedImage) async throws
    func fetchLikedBreedImages() async throws -> [LikedBreedImage]?
}

class RealmService: RealmServiceProtocol {
    private let realm: Realm

    init(realm: Realm = try! Realm()) {
        self.realm = realm
    }
    
    func saveLikedBreedImage(_ likedBreedImage: LikedBreedImage) async throws {
        try await MainActor.run {
            try realm.write {
                realm.add(likedBreedImage)
            }
        }
    }

    func removeLikedBreedImage(for breed: Breed, and breedImage: BreedImage) async throws {
        try await MainActor.run {
            let predicate = NSPredicate(format: "breedName == %@ AND imageURL == %@", breed.name, breedImage.image.absoluteString)
            if let likedBreedImage = realm.objects(LikedBreedImage.self).filter(predicate).first {
                try realm.write {
                    realm.delete(likedBreedImage)
                }
            }
        }
    }

    func fetchLikedBreedImages() async throws -> [LikedBreedImage]? {
        return await MainActor.run {
            let realmObjects = realm.objects(LikedBreedImage.self)
            guard realmObjects.count > 0 else { return nil }
            return realmObjects.compactMap { $0 }
        }
    }
}

