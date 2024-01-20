//
//  BreedImageViewController.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 19/1/24.
//

import UIKit

class BreedImageViewController: UIViewController {
    var viewModel: BreedImageViewModel!

    var selectedBreed: Breed? = Breed(name: "hound")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppConstants.backgroundColor

        viewModel = BreedImageViewModel()
        viewModel.selectedBreed = selectedBreed

        Task {
            await viewModel.fetchAllImages()
        }
    }
}
