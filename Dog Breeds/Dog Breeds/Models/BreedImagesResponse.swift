//
//  BreedImagesResponse.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 19/1/24.
//

import Foundation

struct BreedImagesResponse: Decodable {
    let message: [String]
    let status: String
}
