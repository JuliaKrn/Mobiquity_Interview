//
//  SearchResultsController.swift
//  Mobiquity
//
//  Created by Iuliia Korniichuk on 26.02.2021.
//

import UIKit

final class SearchResultsController: UIViewController {
    
    var didChosePreviousTheme: ((String) -> Void)?
    var previousSearchList: (() -> [String])?
    
    private var previousThemes: [String] = []
    private var filteredPreviousThemes: [String] = []
    private var previousSearchTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
       
        previousSearchTableView = setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        previousThemes = previousSearchList?() ?? []
        filteredPreviousThemes = previousSearchList?() ?? []
        
        previousSearchTableView.reloadData()
    }
    
    private func setupTableView() -> UITableView {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        setupConstraints(for: tableView)
        
        return tableView
    }

    private func setupConstraints(for tableView: UITableView) {
        view.addSubview(tableView)
        
        tableView.topAnchor
            .constraint(equalTo: view.topAnchor)
            .isActive = true
        tableView.bottomAnchor
            .constraint(equalTo: view.bottomAnchor)
            .isActive = true
        tableView.leadingAnchor
            .constraint(equalTo: view.leadingAnchor)
            .isActive = true
        tableView.trailingAnchor
            .constraint(equalTo: view.trailingAnchor)
            .isActive = true
    }
    
    private func filterThemes(with searchText: String) {
        filteredPreviousThemes = previousThemes.filter { $0.lowercased().contains(searchText.lowercased()) }
        previousSearchTableView.reloadData()
    }

}

// MARK: UITableViewDelegate & UITableViewDataSource
extension SearchResultsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPreviousThemes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = filteredPreviousThemes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard filteredPreviousThemes.indices.contains(indexPath.row) else {
            return
        }
        
        didChosePreviousTheme?(filteredPreviousThemes[indexPath.row])
    }
    
}

// MARK: UISearchResultsUpdating
extension SearchResultsController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }

        filterThemes(with: text)
    }
}
