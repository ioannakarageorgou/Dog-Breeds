//
//  BreedListViewController.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 19/1/24.
//

import UIKit

class BreedListViewController: UIViewController {
    var viewModel: BreedListViewModel!

    private var titleLabel: UILabel!
    private var tableView: UITableView!
    private var loadingIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppConstants.backgroundColor
        viewModel = BreedListViewModel()

        setUpBindings()
        configureTitleLabel()
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

    func configureTable() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BreedTableViewCell.self, forCellReuseIdentifier: BreedTableViewCell.identifier)
        tableView.rowHeight = 60.0
        tableView.backgroundColor = .clear
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    func configureTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = AppConstants.dogBreedsTitle
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
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
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        if let breed = viewModel.breeds?[indexPath.row] {
            cell.configure(with: breed)
        }
        return cell
    }
}

extension BreedListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO navigate to screen 2
    }
}
