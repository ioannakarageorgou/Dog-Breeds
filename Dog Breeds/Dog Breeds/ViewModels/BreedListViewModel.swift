//
//  BreedsViewModel.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 19/1/24.
//

import Foundation

class BreedsViewModel {
    var breeds: [Breed]?
    var networkError: NetworkError?

    private var repository: BreedsRepositoryProtocol

    init(repository: BreedsRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchAllDogBreeds() async {
        do {
            let list = try await repository.fetchAllDogBreedsFromServer()
            self.breeds = !list.isEmpty ? list : []
        } catch {
            self.networkError = error as? NetworkError
        }
    }
}
