//
//  DogBreedsRepository.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 19/1/24.
//

import Foundation

protocol BreedsRepositoryProtocol {
    func fetchAllDogBreedsFromServer() async throws -> [Breed]
}

class BreedsRepository: BreedsRepositoryProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    func fetchAllDogBreedsFromServer() async throws -> [Breed] {
        let resource = RequestConfig.Resource<BreedsListResponse?>(
            urlPath: AppConstants.allDogBreedsUrlPath,
            method: .get
        ) { data in
            return BreedsListResponse.decode(data)
        }

        do {
            let result: Result<BreedsListResponse?, NetworkError> = try await networkManager.fetchData(resource: resource)

            switch result {
            case .success(let response): do {
                guard response?.status == "OK" else { throw NetworkError.requestfailed }
                guard let breeds = response?.message.keys.compactMap({ name -> Breed in
                    return Breed(name: name)
                }) else { throw NetworkError.nodata }

                guard breeds.count > 0 else { throw NetworkError.parsingfailed }
                return breeds
            }
            case .failure(let error):
                throw error
            }
        } catch {
            throw error
        }
    }
}
