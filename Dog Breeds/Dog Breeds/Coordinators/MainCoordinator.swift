//
//  MainCoordinator.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 20/1/24.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    func showBreedImages(for breed: Breed)
}

class MainCoordinator: Coordinator {
    private var navigationController: UINavigationController?
    private var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let breedListViewController = BreedListViewController()
        breedListViewController.coordinator = self
        navigationController = UINavigationController(rootViewController: breedListViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func showBreedImages(for breed: Breed) {
        let breedImageVC = BreedImageViewController()
        breedImageVC.selectedBreed = breed
        navigationController?.pushViewController(breedImageVC, animated: true)
    }
}
