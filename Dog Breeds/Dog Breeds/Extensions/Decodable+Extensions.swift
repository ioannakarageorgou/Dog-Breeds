//
//  Decodable+Extensions.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 19/1/24.
//

import Foundation

extension Decodable {
    static func decode<T: Decodable>(_ data: Data) -> T? {
        do {
            let responseModel = try decodeResponseModel(T.self, from: data)
            return responseModel
        } catch {
//            print(Self.self, error.localizedDescription)
            return nil
        }
    }

    private static func decodeResponseModel<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(type, from: data)
    }
}
