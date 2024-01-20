//
//  BreedImage.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 19/1/24.
//

import Foundation

struct BreedImage: Decodable, Identifiable, Equatable {
    var id = UUID()
    let image: URL
    var isLiked: Bool = false
}
