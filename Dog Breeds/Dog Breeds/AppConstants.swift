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

    // Colors
    static let primaryBackgroundColor = UIColor(hex: "#ededf2")
    static let secondaryBackgroundColor = UIColor(hex: "#f6f6f6")
    static let customBrown = UIColor(hex: "#8e6048")

    // Images
    static let heartImageName = "heart"
    static let heartFillImageName = "heart.fill"
    static let defaultDogImageName = "default_dog"
}
