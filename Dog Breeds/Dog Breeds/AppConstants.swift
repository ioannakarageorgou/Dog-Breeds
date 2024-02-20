//
//  AppConstants.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 19/1/24.
//

import Foundation
import UIKit

struct AppConstants {
    // Network
    static let baseUrl = "https://dog.ceo/api"
    static let allDogBreedsUrlPath = "/breeds/list/all"
    static let allBreedImagesUrlPath = "/breed/%@/images"
    static let success = "success"

    // Strings
    static let dogBreedsTitle = "Dog Breeds"
    static let like = "Like"
    static let liked = "Liked"
    static let favoriteBreedsTitle = "Favorite Breeds"

    // Images
    static let heartImageName = "heart"
    static let heartFillImageName = "heart.fill"
    static let defaultDogImageName = "default_dog"
}
