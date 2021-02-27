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

    private var galleryCollectionView: UICollectionView!
    private var isLoading: Bool = false
    private var viewValues: GalleryViewValuesProtocol {
        return viewModel.viewValues
    }
    
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
        isLoading = true
        galleryCollectionView.reloadData()
    }
    
    private func renderLoadedState(values: GalleryViewValuesProtocol) {
        isLoading = false
        galleryCollectionView.reloadData()
    }
    
    private func renderErrorState(values: GalleryViewValuesProtocol) {
        isLoading = false
        galleryCollectionView.reloadData()
        showError()
    }
    
    // MARK: Error
    private func showError() {
        let alert = UIAlertController(title: viewModel.viewValues.errorTitle,
                                      message: viewModel.viewValues.errorMessage,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }

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
        let side = view.frame.width / 2 - Constants.standardPadding
        flowLayout.itemSize = CGSize(width: side, height: side)
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing = 0.0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.reuseIdentifier)
        collectionView.register(LoadingReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingReusableView.reuseIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        setupConstraints(for: collectionView)
        
        return collectionView
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

}

// MARK: - Collection View Data & Delegate
extension GalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewValues.photosToShow.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.reuseIdentifier, for: indexPath) as? GalleryCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard viewValues.photosToShow.indices.contains(indexPath.row) else {
            return cell
        }
        
        let image = viewValues.photosToShow[indexPath.row]
        cell.setup(with: image)
        
        return cell
    }
    
    // Due to a bug in Swift related to generic subclases, we have to specify ObjC delegate method name
    // if it's different than Swift name (https://bugs.swift.org/browse/SR-2817).
    @objc (collectionView:viewForSupplementaryElementOfKind:atIndexPath:)
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionFooter else {
            return UICollectionReusableView()
        }
        
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LoadingReusableView", for: indexPath as IndexPath)
        return footerView
    }

    @objc (collectionView:layout:referenceSizeForFooterInSection:)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if isLoading {
            return CGSize(width: collectionView.bounds.width, height: 100)
        } else {
            return CGSize.zero
        }
    }
    
}

extension GalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == (viewValues.photosToShow.count - 10) && !isLoading {
            isLoading = true
            viewModel.loadMorePhotos()
        }
    }
    
    // TODO: add state when there is no moro photos to load
}

// MARK: - Search Controller Delegate
extension GalleryViewController: UISearchControllerDelegate {
    
}
