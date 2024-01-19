//
//  BreedListViewController.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 19/1/24.
//

import UIKit

class BreedListViewController: UIViewController {
    var viewModel: BreedListViewModel!

    private var tableView: UITableView!
    private var loadingIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = BreedListViewModel()

        setUpBindings()
        configureNavigationBar()
        configureTable()
        configureLoadingIndicator()

        Task {
            await viewModel.fetchAllDogBreeds()
        }
    }
}

private extension BreedListViewController {
    func setUpBindings() {
        viewModel.breedsDidChange = { breeds in
            if breeds != nil {
                DispatchQueue.main.async {
                    self.loadingIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
            } else {
                // TODO Handle empty state
                print("No breeds available.")
            }
        }

        viewModel.networkErrorDidChange = { error in
            DispatchQueue.main.async {
                self.loadingIndicator.stopAnimating()
                // TODO Handle error state
                print("Network error: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    func configureNavigationBar() {
        title = AppConstants.dogBreedsTitle
    }

    func configureTable() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BreedTableViewCell.self, forCellReuseIdentifier: BreedTableViewCell.identifier)
        view.addSubview(tableView)
    }

    func configureLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
    }
}

extension BreedListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.breeds?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BreedTableViewCell.identifier, for: indexPath) as! BreedTableViewCell
        if let breed = viewModel.breeds?[indexPath.row] {
            cell.configure(with: breed)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension BreedListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO navigate to screen 2
    }
}
