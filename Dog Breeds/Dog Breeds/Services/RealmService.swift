//
//  RealmService.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 20/1/24.
//

import Foundation
import RealmSwift

protocol RealmServiceProtocol {
    func save(_ likedBreedImages: [LikedBreedImage]) async throws
    func fetchLikedBreedImages() async throws -> [LikedBreedImage]?
}

class RealmService: RealmServiceProtocol {
    private let realm: Realm

    init(realm: Realm = try! Realm()) {
        self.realm = realm
    }

    func save(_ likedBreedImages: [LikedBreedImage]) async throws {
        try await MainActor.run {
            try realm.write {
                realm.add(likedBreedImages, update: .modified)
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

