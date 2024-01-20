//
//  LikedBreedImage.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 20/1/24.
//

import Foundation
import RealmSwift

class LikedBreedImage: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var breedName = ""
    @objc dynamic var imageURL = ""

    override static func primaryKey() -> String? {
        return "id"
    }

    convenience init(breed: Breed, breedImage: BreedImage) {
        self.init()
        self.breedName = breed.name
        self.imageURL = breedImage.image.absoluteString
    }
}
