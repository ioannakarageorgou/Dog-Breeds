//
//  Breed.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 19/1/24.
//

import Foundation

struct Breed: Decodable, Identifiable, Comparable {
    var id = UUID()
    let name: String

    static func < (lhs: Breed, rhs: Breed) -> Bool{
        return lhs.name < rhs.name
    }

    static func > (lhs: Breed, rhs: Breed) -> Bool{
        return lhs.name > rhs.name
    }
}
