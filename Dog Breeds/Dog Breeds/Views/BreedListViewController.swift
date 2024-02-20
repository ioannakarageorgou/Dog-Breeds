//
//  BreedListViewController.swift
//  Dog Breeds
//
//  Created by Ioanna Karageorgou on 19/1/24.
//

import UIKit

class BreedListViewController: UIViewController {
    var viewModel: BreedListViewModel!
    weak var coordinator: MainCoordinator?

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstants.dogBreedsTitle
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(BreedTableViewCell.self, forCellReuseIdentifier: BreedTableViewCell.identifier)
        tableView.rowHeight = 60.0
        tableView.backgroundColor = .clear
        return tableView
    }()

    private var loadingIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewModel()
        setUpBindings()
        configureUI()
        fetchData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.cancelTasks()
    }
}

private extension BreedListViewController {
    func setUpViewModel() {
        viewModel = BreedListViewModel()
    }

    func setUpBindings() {
        tableView.delegate = self
        tableView.dataSource = self

        viewModel.breedsDidChange = { breeds in
            if breeds != nil {
                self.loadingIndicator.stopAnimating()
                self.tableView.reloadData()
            } else {
                // TODO Handle empty state
                print("No breeds available.")
            }
        }

        viewModel.networkErrorDidChange = { error in
            self.loadingIndicator.stopAnimating()
            // TODO Handle error state
            print("Network error: \(error?.localizedDescription ?? "Unknown error")")

        }
    }

    func configureUI() {
        view.backgroundColor = ColorTheme.Background.primary
        configureTitleLabel()
        configureFavoritesButton()
        configureTable()
        configureLoadingIndicator()
    }

    func configureTable() {
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
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func configureFavoritesButton() {
        let heartSymbolConfiguration = UIImage.SymbolConfiguration(scale: .large)
        let heartImage = UIImage(systemName: AppConstants.heartImageName, withConfiguration: heartSymbolConfiguration)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: heartImage,
            style: .plain,
            target: self,
            action: #selector(showFavorites)
        )
        navigationItem.rightBarButtonItem?.tintColor = ColorTheme.Button.accessory
    }

    @objc private func showFavorites() {
        coordinator?.showFavoriteBreeds()
    }

    func configureLoadingIndicator() {
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
    }

    func fetchData() {
        viewModel.fetchAllDogBreeds()
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
        if let selectedBreed = viewModel.breeds?[indexPath.row] {
            coordinator?.showBreedImages(for: selectedBreed)
        }
    }
}
