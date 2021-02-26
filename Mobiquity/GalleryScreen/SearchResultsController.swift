//
//  SearchResultsController.swift
//  Mobiquity
//
//  Created by Iuliia Korniichuk on 26.02.2021.
//

import UIKit

class SearchResultsController: UIViewController {
    
    let dummyArray = ["cats", "dogs", "city", "ocean"]
    
    private var previousSearchTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        previousSearchTableView = setupTableView()
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

}

// MARK: UITableViewDelegate & UITableViewDataSource
extension SearchResultsController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        cell.textLabel?.text = dummyArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // go back to main vc and start loading
    }
    
}
