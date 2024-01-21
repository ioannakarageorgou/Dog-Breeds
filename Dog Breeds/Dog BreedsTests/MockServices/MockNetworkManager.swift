//
//  MockNetworkManager.swift
//  Dog BreedsTests
//
//  Created by Ioanna Karageorgou on 21/1/24.
//

import Foundation

@testable import Dog_Breeds

class MockNetworkManager: NetworkManagerProtocol {
    var mockResult: Result<Any, NetworkError> = .failure(.noresponse)
    
    func fetchData<T>(resource: HTTPRequestResource<T>) async throws -> Result<T, NetworkError> {
        switch mockResult {
        case .success(let data):
            guard let parsedData = data as? T else {
                throw NetworkError.parsingfailed
            }
            return .success(parsedData)
        case .failure(let error):
            throw error
        }
    }
}
