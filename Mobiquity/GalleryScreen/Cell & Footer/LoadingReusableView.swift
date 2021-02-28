//
//  LoadingReusableView.swift
//  Mobiquity
//
//  Created by Iuliia Korniichuk on 26.02.2021.
//

import UIKit

final class LoadingReusableView: UICollectionReusableView {
    
    static let reuseIdentifier = "LoadingReusableView"
    
    private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Public Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }

    private func setupUI() {
        backgroundColor = .clear
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(activityIndicator)
        
        activityIndicator.centerYAnchor
            .constraint(equalTo: centerYAnchor)
            .isActive = true
        activityIndicator.centerXAnchor
            .constraint(equalTo: centerXAnchor)
            .isActive = true
    }
        
}
