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
        static let footerHeight: CGFloat = 100.0
    }
    
    // MARK: Properties
    var viewModel: GalleryViewModelProtocol!

    private var galleryCollectionView: UICollectionView!
    private var isLoading: Bool = false
    
    private var viewValues: GalleryViewValuesProtocol {
        return viewModel.viewValues
    }
    
    private lazy var loadingIndicator: UIActivityIndicatorView! = {
        return setupActivityIndicatorView()
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
        isLoading = true
        galleryCollectionView.reloadData()
    }
    
    private func renderLoadedState(values: GalleryViewValuesProtocol) {
        isLoading = false
        galleryCollectionView.reloadData()
        updateScreenLoader(shouldEnable: false)
    }
    
    private func renderErrorState(values: GalleryViewValuesProtocol) {
        isLoading = false
        galleryCollectionView.reloadData()
        updateScreenLoader(shouldEnable: false)
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
    
    // MARK: Loader
    private func updateScreenLoader(shouldEnable: Bool) {
        galleryCollectionView.isUserInteractionEnabled = !shouldEnable
        loadingIndicator.isHidden = !shouldEnable
        shouldEnable ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
    }
    
}

// MARK: - UI Setup
extension GalleryViewController {
    
    private func setup() {
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupGallerySection()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = viewModel.viewValues.screenName
        setupSearchController()
    }
    
    private func setupSearchController() {
        let resultsController = SearchResultsController()
        let searchController = UISearchController(searchResultsController: resultsController)
        
        searchController.searchResultsUpdater = resultsController
        searchController.searchBar.delegate = self
        resultsController.didChosePreviousTheme = { [weak self] theme in
            self?.didChose(theme: theme)
        }
        resultsController.previousSearchList = { [weak self] in
            self?.viewModel.getSearchList() ?? []
        }
        
        navigationItem.searchController = searchController
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.hidesSearchBarWhenScrolling = true
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

    private func setupActivityIndicatorView() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.style = .large
        view.color = .systemIndigo
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
        
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadingReusableView.reuseIdentifier, for: indexPath as IndexPath)
        return footerView
    }

    @objc (collectionView:layout:referenceSizeForFooterInSection:)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if isLoading {
            return CGSize(width: collectionView.bounds.width, height: Constants.footerHeight)
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

}

// MARK: - Search Bar Delegates
extension GalleryViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        
        didChose(theme: text)
    }
    
    private func didChose(theme:String) {
        updateScreenLoader(shouldEnable: true)
        viewModel.didChoseTheme(theme)
        
        navigationItem.searchController?.searchBar.text = ""
        navigationItem.searchController?.dismiss(animated: true, completion: nil)
    }

}
