//
//  BreedViewModel.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 19/1/24.
//

import Foundation

@MainActor
class BreedListViewModel {
    var breeds: [Breed]? {
        didSet {
            breedsDidChange?(breeds)
        }
    }
    
    var networkError: NetworkError? {
        didSet {
            networkErrorDidChange?(networkError)
        }
    }

    var breedsDidChange: (([Breed]?) -> Void)?
    var networkErrorDidChange: ((NetworkError?) -> Void)?

    private var repository: BreedsRepositoryProtocol
    private var tasks: [Task<Void, Never>] = []

    init(repository: BreedsRepositoryProtocol = BreedsRepository()) {
        self.repository = repository
    }

    func fetchAllDogBreeds() {
        let task = Task {
            do {
                let list = try await repository.fetchAllDogBreedsFromServer()
                self.breeds = !list.isEmpty ? list.sorted() : []
            } catch {
                self.networkError = error as? NetworkError
            }
        }
        tasks.append(task)
    }

    func cancelTasks() {
        tasks.forEach({ $0.cancel() })
        tasks = []
    }
}
