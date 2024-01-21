//
//  LikedBreedImage.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 20/1/24.
//

import Foundation
import RealmSwift

class LikedBreed: Decodable {
    let imageURL: String?
    let breedName: String?

    required init(imageURL: String?, breedName: String?) {
        self.imageURL = imageURL
        self.breedName = breedName
    }

    required init(object: LikedBreedObject) {
        breedName = object.breedName
        imageURL = object.imageURL
    }
}

class LikedBreedObject: Object {
    @Persisted(primaryKey: true)var imageURL: String?
    @Persisted var breedName: String?

    func original() -> LikedBreed {
        return LikedBreed(object: self)
    }
}

protocol Persistable {
    associatedtype Object: RealmSwift.Object

    init(object: Object)
    func object() -> Object
}

extension LikedBreed: Persistable {
    func object() -> LikedBreedObject {
        let likedBreed = LikedBreedObject()
        likedBreed.breedName = breedName
        likedBreed.imageURL = imageURL
        return likedBreed
    }
}

extension LikedBreed: Equatable {
    static func == (lhs: LikedBreed, rhs: LikedBreed) -> Bool {
        return lhs.imageURL == rhs.imageURL && lhs.breedName == rhs.breedName
    }
}
