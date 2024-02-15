//
//  RealmService.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 20/1/24.
//

import Foundation
import RealmSwift

protocol RealmActorProtocol {
    func saveLikedBreedImage(_ likedBreedImage: LikedBreed) async throws
    func removeLikedBreedImage(for breed: Breed, and breedImage: BreedImage) async throws
    func fetchAllLikedBreedImages() async throws -> [LikedBreed]?
    func fetchLikedBreedImages(for breed: Breed) async throws -> [LikedBreed]?
}

actor RealmActor: RealmActorProtocol {
    var realm: Realm!

    private init() async {
        realm = try! await Realm(actor: self)
    }

    private static var sharedTask: Task<RealmActor, Never>?

    static func shared() async -> RealmActor {
        if let sharedTask {
            return await sharedTask.value
        }
        let task = Task { await RealmActor() }
        sharedTask = task
        return await task.value
    }

    func saveLikedBreedImage(_ likedBreedImage: LikedBreed) async throws {
        try await realm.asyncWrite {
            realm.add(likedBreedImage.object())
        }
    }

    func removeLikedBreedImage(for breed: Breed, and breedImage: BreedImage) async throws {
        let predicate = NSPredicate(format: "breedName == %@ AND imageURL == %@", breed.name, breedImage.image.absoluteString)
        if let likedBreedImage = realm.objects(LikedBreedObject.self).filter(predicate).first {
            try await realm.asyncWrite {
                realm.delete(likedBreedImage)
            }
        }
    }

    func fetchAllLikedBreedImages() async throws -> [LikedBreed]? {

        // asyncRefresh() can only be called on main thread or actor-isolated Realms
        await realm.asyncRefresh()

        let realmObjects = realm.objects(LikedBreedObject.self)
        guard realmObjects.count > 0 else { return nil }
        return realmObjects.compactMap { LikedBreed(object: $0) }
    }

    func fetchLikedBreedImages(for breed: Breed) async throws -> [LikedBreed]? {
        await realm.asyncRefresh()

        let realmObjects = realm.objects(LikedBreedObject.self)
            .filter("breedName == %@", breed.name)
        guard realmObjects.count > 0 else { return nil }
        return realmObjects.compactMap { LikedBreed(object: $0) }
    }
}

