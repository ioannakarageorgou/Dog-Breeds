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

    // Titles
    static let dogBreedsTitle = "Dog Breeds"

    // Colors
    static let backgroundColor = UIColor(hex: "#ededf2")
    static let cellBackgroundColor = UIColor(hex: "#f6f6f6")
    static let heartColor = UIColor(hex: "#8e6048")

    // Images
    static let heartImageName = "heart"
}
