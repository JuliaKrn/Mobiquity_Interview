//
//  GalleryViewController.swift
//  Mobiquity
//
//  Created by Iuliia Korniichuk on 25.02.2021.
//

import UIKit

protocol GalleryViewProtocol {

    
}

class GalleryViewController: UIViewController, GalleryViewProtocol {
    
    // MARK: Constants
    private enum Constants {
        static let smallPadding: CGFloat = 8.0
        static let standardPadding: CGFloat = 20.0
        static let largePadding: CGFloat = 36.0
    }
    
    // MARK: Properties
    var viewModel: GalleryViewModelProtocol!

    private var searchStackView: UIStackView!
    
    private var galleryCollectionView: UICollectionView!
    
    private var searchBar: UISearchBar!
    
    private lazy var cellSize: CGSize = {
        let side = (view.frame.width / 2 - Constants.standardPadding)
        return CGSize(width: side, height: side)
    }()
    
    // MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.updateValues = { [weak self] in
            DispatchQueue.main.async {
                self?.render()
            }
        }
        
        setup()
        render()
    }

}

// MARK: - View Rendering
extension GalleryViewController {
    
    private func render() {
        switch viewModel.viewState {
        case .loading(let values):
            renderLoadingState(values: values)
        case .loaded(let values):
            renderLoadedState(values: values)
        case .error(let values):
            renderErrorState(values: values)
        }
    }
    
    private func renderLoadingState(values: GalleryViewValuesProtocol) {
        // 1. Start loading
    }
    
    private func renderLoadedState(values: GalleryViewValuesProtocol) {
        // 1. Stop loading
        // 2. Reload collection view
    }
    
    private func renderErrorState(values: GalleryViewValuesProtocol) {
        // 1. Stop loading
        // 2. Show error
    }
    
    // MARK: Error & Loader
    private func showError() {
        let alert = UIAlertController(title: viewModel.viewValues.errorTitle,
                                      message: viewModel.viewValues.errorMessage,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // TODO: add loader
    
}

// MARK: - UI Setup
extension GalleryViewController {
    
    private func setup() {
        setupNavigationBar()
        setupGallerySection()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = viewModel.viewValues.screenName
        setupSearchController()
    }
    
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: SearchResultsController())
        navigationItem.searchController = searchController
        
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.hidesSearchBarWhenScrolling = true
        
        searchController.delegate = self
    }

    private func setupGallerySection() {
        galleryCollectionView = setupCollectionView()
    }

    private func setupCollectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = cellSize
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.reuseIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        setupConstraints(for: collectionView)
        
        return collectionView
    }
    
    private func setupActivityIndicatorView() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.style = .large
        setupConstraints(for: view)
        
        return view
    }
    
    // MARK: Constraints
    private func setupConstraints(for collectionView: UICollectionView) {
        view.addSubview(collectionView)
        
        collectionView.topAnchor
            .constraint(equalTo: view.topAnchor)
            .isActive = true
        collectionView.bottomAnchor
            .constraint(equalTo: view.bottomAnchor)
            .isActive = true
        collectionView.leadingAnchor
            .constraint(equalTo: view.leadingAnchor, constant: Constants.standardPadding)
            .isActive = true
        collectionView.trailingAnchor
            .constraint(equalTo: view.trailingAnchor, constant: -Constants.standardPadding)
            .isActive = true
    }
    
    private func setupConstraints(for indicatorView: UIActivityIndicatorView) {
        view.addSubview(indicatorView)
        
        indicatorView.centerYAnchor
            .constraint(equalTo: view.centerYAnchor)
            .isActive = true
        indicatorView.centerXAnchor
            .constraint(equalTo: view.centerXAnchor)
            .isActive = true
    }
}

extension GalleryViewController: UISearchControllerDelegate {
    
}

// MARK: - Collection View Data & Delegate
extension GalleryViewController: UICollectionViewDelegate {
    
}

extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: add real data
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionViewCell", for: indexPath) as? GalleryCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        // TODO: add real data
        let image = UIImage(named: "photo_placeholder_icon")!
        cell.setup(with: image)
        
        return cell
    }
    
}

extension GalleryViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
    }
    
}

extension GalleryViewController: UISearchBarDelegate {
    
}
