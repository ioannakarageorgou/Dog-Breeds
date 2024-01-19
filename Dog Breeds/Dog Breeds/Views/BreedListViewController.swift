//
//  BreedListViewController.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 19/1/24.
//

import UIKit

class BreedListViewController: UIViewController {

    var viewModel: BreedListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = BreedListViewModel()

        setUpBindings()

        Task {
            await viewModel.fetchAllDogBreeds()
        }
    }
}

private extension BreedListViewController{
    func setUpBindings() {
        viewModel.breedsDidChange = { breeds in
            if let breeds = breeds {
                print("Fetched breeds: \(breeds)")
            } else {
                print("No breeds available.")
            }
        }

        viewModel.networkErrorDidChange = { error in
            // TODO Handle error state
            print("Network error: \(error?.localizedDescription ?? "Unknown error")")
        }
    }
}
