//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by Dima Shelkov on 10/09/2023.
//

import UIKit

fileprivate enum Constants {
    static let cellIdentifier = "CityCell"
}

protocol SearchViewControllerProtocol: UIViewController {
    func updateWith(_ cities: [City])
    func updateActivity(shouldAnimate: Bool)
}

final class SearchViewController: UIViewController, SearchViewControllerProtocol {
    private enum Section { case main }
    private let presenter: SearchPresenterProtocol
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var dataSource: UITableViewDiffableDataSource<Section, City> = {
        UITableViewDiffableDataSource<Section, City>(tableView: tableView) { tableView, indexPath, city in
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier,
                                                     for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = city.fullCityName
            cell.contentConfiguration = content
            return cell
        }
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: Constants.cellIdentifier)
        tableView.delegate = self
        return tableView
    }()
    
    private let activity = UIActivityIndicatorView(style: .large)
    
    init(presenter: SearchPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layoutSearchBar()
        layoutTableView()
        layoutActivity()
    }
    
    func updateActivity(shouldAnimate: Bool) {
        shouldAnimate ? activity.startAnimating() : activity.stopAnimating()
    }
    
    func updateWith(_ cities: [City]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, City>()
        snapshot.appendSections([.main])
        snapshot.appendItems(cities, toSection: .main)
        dataSource.apply(snapshot)
    }
    
    private func layoutActivity() {
        view.addSubview(activity)
        activity.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activity.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activity.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func layoutSearchBar() {
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    private func layoutTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let city = dataSource.itemIdentifier(for: indexPath) else { return }
        presenter.didSelect(city, from: self)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }
        presenter.search(for: searchText)
    }
}
