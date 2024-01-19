//
//  BreedsApiModel.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 19/1/24.
//

import Foundation

struct BreedsListResponse: Decodable {
    let message: [String: [String]]
    let status: String
}
